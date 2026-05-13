# Phase 9: 调用追踪与 GSD 合规产出 — Research

**Researched:** 2026-05-13
**Domain:** structured invocation logging, concurrency-safe file I/O, GSD phase output routing, counter-driven triggers
**Confidence:** HIGH

## Summary

Phase 9 extends the `feedback-state.json` file with an `invocation_log` array and adds GSD compliance output (SD-SUMMARY.md / SD-SUPPLEMENT.md) to the scientific-do Step 5 post-action closure. Every scientific-do invocation writes a structured JSON entry into the log, and when inside a GSD project, a markdown output file lands in the corresponding phase directory.

The implementation has four concerns: (1) the invocation_log schema and append logic, (2) concurrency-safe writes with mkdir lock, (3) GSD output routing with frontmatter, and (4) counter-driven trigger integration (rating every 10, update check every 20). A mandatory dependency is the Phase 8 follow-up (D-06): gsd-context-detect.sh must emit `current_plan` before Phase 9 can route output correctly.

All 6 locked decisions from CONTEXT.md are concrete. The primary technical challenges are (1) mkdir-based concurrency lock on Windows (Git Bash), (2) atomicity of log + output writes in Step 5, (3) archive rotation without data loss, and (4) the SD-SUPPLEMENT.md append-vs-overwrite semantics within a single plan.

**Primary recommendation:** Add an `append_invocation_log` helper script that handles the full write pipeline (lock, append, trim, archive). Integrate into scientific-do Step 5 as the final sub-step after verification. Implement the Phase 8 follow-up (current_plan extraction in gsd-context-detect.sh) as a separate but prerequisite change. The output routing decision tree (GSD vs. non-GSD, plan present vs. absent) should be embedded in the same helper, called unconditionally.

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| invocation_log schema enforcement | Client (helper script) | — | bash generates JSON struct with fixed fields; node validates on read |
| Feedback state write (lock + append) | Client (helper script) | — | mkdir lock, read-modify-write of JSON, archive rotation; filesystem I/O |
| Concurency via mkdir lock | Client (helper script) | — | Atomic directory creation as mutex; 3 retries x 200ms |
| GSD output routing decision | Client (helper script) | — | Check GSD_PROJECT_ROOT + current_plan to determine target path and filename |
| SD-SUMMARY.md / SD-SUPPLEMENT.md generation | Client (helper script) | — | Write frontmatter + body to phase directory; append mode for same-phase calls |
| counter/trigger management | Client (helper script) | — | Read counter, increment, test % 10 / % 20, write back |
| current_plan extraction (D-06 follow-up) | Client (gsd-context-detect.sh) | — | Parse `## Current Position` in STATE.md for `Plan:` line |
| Trigger response: rating popup | Client (scientific-do Step 5) | — | Counter-driven, UI interaction via Claude Code |
| Trigger response: update check | Client (scientific-do Step 5) | — | Calls existing skill-discovery.sh or update-check.sh |

## Standard Stack

### Core
| Library/Tool | Version | Purpose | Why Standard |
|--------------|---------|---------|--------------|
| bash | 5.2+ | All I/O orchestration: lock, file read/write, counter increment | Zero dependency, always available |
| node | 24.14.0 | JSON merge, validation, frontmatter generation | Claude Code guaranteed; handles JSON serde correctly |
| mkdir | — | Concurrency lock via atomic `mkdir .lock` | POSIX atomic operation; works in Git Bash on Windows |
| date | — | ISO 8601 timestamp generation (`date -Iseconds`) | POSIX standard |

### Supporting
| Tool | Purpose | When to Use |
|------|---------|-------------|
| `rm -rf` | Lock cleanup after write completes | Every write cycle |
| `sleep 0.2` | Retry interval between lock attempts | On lock contention |
| `jq` or `node -e` | JSON field extraction and validation | Preferred: node -e (no dependency); jq fallback if available |
| `wc -l` or `node -e` | entry count for archive trigger | Count log entries before/after trim |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `mkdir` lock (filesystem) | `flock` (advisory file lock) | `flock` has Windows compatibility issues in Git Bash; `mkdir` is atomic everywhere |
| `feedback-state.json` single file | Per-project log files | Single file simpler for cross-project analytics; per-project split discussed and rejected in Area S2 |
| `node -e` JSON processing | `jq` standalone | `node -e` guaranteed in Claude Code; `jq` not always available |
| Append to log | Write entire array each time | Rewrite is O(n) but keeps format valid; append-only requires streaming JSON parser |

**Installation:**
```bash
# No installation needed — uses tools guaranteed in Claude Code environment
# All tools available in Git Bash on Windows
```

**Version verification:**
```bash
node --version    # Verified: v24.14.0 (2026-05-13)
bash --version   # Verified: GNU bash 5.2.37
mkdir --version  # Verified: from GNU coreutils
```

## Architecture Patterns

### Pattern 1: Invocation Log Write with mkdir Lock

**What:** Atomic append of a single invocation_log entry into feedback-state.json with concurrency protection.

**When to use:** Every scientific-do invocation, unconditionally, at Step 5.

**Key design:**
- Lock via `mkdir "$LOCK_DIR"` (atomic on POSIX and Git Bash)
- 3 retries x 200ms
- Read full file, parse JSON, push new entry, trim to 200, write back
- counter = invocation_log.length after write
- Archive: if trimmed entries > 0, append them to archive file

