#!/usr/bin/env bash
# gsd-context-detect.sh — GSD project context detection
#
# Detects whether the current working directory (or specified directory) is
# inside a GSD project by traversing upward to find .planning/ and parsing
# STATE.md, ROADMAP.md, PROJECT.md, and CLAUDE.md into structured JSON.
#
# Usage:
#   bash gsd-context-detect.sh [--quick] [<cwd>]
#
#   --quick   Only check .planning/ existence, skip all file parsing
#   <cwd>     Starting directory (default: current working directory)
#
# Output: JSON to stdout
# Exit: Always 0 (caller determines data sufficiency)
#
# Decisions implemented: D-01, D-02, D-04, D-05, D-06, D-08, D-10
set -euo pipefail

# ---- Helper: JSON-escape a string value ----
json_str() {
  node -e "console.log(JSON.stringify(process.argv[1]));" "$1" 2>/dev/null || echo '""'
}

# ---- Parse arguments ----
QUICK_MODE=false
CWD=""

if [ "${1:-}" = "--quick" ]; then
  QUICK_MODE=true
  shift
fi

CWD="${1:-$(pwd)}"

# ---- T-08-01: Validate path argument ----
if [ -z "$CWD" ]; then
  echo '{"gsd_project":false,"error":"empty path"}'
  exit 0
fi

# ---- D-01: Upward traversal (max 5 levels) ----
PLANNING_DIR=""
SEARCH_DIR="$CWD"
for _ in $(seq 1 5); do
  if [ -d "$SEARCH_DIR/.planning" ]; then
    PLANNING_DIR="$SEARCH_DIR/.planning"
    GSD_PROJECT_ROOT="$SEARCH_DIR"
    break
  fi
  SEARCH_DIR="$(dirname "$SEARCH_DIR")"
done

# ---- D-04: Graceful degradation on not found ----
if [ -z "$PLANNING_DIR" ]; then
  echo '{"gsd_project":false,"error":"no .planning/ found within 5 levels"}'
  exit 0
fi

# ---- D-05: --quick mode ----
if [ "$QUICK_MODE" = true ]; then
  echo "{\"gsd_project\":true,\"gsd_project_root\":$(json_str "$GSD_PROJECT_ROOT"),\"planning_dir\":$(json_str "$PLANNING_DIR")}"
  exit 0
fi

# ---- Helper: extract frontmatter via awk + node -e ----
# Cross-platform: uses node -e with process.argv pattern for stdin
extract_frontmatter() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "{}"
    return
  fi
  awk '/^---/{c++;next} c==1{print}' "$file" | node -e "
let d = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', c => d += c);
process.stdin.on('end', () => {
  const lines = d.split('\n');
  const result = {};
  let stack = [result], indents = [-1];
  for (const line of lines) {
    const t = line.trim();
    if (!t || t.startsWith('#')) continue;
    const m = line.match(/^(\s*)/);
    const indent = m ? m[1].length : 0;
    while (stack.length > 1 && indent <= indents[indents.length-1]) {
      stack.pop(); indents.pop();
    }
    const kv = t.match(/^([a-zA-Z0-9_-]+):\s*(.*)/);
    if (kv) {
      const k = kv[1], v = kv[2].trim().replace(/^\"|\"$/g, '');
      if (v) {
        stack[stack.length-1][k] = /^\d+$/.test(v) ? parseInt(v,10) : v;
      } else {
        stack[stack.length-1][k] = {};
        stack.push(stack[stack.length-1][k]);
        indents.push(indent);
      }
    }
  }
  console.log(JSON.stringify(result));
  process.stdin.resume();
});
" 2>/dev/null || echo "{}"
}

# ---- Helper: extract body section via awk ----
extract_section() {
  local file="$1" header="$2"
  if [ ! -f "$file" ]; then
    echo ""
    return
  fi
  awk -v h="$header" 'BEGIN{found=0} index($0, "## " h) == 1 && (length($0) == length("## " h) || index($0, "## " h " ") == 1) {found=1; next} /^## /{found=0} found{print}' "$file" 2>/dev/null || echo ""
}

# ---- Helper: pipe stdin through node for JSON object parsing ----
# Works cross-platform: uses process.stdin streaming, not /dev/stdin
pipe_json() {
  node -e "
let d = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', c => d += c);
process.stdin.on('end', () => {
  const result = (function() { $1 })();
  console.log(JSON.stringify(result));
  process.stdin.resume();
});
" 2>/dev/null || echo "$2"
}

# ---- Parse STATE.md ----
STATE_FILE="$PLANNING_DIR/STATE.md"
STATE_FRONTMATTER="{}"
CURRENT_POSITION_RAW=""

if [ -f "$STATE_FILE" ]; then
  STATE_FRONTMATTER=$(extract_frontmatter "$STATE_FILE")
  CURRENT_POSITION_RAW=$(extract_section "$STATE_FILE" "Current Position")
fi

# Parse Current Position body into flat JSON object
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

