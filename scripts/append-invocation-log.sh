#!/usr/bin/env bash
# append-invocation-log.sh — Append invocation_log entry + write GSD output
#
# Usage: bash append-invocation-log.sh <intent> <routed_skill> <status> <error_summary> <execution_summary> <phase> <plan> <duration_ms>
#
# Called from scientific-do Step 5 after verification.
# Handles: mkdir lock, JSON append, trim, archive, counter sync, trigger return, GSD output
#
# Inputs:
#   All positional arguments — the invocation_log entry fields
# Environment variables:
#   GSD_PROJECT_ROOT — set when inside GSD project (from Step 1)
#   FEEDBACK_DIR — defaults to ~/.claude/scientific-skills
#
# Output: JSON to stdout with trigger flags: {"rating": bool, "update_check": bool}
set -euo pipefail

# --- Config ---
FEEDBACK_DIR="${FEEDBACK_DIR:-$HOME/.claude/scientific-skills}"
STATE_FILE="$FEEDBACK_DIR/feedback-state.json"
ARCHIVE_FILE="$FEEDBACK_DIR/invocation-log-archive.json"
LOCK_DIR="$FEEDBACK_DIR/.feedback-state.lock"
MAX_LOG=200
RETRIES=3
RETRY_DELAY=0.2

# --- Parse args with defaults ---
INTENT="${1:-}"
ROUTED_SKILL="${2:-}"
STATUS="${3:-success}"
ERROR_SUMMARY="${4:-}"
EXECUTION_SUMMARY="${5:-}"
PHASE="${6:-null}"
PLAN="${7:-null}"
DURATION_MS="${8:-0}"

# --- acquire_lock: mkdir-based concurrency lock with stale guard ---
acquire_lock() {
  # Try fast path first
  if mkdir "$LOCK_DIR" 2>/dev/null; then
    return 0
  fi

  # Check for stale lock only if fast path failed
  if [ -d "$LOCK_DIR" ]; then
    local now lock_mtime
    now=$(date +%s 2>/dev/null || node -e "console.log(Math.floor(Date.now()/1000))")
    lock_mtime=$(stat -c %Y "$LOCK_DIR" 2>/dev/null || node -e "
      try {
        const s = require('fs').statSync('$LOCK_DIR');
        console.log(Math.floor(s.mtimeMs/1000));
      } catch(e) { console.log(0); }
    ")
    if [ -n "$now" ] && [ -n "$lock_mtime" ] && [ $((now - lock_mtime)) -gt 10 ] 2>/dev/null; then
      rm -rf "$LOCK_DIR" 2>/dev/null || true
      # Attempt to acquire after removal — this may fail if another process
      # created the lock between removal and mkdir, which is handled by the retry loop
      mkdir "$LOCK_DIR" 2>/dev/null && return 0
    fi
  fi

  # Retry with backoff
  for i in $(seq 2 $RETRIES); do
    sleep $RETRY_DELAY
    if mkdir "$LOCK_DIR" 2>/dev/null; then
      return 0
    fi
  done
  echo "[WARN] Could not acquire lock after $RETRIES retries" >&2
  return 1
}

# --- release_lock: remove lock directory ---
release_lock() {
  rm -rf "$LOCK_DIR" 2>/dev/null || true
}

# --- write_gsd_output: write SD-SUMMARY.md or SD-SUPPLEMENT.md ---
write_gsd_output() {
  local intent="$1"
  local routed_skill="$2"
  local status="$3"
  local execution_summary="$4"
  local phase="$5"
  local plan="$6"
  local duration_ms="$7"

  # Skip if not inside GSD project
  if [ -z "${GSD_PROJECT_ROOT:-}" ]; then
    return 0
  fi

  # Skip if no phase context
  if [ -z "$phase" ] || [ "$phase" = "null" ]; then
    return 0
  fi

  # Resolve phase directory under GSD_PROJECT_ROOT/.planning/phases/
  local phase_dir=""
  # Try original phase value first, then zero-padded (2-digit)
  phase_dir=$(ls -d "$GSD_PROJECT_ROOT/.planning/phases/${phase}-"* 2>/dev/null | head -1)
  if [ -z "$phase_dir" ]; then
    local padded
    padded=$(printf "%02d" "$(echo "$phase" | sed 's/^0*//' 2>/dev/null || echo "0")" 2>/dev/null || echo "$phase")
    phase_dir=$(ls -d "$GSD_PROJECT_ROOT/.planning/phases/${padded}-"* 2>/dev/null | head -1)
  fi

  # Fallback: use phase value as-is
  if [ -z "$phase_dir" ]; then
    phase_dir="$GSD_PROJECT_ROOT/.planning/phases/${phase}"
    mkdir -p "$phase_dir"
  fi

  # Determine filename: SUPPLEMENT if plan present, SUMMARY otherwise
  local filename="SD-SUMMARY.md"
  if [ -n "$plan" ] && [ "$plan" != "null" ]; then
    filename="SD-SUPPLEMENT.md"
  fi

  local output_file="$phase_dir/$filename"

  # Validate output path is under GSD_PROJECT_ROOT/.planning/phases/
  # Resolve to canonical path to block directory traversal
  local output_dir output_norm prefix_norm
  output_dir=$(dirname "$output_file" 2>/dev/null)
  output_norm=$(cd "$output_dir" 2>/dev/null && pwd -P)/$(basename "$output_file") || output_norm="${output_file//\\//}"
  output_norm="${output_norm//\\//}"
  prefix_norm="${GSD_PROJECT_ROOT//\\//}/.planning/phases/"

  case "$output_norm" in
    ${prefix_norm}*)
      # Path is valid — proceed
      ;;
    *)
      echo "[WARN] Output path outside allowed directory: $output_file" >&2
      return 0
      ;;
  esac

  node -e "