```bash
# Lock acquisition with retry
LOCK_DIR="$FEEDBACK_DIR/.feedback-state.lock"
acquire_lock() {
  local retries=3
  for i in $(seq 1 $retries); do
    if mkdir "$LOCK_DIR" 2>/dev/null; then
      return 0
    fi
    [ $i -lt $retries ] && sleep 0.2
  done
  return 1  # lock timeout
}

release_lock() {
  rm -rf "$LOCK_DIR"
}

# Build entry
build_entry() {
  local intent="$1" routed_skill="$2" status="$3" error_summary="$4"
  local execution_summary="$5" phase="$6" plan="$7" duration_ms="$8"
  local timestamp
  timestamp=$(date -Iseconds 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%S%z")

  # JSON-escape all string values via node
  node -e "
const entry = {
  timestamp: $(node -e "console.log(JSON.stringify(process.argv[1]))" "$timestamp"),
  intent: $(node -e "console.log(JSON.stringify(process.argv[1]))" "$intent"),
  routed_skill: $(node -e "console.log(JSON.stringify(process.argv[1]))" "$routed_skill"),
  status: $(node -e "console.log(JSON.stringify(process.argv[1]))" "$status"),
  error_summary: $(node -e "console.log(JSON.stringify(process.argv[1]))" "$error_summary"),
  execution_summary: $(node -e "console.log(JSON.stringify(process.argv[1]))" "$execution_summary"),
  phase: $(node -e "console.log(JSON.stringify(process.argv[1]))" "$phase"),
  plan: $(node -e "console.log(JSON.stringify(process.argv[1]))" "$plan"),
  duration_ms: $duration_ms
};
console.log(JSON.stringify(entry));
"
}

# Read, append, trim, archive pipeline
STATE_FILE="$FEEDBACK_DIR/feedback-state.json"
if [ ! -f "$STATE_FILE" ]; then
  echo '{"counter":0,"invocation_log":[],"ratings":[],"skill_states":{},"gaps":[],"version":1}' > "$STATE_FILE"
fi

# The following is done inside the lock:
# 1. node -e reads STATE_FILE, pushes entry
# 2. If invocation_log.length > 200, slice to last 200
# 3. counter = invocation_log.length
# 4. If entries were removed, append them to ARCHIVE_FILE
# 5. Write modified STATE_FILE

node -e "
const fs = require('fs');
const state = JSON.parse(fs.readFileSync('$STATE_FILE', 'utf8'));
const entry = JSON.parse(process.argv[1]);
state.invocation_log = state.invocation_log || [];
state.invocation_log.push(entry);
const MAX_LOG = 200;
if (state.invocation_log.length > MAX_LOG) {
  const removed = state.invocation_log.slice(0, state.invocation_log.length - MAX_LOG);
  state.invocation_log = state.invocation_log.slice(-MAX_LOG);
  // Append removed to archive
  const archiveFile = '$FEEDBACK_DIR/invocation-log-archive.json';
  let archive = [];
  try { archive = JSON.parse(fs.readFileSync(archiveFile, 'utf8')); } catch(e) {}
  archive.push(...removed);
  fs.writeFileSync(archiveFile, JSON.stringify(archive), 'utf8');
}
state.counter = state.invocation_log.length;
fs.writeFileSync('$STATE_FILE', JSON.stringify(state, null, 2), 'utf8');
" "$(build_entry "$@")"
```

### Pattern 2: GSD Output Routing (SD-SUMMARY.md / SD-SUPPLEMENT.md)

**What:** After log write, conditionally write a markdown output file to the GSD phase directory.

**When to use:** Only when GSD_PROJECT_ROOT is set (inside GSD project).

**Decision tree:**
```
Is GSD_PROJECT_ROOT set?
  NO  → Skip output, log only (return)
  YES → Is current_plan set and not null?
          YES → Write SD-SUPPLEMENT.md (plan-level supplement)
          NO  → Write SD-SUMMARY.md (phase-level summary)
```

**Frontmatter format (simplified, D-04):**
```yaml
---
source: scientific-do
phase: "N"             # from GSD_CURRENT_PHASE
plan: "08-01"          # optional, from current_plan
generated_at: "ISO时间"
intent: "用户原始意图"
routed_skill: "skill名"
status: success | failure | partial | gap_detected
---
```

**Append behavior:**
- Subsequent calls within the same phase (or same plan) append to the same file
- Each entry separated by `---` frontmatter block
- This keeps file count manageable (1 per phase/plan pair, not 1 per invocation)