# ---- D-06: Extract current_plan with null normalization ----
CURRENT_PLAN=$(node -e "
const cp = JSON.parse(process.argv[1]);
const rawPlan = (cp && cp.plan) ? cp.plan.trim() : '';
const nullValues = ['—', '-', '', 'none', 'tbd', 'not started'];
const isNull = nullValues.includes(rawPlan.toLowerCase());
console.log(JSON.stringify(isNull ? null : rawPlan));
" "$CURRENT_POSITION" 2>/dev/null || echo 'null')

# ---- Parse ROADMAP.md ----
ROADMAP_FILE="$PLANNING_DIR/ROADMAP.md"
PHASES="[]"
PROGRESS_TABLE="[]"

if [ -f "$ROADMAP_FILE" ]; then
  # Extract phase headers and checkbox status
  PHASE_HEADERS=$(grep -E "^#{2,4} Phase [0-9]" "$ROADMAP_FILE" | sed -E 's/^#+ Phase ([0-9.]+):? *(.+)?/\1|\2/' 2>/dev/null || echo "")
  PHASE_CHECKBOXES=$(grep -E "^-\s+\[[ x]\]" "$ROADMAP_FILE" | grep -i "Phase" | sed -E 's/^- \[([ x])\].*Phase ([0-9.]+).*/\2|\1/' 2>/dev/null || echo "")

  # Build phases JSON array
  if [ -n "$PHASE_HEADERS" ]; then
    PHASES=$(
      echo "$PHASE_HEADERS" | while IFS='|' read -r num name; do
        status=$(echo "$PHASE_CHECKBOXES" | grep "^$num|" | cut -d'|' -f2 2>/dev/null || echo " ")
        [ "$status" = "x" ] && complete="true" || complete="false"
        echo "{\"number\":$(json_str "$num"),\"name\":$(json_str "$name"),\"complete\":$complete}"
      done | pipe_json '
        const lines = d.trim().split("\n").filter(Boolean);
        return lines.length ? lines.map(l => JSON.parse(l)) : [];
      ' '[]'
    )
  fi

  # Extract Progress table rows
  PROGRESS_TABLE=$(awk '/^## Progress/,0' "$ROADMAP_FILE" | grep -E "^\|" | tail -n +3 | pipe_json '
    const lines = d.trim().split("\n").filter(Boolean);
    return lines.map(l => {
      const cells = l.split("|").map(c => c.trim()).filter(c => c.length > 0);
      return cells;
    });
  ' '[]')
fi

# ---- Parse PROJECT.md ----
PROJECT_FILE="$PLANNING_DIR/PROJECT.md"
PROJECT_CORE=""
PROJECT_CONSTRAINTS=""

if [ -f "$PROJECT_FILE" ]; then
  PROJECT_CORE=$(awk '/^## (Core Value|What This Is)/{found=1; next} /^## /{found=0} found{print}' "$PROJECT_FILE" | head -5 2>/dev/null || echo "")
  PROJECT_CONSTRAINTS=$(awk '/^## Constraints/{found=1; next} /^## /{found=0} found{print}' "$PROJECT_FILE" | head -10 2>/dev/null || echo "")
fi

# ---- Parse CLAUDE.md (D-08) ----
CLAUDE_FILE="$GSD_PROJECT_ROOT/CLAUDE.md"
CLAUDE_CONTENT=""

if [ -f "$CLAUDE_FILE" ]; then
  CLAUDE_CONTENT=$(head -100 "$CLAUDE_FILE" 2>/dev/null || echo "")
fi

# ---- Assemble fields as pre-encoded JSON strings ----
ARG_PROJECT_ROOT=$(json_str "$GSD_PROJECT_ROOT")
ARG_PLANNING_DIR=$(json_str "$PLANNING_DIR")
ARG_STATE="$STATE_FRONTMATTER"
ARG_CURRENT_POSITION="$CURRENT_POSITION"
ARG_PHASES="$PHASES"
ARG_PROGRESS_TABLE="$PROGRESS_TABLE"
ARG_PROJECT_CORE=$(json_str "$PROJECT_CORE")
ARG_PROJECT_CONSTRAINTS=$(json_str "$PROJECT_CONSTRAINTS")
ARG_CLAUDE_MD=$(json_str "$CLAUDE_CONTENT")
ARG_CURRENT_PLAN="$CURRENT_PLAN"

# ---- Build output JSON (D-10) ----
OUTPUT_JSON=$(node -e "
const output = {
  gsd_project: true,
  gsd_project_root: JSON.parse(process.argv[1]),
  planning_dir: JSON.parse(process.argv[2]),
  state: JSON.parse(process.argv[3]),
  current_position: JSON.parse(process.argv[4]),
  phases: JSON.parse(process.argv[5]),
  progress_table: JSON.parse(process.argv[6]),
  project_core: JSON.parse(process.argv[7]),
  project_constraints: JSON.parse(process.argv[8]),
  claude_md: JSON.parse(process.argv[9]),
  current_plan: JSON.parse(process.argv[10])
};
console.log(JSON.stringify(output, null, 2));
" \
  "$ARG_PROJECT_ROOT" \
  "$ARG_PLANNING_DIR" \
  "$ARG_STATE" \
  "$ARG_CURRENT_POSITION" \
  "$ARG_PHASES" \
  "$ARG_PROGRESS_TABLE" \
  "$ARG_PROJECT_CORE" \
  "$ARG_PROJECT_CONSTRAINTS" \
  "$ARG_CLAUDE_MD" \
  "$ARG_CURRENT_PLAN"
)

echo "$OUTPUT_JSON"