const fs = require('fs');
const entry = {
  source: 'scientific-do',
  phase: JSON.parse(process.argv[1]),
  plan: JSON.parse(process.argv[2]),
  generated_at: new Date().toISOString(),
  intent: JSON.parse(process.argv[3]),
  routed_skill: JSON.parse(process.argv[4]),
  status: JSON.parse(process.argv[5])
};
const body = '---\n' +
  Object.entries(entry).map(function(kv) {
    var k = kv[0], v = kv[1];
    return k + ': ' + (v === null ? '~' : String(v));
  }).join('\n') +
  '\n---\n\n' +
  JSON.parse(process.argv[6]) + '\n\n' +
  '**Duration:** ' + process.argv[7] + ' ms\n\n';
fs.appendFileSync(process.argv[8], body, 'utf8');
" "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$phase")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$plan")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$intent")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$routed_skill")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$status")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$execution_summary")" \
  "$duration_ms" "$output_file"
}

# --- Main ---

# Acquire lock
if ! acquire_lock; then
  echo "[ERROR] Lock acquisition failed — skipping invocation log write" >&2
  exit 1
fi

# Ensure state file exists with defaults
if [ ! -f "$STATE_FILE" ]; then
  echo '{"counter":0,"invocation_log":[],"last_feedback_at":null,"last_update_check_at":null,"ratings":[],"skill_states":{},"gaps":[],"version":1}' > "$STATE_FILE"
fi

# Read, modify, write state file via node -e (single atomic operation inside lock)
TRIGGER_JSON=$(node -e "
const fs = require('fs');
const state = JSON.parse(fs.readFileSync('$STATE_FILE', 'utf8'));

// Build D-01 entry
const ts = new Date().toISOString();
const entry = {
  timestamp: ts,
  intent: JSON.parse(process.argv[1]),
  routed_skill: JSON.parse(process.argv[2]),
  status: JSON.parse(process.argv[3]),
  error_summary: JSON.parse(process.argv[4]),
  execution_summary: JSON.parse(process.argv[5]),
  phase: JSON.parse(process.argv[6]),
  plan: JSON.parse(process.argv[7]),
  duration_ms: parseInt(process.argv[8], 10) || 0
};

// Normalize string "null" to JSON null for phase/plan
function toNull(val) { return val === 'null' ? null : val; }
entry.phase = toNull(entry.phase);
entry.plan = toNull(entry.plan);

// Append to invocation_log
state.invocation_log = state.invocation_log || [];
state.invocation_log.push(entry);

// Trim to MAX_LOG and archive older entries
if (state.invocation_log.length > $MAX_LOG) {
  var removed = state.invocation_log.slice(0, state.invocation_log.length - $MAX_LOG);
  state.invocation_log = state.invocation_log.slice(-$MAX_LOG);
  try {
    var archive = [];
    try { archive = JSON.parse(fs.readFileSync('$ARCHIVE_FILE', 'utf8')); } catch(e) {}
    if (!Array.isArray(archive)) archive = [];
    archive.push.apply(archive, removed);
    fs.writeFileSync('$ARCHIVE_FILE', JSON.stringify(archive), 'utf8');
  } catch(e) {
    console.error('[WARN] Archive write failed: ' + e.message);
  }
}

// Sync counter = invocation_log.length per D-02
state.counter = state.invocation_log.length;

fs.writeFileSync('$STATE_FILE', JSON.stringify(state, null, 2), 'utf8');

// Output trigger flags for caller
var trig_rating = (state.counter % 10 === 0) && state.counter > 0;
var trig_update = (state.counter % 20 === 0) && state.counter > 0;
console.log(JSON.stringify({rating: trig_rating, update_check: trig_update}));
" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$INTENT")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$ROUTED_SKILL")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$STATUS")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$ERROR_SUMMARY")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$EXECUTION_SUMMARY")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$PHASE")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$PLAN")" \
  "$DURATION_MS" || {
    release_lock
    exit 1
  })

# Write GSD output
write_gsd_output "$INTENT" "$ROUTED_SKILL" "$STATUS" "$EXECUTION_SUMMARY" "$PHASE" "$PLAN" "$DURATION_MS"

# Release lock and output trigger flags
release_lock
echo "$TRIGGER_JSON"