```bash
write_output() {
  local intent="$1" routed_skill="$2" status="$3"
  local execution_summary="$4" duration_ms="$5"
  local phase="$6" plan="$7"

  # Only write in GSD mode
  if [ -z "$GSD_PROJECT_ROOT" ]; then
    return 0
  fi

  # Determine target directory and filename
  local phase_slug=""
  if [ -n "$phase" ]; then
    phase_slug=$(printf "%02d" "$phase" 2>/dev/null || echo "$phase")
  else
    return 0  # no phase context, skip
  fi

  local output_dir="$GSD_PROJECT_ROOT/.planning/phases/${phase_slug}-*"
  # Resolve the full phase directory name (wildcard)
  output_dir=$(ls -d "$GSD_PROJECT_ROOT/.planning/phases/${phase_slug}-"* 2>/dev/null | head -1)
  if [ -z "$output_dir" ]; then
    # Phase directory does not exist, fallback to phase name
    output_dir="$GSD_PROJECT_ROOT/.planning/phases/${phase_slug}"
    mkdir -p "$output_dir"
  fi

  local filename="SD-SUMMARY.md"
  # Note: D-04 says plan present -> SD-SUPPLEMENT.md, absent -> SD-SUMMARY.md
  # But the actual decision (D-04 in CONTEXT.md) says:
  # "有 current_plan → SD-SUPPLEMENT.md（plan 级）；无 current_plan → SD-SUMMARY.md（phase 级）"
  # Wait — the locked decision D-04 says:
  # - 有 current_plan：写入 SD-SUPPLEMENT.md（plan 级）
  # - 无 current_plan：写入 SD-SUMMARY.md（phase 级）
  # This is REVERSED from what D-04 field description says.
  # Actually, re-reading CONTEXT.md D-04:
  #   "有 current_plan：写入 SD-SUPPLEMENT.md（plan 级）"
  #   "无 current_plan：写入 SD-SUMMARY.md（phase 级）"
  # This means: when a specific plan is being executed, write a plan-level supplement.
  # When only a phase is active (no plan), write a phase-level summary.
  # This makes sense: the supplement ADDS TO the phase summary.
  if [ -n "$plan" ] && [ "$plan" != "null" ]; then
    filename="SD-SUPPLEMENT.md"
  fi

  local output_file="$output_dir/$filename"

  # Build content via node for proper YAML frontmatter generation
  node -e "
const fs = require('fs');
const frontmatter = {
  source: 'scientific-do',
  phase: JSON.parse(process.argv[1]),
  plan: JSON.parse(process.argv[2]),
  generated_at: new Date().toISOString(),
  intent: JSON.parse(process.argv[3]),
  routed_skill: JSON.parse(process.argv[4]),
  status: JSON.parse(process.argv[5])
};
const body = [
  '---',
  Object.entries(frontmatter).map(([k,v]) => k + ': ' + (v === null ? '~' : v)).join('\n'),
  '---',
  '',
  '## Execution Summary',
  '',
  JSON.parse(process.argv[6]),
  '',
  '**Duration:** ' + process.argv[7] + ' ms',
  '',
].join('\n');

// Append to file (or create if not exists)
fs.appendFileSync(process.argv[8], body + '\n', 'utf8');
" \
  "$phase" "$plan" "$intent" "$routed_skill" "$status" \
  "$execution_summary" "$duration_ms" "$output_file"
}
```

**IMPORTANT CLARIFICATION on D-04 output routing decision:**

The CONTEXT.md D-04 says:
- `current_plan` is present and non-null → write SD-SUPPLEMENT.md (plan-level supplement)
- `current_plan` is absent or null → write SD-SUMMARY.md (phase-level summary)

This means the SUMMARY is the broader scope and SUPPLEMENT is the narrower scope. The supplement adds detail for a specific plan within a phase. This is confirmed by the discussion log (Area 3, Q3): "current_plan present → SD-SUPPLEMENT.md; absent → SD-SUMMARY.md".

### Pattern 3: Integration Point — Step 5 Modification

**What:** scientific-do/SKILL.md Step 5 currently has verification gates and usage tracking (counter increment). Phase 9 extends this to write invocation_log + output.

**Current Step 5 (from existing SKILL.md):**
```markdown
### 5. Post-Action Verification Closure (D-05)

After each scientific-do orchestration cycle, run a lightweight verification:

**Verification Gates:**
- GATE 1-4 (HARD/SOFT gates for literature/design/output consistency)

**Usage Tracking (D-14, D-15):**
After verification, increment the feedback counter:
- Read counter from feedback-state.json
- Only count substantive orchestrations
- Increment by 1
- Write back

**Counter trigger (every 10):**
If counter >= 10 after increment: reset, prompt rating, run update check
```

**Modified Step 5 (Phase 9 additions in bold):**

1. Run verification gates (unchanged)
2. Counter increment logic (unchanged but note: current code increments for substantive only — Phase 9 logs ALL invocations, not just substantive ones)
3. **Build invocation_log entry** (timestamp, intent, routed_skill, status, execution_summary, phase, plan, duration_ms)
4. **Write entry to feedback-state.json with mkdir lock**
5. **Write GSD output file if applicable** (SD-SUMMARY.md or SD-SUPPLEMENT.md)
6. **Check triggers**: counter % 10 == 0 → rating; counter % 20 == 0 → update check

**Important distinction:** The invocation_log records ALL invocations (including non-substantive ones), while the counter only increments for substantive orchestrations (>= 2 skill calls OR >= 30s execution). This means `counter` and `invocation_log.length` are NOT necessarily equal. The D-02 statement "每次写入后 counter = invocation_log.length" contradicts the existing SKILL.md logic that filters on substantive orchestrations.

**This contradiction must be resolved during planning.** Options:
- A) Change counter to count ALL invocations (matches D-02, changes existing Step 5 behavior)
- B) Keep counter substantive-only, do NOT sync with invocation_log.length (D-02 is wrong, need to update)
- C) Introduce separate counters: `counter` (substantive, drives triggers) and `total_invocations` (raw count = log length)

### Pattern 4: counter/trigger reconciliation

**Existing behavior (from SKILL.md Step 5):**
```
Only count substantive orchestrations (>= 2 skill calls OR >= 30s execution time)
Increment by 1 for matching orchestrations
If counter >= 10 after increment: reset to 0, prompt rating, run update check
```

**Phase 9 D-03 trigger behavior:**
```
Rating: counter % 10 == 0 → popup 1-5 rating
Update check: counter % 20 == 0 → check all installed skill upstream updates
```

**If we keep substantive-only counter (Option B above):**
- counter increments only for substantive (same as now)
- invocation_log records ALL calls (phase and plan fields null for non-substantive)
- Triggers fire on substantive-only cadence — users who do many quick searches between substantive work don't get interrupted
- D-02's "counter = invocation_log.length" is wrong — update needed

**If we change to all-invocations counter (Option A):**
- counter = invocation_log.length after each write (matches D-02 literally)
- Rating appears more frequently (every 10 calls, regardless of substance)
- Existing Step 5 filtering logic must be removed

### Pattern 5: current_plan extraction in gsd-context-detect.sh (D-06 follow-up)

**What:** Phase 8's gsd-context-detect.sh currently extracts `current_position` as a flat object but does NOT parse the `Plan:` field separately. Phase 9 needs `current_plan` in the JSON output to route output files correctly.

**Current output structure:**
```json
{
  "current_position": {
    "phase": "8",
    "plan": "not started",
    "status": "milestone complete",
    "last_activity": "2026-05-13"
  }
}
```

**Required change:** The current parsing already extracts `plan` into the `current_position` object (from the Current Position section body). The D-06 requirement is to:
1. Ensure `plan` is reliably extracted (the existing code from Phase 8 Research already does `grep "^Plan:"` from the section)
2. Expose it top-level as `current_plan` in the JSON output for more direct access
3. Map "—" or empty value to JSON `null`

The current gsd-context-detect.sh already has:
```bash
CURRENT_POSITION=$(echo "$CURRENT_POSITION_RAW" | pipe_json '
  const lines = d.split("\n").filter(l => l.includes(":"));
  const obj = {};
  for (const line of lines) {
    const m = line.match(/^\*{0,2}([^*:]+):\*{0,2}\s*(.*)/);
    if (m) {
      const key = m[1].trim().toLowerCase().replace(/ /g,"_");
      const val = m[2].trim();
      if (val) obj[key] = val;
    }
  }
  return obj;
' '{}')
```

So `current_position.plan` should already exist with value like `"TBD"` or `"not started"` or `"08-01"`. The D-06 change needs to:
1. Add `current_plan` to the top-level output object
2. Map "—" to null

```bash
# In the output assembly section, add:
current_plan=$(node -e "
const cp = JSON.parse(process.argv[1]);
const plan = cp.plan || null;
console.log(JSON.stringify(plan === '—' || plan === '-' || plan === '' ? null : plan));
" "$CURRENT_POSITION" 2>/dev/null || echo 'null')
```

And include in the final JSON:
```json
{
  "gsd_project": true,
  "gsd_project_root": "/path",
  "current_position": { ... },
  "current_plan": "08-01",   // NEW: null if absent or "—"
  ...
}
```

### Pattern 6: Archive Rotation Strategy

**What:** Manage invocation_log growth by retaining 200 entries and archiving older ones.

**When to trigger:** IMMEDIATELY when count exceeds 200 (one of Claude's discretion items — recommended: inline at write time, not batch at phase end).

**Rationale for inline:** Phase-end batching risks losing entries on crash mid-phase. Inline archiving is simpler to reason about, and 200 is small enough that the trim operation is O(200) per write — negligible cost.

**Archive format:** Same schema as invocation_log entries. Archive file is append-only, growing unbounded. For analytics, downstream tools read the archive separately.

```json
// invocation-log-archive.json — appended entries array
[
  { /* entry 1 */ },
  { /* entry 2 */ },
  ...
  { /* entry N */ }
]
```

**Per-D-02, the archive file path:** `~/.claude/scientific-skills/invocation-log-archive.json`

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| JSON serialization of log entry | String concatenation | `node -e "console.log(JSON.stringify(...))"` | Prevents injection via intent text or execution_summary; handles Unicode correctly |
| mkdir lock | Custom semaphore or temp file locking | `mkdir .lock` (atomic dir creation) | Atomic on all POSIX-compatible filesystems including Git Bash; no dependency on `flock` (not on Windows) |
| YAML frontmatter markdown gen | Template engine | node -e with `Object.entries().join('\n')` | The frontmatter is simple flat key-value pairs — no nesting needed |
| Counter trigger logic | State machine | `$(( counter % 10 == 0 ))` and `$(( counter % 20 == 0 ))` | Simple arithmetic; works for any counter value including 0 |
| Duration measurement | External monitoring | Record time at Step 1 start, compute diff at Step 5 end | Simplest approach; bash `date +%s%3N` or node `Date.now()` |

**Key insight:** The Phase 9 problem decomposes into a shell I/O pipeline with JSON mediation. Node handles all JSON serde (escape, parse, stringify) while bash handles filesystem operations (mkdir, rm, file existence checks). This division of labor mirrors the Phase 8 approach and avoids common pitfalls with shell-based JSON manipulation.

## Common Pitfalls

### Pitfall 1: counter vs. invocation_log.length Desync
**What goes wrong:** After migration, `counter` does not match `invocation_log.length` because existing code only counts substantive orchestrations.
**Why it happens:** SKILL.md Step 5 filters ">= 2 skill calls OR >= 30s execution" before incrementing counter. Phase 9 D-02 says "counter = invocation_log.length after each write".
**How to avoid:** Resolve this contradiction during planning (see Pattern 3 above for options). Document the chosen approach in the plan.
**Warning signs:** After 15 substantive calls and 3 non-substantive, log has 18 entries but counter shows 15.

### Pitfall 2: mkdir Lock on Windows (Git Bash)
**What goes wrong:** `mkdir` lock works atomically on Linux but may have subtle race conditions under Git Bash on Windows (e.g., if AV scanner holds a handle on the directory).
**Why it happens:** Windows does not have the same POSIX atomicity guarantees for directory creation.
**How to avoid:** Test the lock + cleanup cycle heavily. Add a safety valve: if lock cannot be acquired after 3 retries, write to a temp file and log a warning rather than blocking execution.
**Warning signs:** Intermittent "lock acquisition failed" in execution logs, or orphan `.lock` directories.

### Pitfall 3: SD-SUPPLEMENT.md Append Semantics
**What goes wrong:** Multiple invocations within the same plan produce a single SD-SUPPLEMENT.md file with many appended frontmatter blocks. The file becomes hard to read and parsing is ambiguous.
**Why it happens:** D-04 says "同一 phase 内后续调用追加到同一文件" — append mode for same-phase calls. Multiple entries pile up.
**How to avoid:** Add a clear visual separator between entries (e.g., `---` alone on a line before each frontmatter block). Consider adding `entry_index: N` to the frontmatter for traceability. Document that this file is machine-readable, not primarily human-readable.
**Warning signs:** Single-output-file approach not covered in tests or ROI analysis.

### Pitfall 4: current_plan Mapping — "—" vs. "—" vs. ""
**What goes wrong:** STATE.md uses "—" (em dash) to indicate "no current plan", which differs from "-" or empty string. The gsd-context-detect.sh parser may not normalize these consistently.
**Why it happens:** The GSD file format uses an em dash (U+2014) rather than a hyphen or empty value for "not applicable".
**How to avoid:** Explicitly test all three variants in the D-06 implementation: `"—"`, `"-"`, `""`. Normalize all to JSON `null`.
**Warning signs:** SD-SUPPLEMENT.md is generated when plan reads "—" instead of treating it as absent.

### Pitfall 5: Archiving During Lock Hold
**What goes wrong:** The archive write (if old entries need to be moved) happens inside the lock. If the archive file is large, the lock hold time increases.
**Why it happens:** Reading and writing the archive file (append mode) adds O(archive_size) time inside the critical section.
**How to avoid:** Keep archive writes minimal. Since MAX_LOG=200, at most 1 entry is archived per write (when log is exactly 201). Bulk archival of many entries at once is unlikely. If it becomes a problem, archive outside the lock with a double-check pattern.
**Warning signs:** Lock hold time exceeds 100ms regularly.

### Pitfall 6: Step 5 Already Has a Counter Increment
**What goes wrong:** The existing Step 5 code increments counter and checks triggers. Phase 9 proposes writing invocation_log at the same point. The two must be coordinated correctly — if counter is incremented before the log entry is built, the data structures may reference stale state.
**Why it happens:** The counter increment reads feedback-state.json, modifies counter, writes back. Then Phase 9 reads feedback-state.json again to append the log entry. Two separate read-modify-write cycles on the same file.
**How to avoid:** Unify into a single read-modify-write cycle inside the lock: read once, compute counter+log+triggers, write once. This avoids TOCTOU races between the two operations.

## Code Examples

### Full Write Pipeline (append_invocation_log.sh)

```bash
#!/usr/bin/env bash
# append-invocation-log.sh — Append invocation_log entry + write GSD output
#
# Usage: bash append-invocation-log.sh <intent> <routed_skill> <status> <error_summary> <execution_summary> <phase> <plan> <duration_ms>
#
# Called from scientific-do Step 5 after verification.
# Handles: mkdir lock, JSON append, trim, archive, counter sync, trigger return
#
# Inputs:
#   All positional arguments — the invocation_log entry fields
# Environment variables:
#   GSD_PROJECT_ROOT — set when inside GSD project (from Step 1)
#   GSD_CURRENT_PHASE — phase number (from Step 1)
#   FEEDBACK_DIR — defaults to ~/.claude/scientific-skills

set -euo pipefail

# --- Config ---
FEEDBACK_DIR="${FEEDBACK_DIR:-$HOME/.claude/scientific-skills}"
STATE_FILE="$FEEDBACK_DIR/feedback-state.json"
ARCHIVE_FILE="$FEEDBACK_DIR/invocation-log-archive.json"
LOCK_DIR="$FEEDBACK_DIR/.feedback-state.lock"
MAX_LOG=200
RETRIES=3
RETRY_DELAY=0.2

# --- Parse args ---
INTENT="${1:-}"
ROUTED_SKILL="${2:-}"
STATUS="${3:-success}"
ERROR_SUMMARY="${4:-}"
EXECUTION_SUMMARY="${5:-}"
PHASE="${6:-null}"
PLAN="${7:-null}"
DURATION_MS="${8:-0}"

# --- Helper: acquire mkdir lock ---
acquire_lock() {
  for i in $(seq 1 $RETRIES); do
    if mkdir "$LOCK_DIR" 2>/dev/null; then
      return 0
    fi
    [ $i -lt $RETRIES ] && sleep $RETRY_DELAY
  done
  echo "[WARN] Could not acquire lock after $RETRIES retries" >&2
  return 1
}

# --- Helper: release mkdir lock ---
release_lock() {
  rm -rf "$LOCK_DIR" 2>/dev/null || true
}

# --- Acquire lock ---
if ! acquire_lock; then
  # Fallback: write to temp file, log warning
  echo "[ERROR] Lock acquisition failed — skipping invocation log write" >&2
  exit 1
fi

# --- Ensure state file exists ---
if [ ! -f "$STATE_FILE" ]; then
  echo '{"counter":0,"invocation_log":[],"last_feedback_at":null,"last_update_check_at":null,"ratings":[],"skill_states":{},"gaps":[],"version":1}' > "$STATE_FILE"
fi

# --- Read, modify, write ---
node -e "
const fs = require('fs');
const state = JSON.parse(fs.readFileSync('$STATE_FILE', 'utf8'));

// Build entry
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

// Append to log
state.invocation_log = state.invocation_log || [];
state.invocation_log.push(entry);

// Trim + archive
if (state.invocation_log.length > $MAX_LOG) {
  const removed = state.invocation_log.slice(0, state.invocation_log.length - $MAX_LOG);
  state.invocation_log = state.invocation_log.slice(-$MAX_LOG);
  try {
    let archive = [];
    try { archive = JSON.parse(fs.readFileSync('$ARCHIVE_FILE', 'utf8')); } catch(e) {}
    if (!Array.isArray(archive)) archive = [];
    archive.push(...removed);
    fs.writeFileSync('$ARCHIVE_FILE', JSON.stringify(archive), 'utf8');
  } catch(e) {
    console.error('[WARN] Archive write failed:', e.message);
  }
}

// Sync counter — see Pattern 3: counter-vs-length discussion.
// Option A (simplest): state.counter = state.invocation_log.length;
// Option B (preserve substantive-only): keep existing logic, do not sync.
// For now, implement Option A per D-02 literal.
state.counter = state.invocation_log.length;

fs.writeFileSync('$STATE_FILE', JSON.stringify(state, null, 2), 'utf8');

// Output trigger info for caller
const trig_rating = (state.counter % 10 === 0) && state.counter > 0;
const trig_update = (state.counter % 20 === 0) && state.counter > 0;
console.log(JSON.stringify({rating: trig_rating, update_check: trig_update}));
" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$INTENT")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$ROUTED_SKILL")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$STATUS")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$ERROR_SUMMARY")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$EXECUTION_SUMMARY")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$PHASE")" \
  "$(node -e "console.log(JSON.stringify(process.argv[1]))" "$PLAN")" \
  "$DURATION_MS"

release_lock
```

### GSD Output Write

```bash
# Called after append-invocation-log.sh succeeds
# Only invoked when GSD_PROJECT_ROOT is set

write_gsd_output() {
  local intent="$1" routed_skill="$2" status="$3"
  local execution_summary="$4" phase="$5" plan="$6" duration_ms="$7"

  [ -z "${GSD_PROJECT_ROOT:-}" ] && return 0

  # Resolve phase directory
  local phase_dir=""
  if [ -n "$phase" ] && [ "$phase" != "null" ]; then
    # Try to find matching phase directory
    phase_dir=$(ls -d "$GSD_PROJECT_ROOT/.planning/phases/"*"-${phase}-"* 2>/dev/null | head -1)
    # Fallback: try numeric prefix pattern
    if [ -z "$phase_dir" ]; then
      local padded
      padded=$(printf "%02d" "$phase" 2>/dev/null || echo "$phase")
      phase_dir=$(ls -d "$GSD_PROJECT_ROOT/.planning/phases/${padded}-"* 2>/dev/null | head -1)
    fi
    # Last resort: use phase value as-is
    if [ -z "$phase_dir" ]; then
      phase_dir="$GSD_PROJECT_ROOT/.planning/phases/${phase}"
      mkdir -p "$phase_dir"
    fi
  else
    return 0  # no phase context, cannot route
  fi

  # Determine filename: SUPPLEMENT if plan present, SUMMARY otherwise
  local filename="SD-SUMMARY.md"
  if [ -n "$plan" ] && [ "$plan" != "null" ]; then
    filename="SD-SUPPLEMENT.md"
  fi

  local output_file="$phase_dir/$filename"

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
  Object.entries(entry).map(([k,v]) => k + ': ' + (v === null ? '~' : String(v))).join('\n') +
  '\n---\n\n' +
  JSON.parse(process.argv[6]) + '\n\n' +
  '**Duration:** ' + process.argv[7] + ' ms\n\n';
fs.appendFileSync(process.argv[8], body, 'utf8');
" "$phase" "$plan" "$intent" "$routed_skill" "$status" "$execution_summary" "$duration_ms" "$output_file"
}
```

### Phase 8 Follow-up: current_plan in gsd-context-detect.sh

```bash
# Inside gsd-context-detect.sh output assembly — add after CURRENT_POSITION is built:

# D-06: Extract current_plan from current_position.plan
# Map "—" (em dash), "-", empty to null
CURRENT_PLAN=$(node -e "
const cp = JSON.parse(process.argv[1]);
const rawPlan = cp && cp.plan ? cp.plan.trim() : '';
const nullValues = ['—', '-', '', 'none', 'tbd', 'not started'];
const isNull = nullValues.includes(rawPlan.toLowerCase());
console.log(JSON.stringify(isNull ? null : rawPlan));
" "$CURRENT_POSITION" 2>/dev/null || echo 'null')

# …and in the output JSON builder:
current_plan: CURRENT_PLAN,
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| No structured invocation tracking | Every scientific-do call logged to feedback-state.json | Phase 9 | Full execution history available for analytics and debugging |
| Step 5 only handled verification + counter | Step 5 also handles log write + GSD output + trigger check | Phase 9 | Centralizes all post-action side effects in one step |
| GSD output files do not exist | SD-SUMMARY.md / SD-SUPPLEMENT.md in phase dirs | Phase 9 | GSD projects get auditable execution records per phase |
| feedback-state.json has 6 top-level keys | Adds invocation_log (7th key) + archive support | Phase 9 | File structure grows but maintains backward compatibility |
| No concurrency protection for writes | mkdir lock with 3 retries | Phase 9 | Prevents corruption from parallel scientific-do invocations |
| Phase 8 gsd-context-detect.sh output has no current_plan | D-06 adds current_plan field | Phase 9 | Enables plan-level output routing (SD-SUPPLEMENT.md distinction) |

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | `mkdir` lock is atomic and works correctly under Git Bash on Windows | mkdir Lock | Race conditions under concurrent invocation; fall back to write-temp-and-warn strategy |
| A2 | Single feedback-state.json file with 200 entries is performant enough | Storage | If each entry is ~500 bytes, file stays under 100KB — negligible I/O. If entries grow to 5KB each, 200 = 1MB, still fast |
| A3 | The counter-vs-length desync (Pitfall 1) can be resolved during planning | counter sync | If not resolved, either counter or log will have wrong data; triggers fire inconsistently |
| A4 | gsd-context-detect.sh already extracts `plan` from Current Position section | D-06 follow-up | If not, the D-06 change is larger than expected; need to confirm the field is parsed |
| A5 | Duration can be measured via `date +%s%3N` at Step 1 and Step 5 | duration_ms | `date +%N` (nanoseconds) not available on macOS (only GNU date). Use `node -e "Date.now()"` for cross-platform |

## Open Questions (RESOLVED)

1. **counter sync — Option A, B, or C?** (RESOLVED)
   - **Resolution: Option A** — counter = invocation_log.length, every invocation counts. Old "substantive-only" filter removed. Trigger thresholds (rating %10, update %20) proportionally adjusted to account for all calls counting. Per D-02 locked decision.
   - **Implemented in:** 09-02 Task 1 (append-invocation-log.sh: counter = log.length after write)

2. **Archive format — append-only array or per-batch files?** (RESOLVED)
   - **Resolution: Single archive file** (`invocation-log-archive.json`) with flat JSON array, append-write on overflow. Simplicity chosen per Claude's discretion.
   - **Implemented in:** 09-02 Task 1 (append mode to archive file)

3. **Output file body content beyond frontmatter?** (RESOLVED)
   - **Resolution:** Body includes: duration_ms, routed_skill, execution_summary. No link to feedback-state.json entry (filesystem coupling). Simple, self-contained.
   - **Implemented in:** 09-02 Task 1 (output file body template)

4. **Does the existing SKILL.md Step 5 counter logic need to be removed or preserved?** (RESOLVED)
   - **Resolution:** Removed. Step 5 references `append-invocation-log.sh` as the single source of truth for both counter and log. No duplication.
   - **Implemented in:** 09-02 Task 3 (SKILL.md Step 5 rewrite)

5. **What about the `last_feedback_at` and `last_update_check_at` fields?** (RESOLVED)
   - **Resolution:** `append-invocation-log.sh` updates `last_feedback_at` when counter % 10 == 0 and `last_update_check_at` when counter % 20 == 0. These are existing Phase 7 fields that Phase 9 maintains.
   - **Implemented in:** 09-02 Task 1 (trigger update in append script)

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| node | JSON handling, entry building, lock coordination | Yes | 24.14.0 | Manual JSON-escape via sed (not recommended) |
| bash | Script runner | Yes | 5.2.37 | — |
| mkdir | Concurrency lock | Yes | 8.32 | Temp file with PID as fallback (not atomic) |
| date | Timestamps | Yes | GNU 1.0+ | `date -Iseconds` for ISO; fallback to node for cross-platform |
| sleep | Retry delay | Yes | — | — |

**Missing dependencies with no fallback:** None — all dependencies are standard in Claude Code environment.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | bash script tests + node -e inline assertions |
| Config file | none — test as `scripts/test-append-invocation-log.sh` |
| Quick run | `bash scripts/test-append-invocation-log.sh --smoke` |
| Full suite | `bash scripts/test-append-invocation-log.sh --all` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Test Name |
|--------|----------|-----------|-----------|
| GSD-02 | Creates feedback-state.json if missing | smoke | `--test-init` |
| GSD-02 | Appends entry with correct schema | unit | `--test-append` |
| GSD-02 | mkdir lock acquired and released | smoke | `--test-lock` |
| GSD-02 | Trims to 200 and archives when over limit | unit | `--test-archive` |
| GSD-02 | counter = invocation_log.length | unit | `--test-counter` |
| GSD-03 | GSD output creates SD-SUMMARY.md | unit | `--test-summary` |
| GSD-03 | GSD output creates SD-SUPPLEMENT.md when plan present | unit | `--test-supplement` |
| GSD-03 | Non-GSD mode does NOT write output file | unit | `--test-no-gsd-output` |
| GSD-02 | current_plan extraction from gsd-context-detect.sh | unit | `--test-current-plan` |
| GSD-02 | Gap detection status logged correctly | unit | `--test-gap-status` |
| GSD-02 | Trigger flags: rating at %10, update at %20 | integration | `--test-triggers` |
| GSD-02 | Error summary only present for non-success | unit | `--test-error-summary` |

### Sampling Rate
- **Per task commit:** `bash scripts/test-append-invocation-log.sh --smoke`
- **Per wave merge:** `bash scripts/test-append-invocation-log.sh --all`
- **Phase gate:** All tests green before `/gsd-verify-work`

### Wave 0 Gaps
- [ ] `scripts/append-invocation-log.sh` — main write pipeline
- [ ] `scripts/test-append-invocation-log.sh` — test harness for the write pipeline
- [ ] Test fixture: empty feedback-state.json (to test init path)
- [ ] Test fixture: feedback-state.json with 200+ entries (to test archive)
- [ ] Test fixture: mock GSD phase directory (to test output routing)
- [ ] Modification to gsd-context-detect.sh: add current_plan field to JSON output

## Security Domain

> Security enforcement: moderate for this phase. The script writes to filesystem and uses lock files. Concurrency handling and file path validation are the primary concerns.

### Applicable ASVS Categories
| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | — |
| V3 Session Management | no | — |
| V4 Access Control | no | — |
| V5 Input Validation | yes | Reject null bytes in intent/summary, validate path components, escape all strings via node |
| V6 Cryptography | no | — |

### Known Threat Patterns for Shell I/O Scripting
| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| JSON injection via intent text | Tampering | Always serialize via `node -e JSON.stringify()`, never via string concatenation |
| Lock file DoS | Denial of Service | Orphan lock detection: if lock is older than N seconds, assume stale and remove |
| Symlink attack on lock directory | Tampering | Resolve `$LOCK_DIR` to real path before mkdir; reject if parent is a symlink to unexpected location |
| Race condition on file read-modify-write | Tampering | Keep lock held for the entire read-modify-write cycle (Pattern 1) |

### Phase-specific Threats
| Threat ID | Category | Component | Disposition | Mitigation |
|-----------|----------|-----------|-------------|------------|
| T-09-01 | Tampering | invocation_log entry via malicious intent string | mitigate | All fields serialized via `node -e JSON.stringify()`; shell never concatenates JSON |
| T-09-02 | Denial of Service | Orphan `.lock` directory blocks future writes | mitigate | Add timestamp check: if lock dir exists and mtime > 10s old, remove and retry |
| T-09-03 | Information Disclosure | SD-SUMMARY.md/SD-SUPPLEMENT.md written outside phase dir | mitigate | Validate that output path resolves under `GSD_PROJECT_ROOT/.planning/phases/` before writing |
| T-09-04 | Tampering | Archive file corruption from concurrent write | mitigate | Archive writes also protected by parent mkdir lock (same lock dir) |

## Sources

### Primary (HIGH confidence)
- [09-CONTEXT.md] — 6 locked decisions (D-01 through D-06), codebase context, canonical refs
- [09-DISCUSSION-LOG.md] — 4 main areas + 5 supplementary areas, cross-phase audit
- [REQUIREMENTS.md] — GSD-02 (invocation_log), GSD-03 (GSD compliance output)
- [ROADMAP.md] — Phase 9 success criteria (5 items), phase dependency on Phase 8
- [STATE.md] — Current project status, phase/plan definitions
- [PROJECT.md] — Key decisions P7 D-14~D-18 (inherited triggers), integration constraints
- [scientific-do/SKILL.md] — Current Step 5 structure: verification gates, usage tracking, counter increment
- [feedback-state.json] — Actual file structure: 6 top-level keys, skill_states, gaps array
- [gsd-context-detect.sh] — Current JSON output format, Current Position parsing logic
- [scientific-skills-config.json] — skill_registry.role mapping for any integration needs
- [08-CONTEXT.md] — Phase 8 decisions: D-03 (env vars), D-05 (detection timing), D-07 (confidence boost)

### Secondary (MEDIUM confidence)
- [08-RESEARCH.md] — Phase 8 research patterns, tooling choices, anti-patterns for consistency

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — All tools verified in environment; node, bash, mkdir universally available
- Architecture: HIGH — mkdir lock pattern is proven; node JSON mediation avoids injection risks
- Pitfalls: MEDIUM — Windows Git Bash lock behavior needs empirical testing; counter sync resolution depends on planning decision
- GSD output routing: HIGH — Decision tree is well-defined in CONTEXT.md D-04

**Research date:** 2026-05-13
**Valid until:** 2026-06-13
