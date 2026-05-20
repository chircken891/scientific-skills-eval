#!/usr/bin/env bash
# test-append-invocation-log.sh — Test harness for append-invocation-log.sh
#
# Usage:
#   bash test-append-invocation-log.sh [--smoke|--all]
#   --smoke  Run init, append, lock tests only (quick check)
#   --all    Run all 10 tests (default)
#
# Each test creates its own temp fixture for isolation.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
APPEND_SCRIPT="$SCRIPT_DIR/append-invocation-log.sh"
PASS=0
FAIL=0

# --- Colors ---
GREEN=''
RED=''
NC=''
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  NC='\033[0m'
fi

cleanup() {
  :
}

# --- Assert helpers ---
assert_eq() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo -e "  ${GREEN}PASS${NC} $label"
    return 0
  else
    echo -e "  ${RED}FAIL${NC} $label (expected: $expected, actual: $actual)"
    return 1
  fi
}

assert_contains() {
  local label="$1" file="$2" pattern="$3"
  if grep -q "$pattern" "$file" 2>/dev/null; then
    echo -e "  ${GREEN}PASS${NC} $label"
    return 0
  else
    echo -e "  ${RED}FAIL${NC} $label (pattern not found: $pattern)"
    return 1
  fi
}

assert_not_exists() {
  local label="$1" file="$2"
  if [ ! -f "$file" ]; 2>/dev/null; then
    echo -e "  ${GREEN}PASS${NC} $label"
    return 0
  else
    echo -e "  ${RED}FAIL${NC} $label (file exists: $file)"
    return 1
  fi
}

run_test() {
  local name="$1"
  shift
  echo "[TEST] $name"

  local result=0
  "$@" || result=$?

  if [ "$result" -eq 0 ]; then
    PASS=$((PASS + 1))
  else
    FAIL=$((FAIL + 1))
  fi
  echo ""
  return "$result"
}

# --- Fixture: create temp dir with node-compatible path ---
make_tempdir() {
  local tmp
  tmp=$(node -e "
var fs=require('fs'),path=require('path');
var dir=fs.mkdtempSync(path.join(require('os').tmpdir(), 'inv-test-'));
console.log(dir.replace(/\\\\/g,'/'));
")
  echo "$tmp"
}

# --- Fixture: build a state JSON with N entries ---
build_state() {
  local count="$1"
  local filepath="$2"
  node -e "
var fs=require('fs');
var entries=[];
for(var i=0;i<$count;i++) entries.push({
  timestamp:'2026-01-0'+((i%9)+1)+'T00:00:00.000Z',
  intent:'existing '+i,routed_skill:'test',
  status:'success',error_summary:'',execution_summary:'',
  phase:null,plan:null,duration_ms:0
});
fs.writeFileSync(process.argv[1], JSON.stringify({
  counter:$count,invocation_log:entries,
  last_feedback_at:null,last_update_check_at:null,
  ratings:[],skill_states:{},gaps:[],version:1
}),'utf8');
" "$filepath"
}

# ============================================================
# Test functions
# ============================================================

# --- 1. test_init: No state file -> should create default ---
test_init() {
  local tmpdir
  tmpdir=$(make_tempdir)

  # Run append script without existing state file
  FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "init test" "test-skill" "success" "" "Init execution" "" "" "0" > /dev/null

  # Verify state file was created
  [ -f "$tmpdir/feedback-state.json" ] || { echo "  FAIL: state file not created"; rm -rf "$tmpdir"; return 1; }

  local state
  state=$(node -e "console.log(JSON.stringify(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8').length > 0))")
  assert_eq "state file created" "true" "$state" || { rm -rf "$tmpdir"; return 1; }

  # Verify structure
  node -e "
var s=JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8'));
var ok=true;
if(typeof s.counter !== 'number') { console.log('counter missing'); ok=false; }
if(!Array.isArray(s.invocation_log)) { console.log('invocation_log missing'); ok=false; }
if(typeof s.version !== 'number') { console.log('version missing'); ok=false; }
process.exit(ok?0:1);
" || { echo "  FAIL: state structure invalid"; rm -rf "$tmpdir"; return 1; }

  assert_eq "log has 1 entry" "1" "$(node -e "console.log(JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8')).invocation_log.length)")" || { rm -rf "$tmpdir"; return 1; }

  rm -rf "$tmpdir"
  return 0
}

# --- 2. test_append: State with 3 entries, append 1, verify 9 D-01 fields ---
test_append() {
  local tmpdir
  tmpdir=$(make_tempdir)
  build_state 3 "$tmpdir/feedback-state.json"

  FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "append test" "test-skill" "success" "" "Append execution" "9" "08-01" "1500" > /dev/null

  # Verify 4 entries (3 + 1)
  local log_count
  log_count=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8')).invocation_log.length)")
  assert_eq "4 entries total" "4" "$log_count" || { rm -rf "$tmpdir"; return 1; }

  # Verify all 9 D-01 fields in the new entry
  node -e "
var s=JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8'));
var e=s.invocation_log[3];
var fields=['timestamp','intent','routed_skill','status','error_summary','execution_summary','phase','plan','duration_ms'];
var ok=true;
fields.forEach(function(f){if(!(f in e)){console.log('missing field: '+f);ok=false;}});
process.exit(ok?0:1);
" || { echo "  FAIL: D-01 fields incomplete"; rm -rf "$tmpdir"; return 1; }

  # Verify specific values
  node -e "
var s=JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8'));
var e=s.invocation_log[3];
var ok=true;
if(e.intent!=='append test'){console.log('intent mismatch');ok=false;}
if(e.routed_skill!=='test-skill'){console.log('routed_skill mismatch');ok=false;}
if(e.status!=='success'){console.log('status mismatch');ok=false;}
if(e.phase!=='9'){console.log('phase mismatch');ok=false;}
if(e.plan!=='08-01'){console.log('plan mismatch');ok=false;}
if(e.duration_ms!==1500){console.log('duration_ms mismatch');ok=false;}
process.exit(ok?0:1);
" || { echo "  FAIL: entry field values incorrect"; rm -rf "$tmpdir"; return 1; }

  rm -rf "$tmpdir"
  return 0
}

# --- 3. test_lock: .lock dir exists, verify script fails gracefully ---
test_lock() {
  local tmpdir
  tmpdir=$(make_tempdir)
  build_state 1 "$tmpdir/feedback-state.json"
  mkdir "$tmpdir/.feedback-state.lock"

  local exit_code=0
  FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "lock test" "skill" "success" "" "Lock test" "" "" "0" > /dev/null || exit_code=$?

  assert_eq "exit code 1 (lock failure)" "1" "$exit_code" || { rm -rf "$tmpdir"; return 1; }

  rm -rf "$tmpdir"
  return 0
}

# --- 4. test_archive: 200 existing entries, after append -> 200 with 1 archived ---
test_archive() {
  local tmpdir
  tmpdir=$(make_tempdir)
  node -e "
var fs=require('fs');
var entries=[];
for(var i=0;i<200;i++) entries.push({
  timestamp:'2026-01-0'+((i%9)+1)+'T00:00:00.000Z',
  intent:'existing '+i,routed_skill:'test',
  status:'success',error_summary:'',execution_summary:'',
  phase:null,plan:null,duration_ms:0
});
fs.writeFileSync('$tmpdir/feedback-state.json', JSON.stringify({
  counter:200,invocation_log:entries,
  last_feedback_at:null,last_update_check_at:null,
  ratings:[],skill_states:{},gaps:[],version:1
}),'utf8');
"
  FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "archive test" "skill" "success" "" "Archive test" "" "" "100" > /dev/null

  # Check log has exactly 200 entries
  local log_len=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8')).invocation_log.length)")
  assert_eq "log trimmed to 200" "200" "$log_len" || { rm -rf "$tmpdir"; return 1; }

  # Check archive has 1 entry
  local archive_len=$(node -e "try{var a=JSON.parse(require('fs').readFileSync('$tmpdir/invocation-log-archive.json','utf8'));console.log(a.length)}catch(e){console.log('0')}" 2>/dev/null || echo "0")
  assert_eq "archive has 1 entry" "1" "$archive_len" || { rm -rf "$tmpdir"; return 1; }

  # Check counter = 200
  local counter=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8')).counter)")
  assert_eq "counter = 200" "200" "$counter" || { rm -rf "$tmpdir"; return 1; }

  rm -rf "$tmpdir"
  return 0
}

# --- 5. test_counter: 5 entries, counter=5, after append counter=6 ---
test_counter() {
  local tmpdir
  tmpdir=$(make_tempdir)
  node -e "
var fs=require('fs');
var entries=[];
for(var i=0;i<5;i++) entries.push({
  timestamp:'2026-01-0'+((i%9)+1)+'T00:00:00.000Z',
  intent:'existing '+i,routed_skill:'test',
  status:'success',error_summary:'',execution_summary:'',
  phase:null,plan:null,duration_ms:0
});
fs.writeFileSync('$tmpdir/feedback-state.json', JSON.stringify({
  counter:5,invocation_log:entries,
  last_feedback_at:null,last_update_check_at:null,
  ratings:[],skill_states:{},gaps:[],version:1
}),'utf8');
"
  FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "counter test" "skill" "success" "" "Counter test" "" "" "0" > /dev/null

  local counter=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8')).counter)")
  local log_len=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8')).invocation_log.length)")

  assert_eq "counter = 6" "6" "$counter" || { rm -rf "$tmpdir"; return 1; }
  assert_eq "log length = 6" "6" "$log_len" || { rm -rf "$tmpdir"; return 1; }

  rm -rf "$tmpdir"
  return 0
}

# --- 6. test_summary: GSD_PROJECT_ROOT set, no plan -> SD-SUMMARY.md ---
test_summary() {
  local tmpdir
  tmpdir=$(make_tempdir)
  mkdir -p "$tmpdir/.planning/phases/09-invocation-log"
  build_state 1 "$tmpdir/feedback-state.json"

  GSD_PROJECT_ROOT="$tmpdir" FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "summary test" "skill" "success" "" "SD-SUMMARY output" "09" "" "500" > /dev/null

  [ -f "$tmpdir/.planning/phases/09-invocation-log/SD-SUMMARY.md" ] || {
    echo "  FAIL: SD-SUMMARY.md not created"; rm -rf "$tmpdir"; return 1
  }

  assert_contains "frontmatter source" "$tmpdir/.planning/phases/09-invocation-log/SD-SUMMARY.md" "source: scientific-do" || { rm -rf "$tmpdir"; return 1; }
  assert_contains "frontmatter phase" "$tmpdir/.planning/phases/09-invocation-log/SD-SUMMARY.md" "phase: 09" || { rm -rf "$tmpdir"; return 1; }
  assert_contains "frontmatter plan" "$tmpdir/.planning/phases/09-invocation-log/SD-SUMMARY.md" "plan: null" || { rm -rf "$tmpdir"; return 1; }
  assert_contains "duration in body" "$tmpdir/.planning/phases/09-invocation-log/SD-SUMMARY.md" "Duration:" || { rm -rf "$tmpdir"; return 1; }

  rm -rf "$tmpdir"
  return 0
}

# --- 7. test_supplement: GSD_PROJECT_ROOT set, plan present -> SD-SUPPLEMENT.md ---
test_supplement() {
  local tmpdir
  tmpdir=$(make_tempdir)
  mkdir -p "$tmpdir/.planning/phases/09-invocation-log"
  build_state 1 "$tmpdir/feedback-state.json"

  GSD_PROJECT_ROOT="$tmpdir" FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "supplement test" "skill" "success" "" "SD-SUPPLEMENT output" "09" "09-01" "500" > /dev/null

  [ -f "$tmpdir/.planning/phases/09-invocation-log/SD-SUPPLEMENT.md" ] || {
    echo "  FAIL: SD-SUPPLEMENT.md not created"; rm -rf "$tmpdir"; return 1
  }

  assert_contains "frontmatter source" "$tmpdir/.planning/phases/09-invocation-log/SD-SUPPLEMENT.md" "source: scientific-do"
  assert_contains "frontmatter phase" "$tmpdir/.planning/phases/09-invocation-log/SD-SUPPLEMENT.md" "phase: 09"
  assert_contains "frontmatter plan" "$tmpdir/.planning/phases/09-invocation-log/SD-SUPPLEMENT.md" "plan: 09-01"

  # SD-SUMMARY.md should NOT exist
  assert_not_exists "no SD-SUMMARY.md" "$tmpdir/.planning/phases/09-invocation-log/SD-SUMMARY.md" || { rm -rf "$tmpdir"; return 1; }

  rm -rf "$tmpdir"
  return 0
}

# --- 8. test_no_gsd_output: GSD_PROJECT_ROOT unset, no SD-*.md ---
test_no_gsd_output() {
  local tmpdir
  tmpdir=$(make_tempdir)
  mkdir -p "$tmpdir/.planning/phases"
  build_state 1 "$tmpdir/feedback-state.json"

  # Intentionally UNSET GSD_PROJECT_ROOT
  FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "no-gsd test" "skill" "success" "" "No GSD output" "09" "09-01" "500" > /dev/null

  local found
  found=$(find "$tmpdir/.planning" -name "SD-*.md" 2>/dev/null | wc -l)
  assert_eq "no SD-*.md files" "0" "$found" || { rm -rf "$tmpdir"; return 1; }

  # But log should still be written
  local log_len=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8')).invocation_log.length)")
  assert_eq "log still written" "2" "$log_len" || { rm -rf "$tmpdir"; return 1; }

  rm -rf "$tmpdir"
  return 0
}

# --- 9. test_triggers: verify %10 and %20 trigger flags ---
test_triggers() {
  # Test %10 trigger
  local tmpdir
  tmpdir=$(make_tempdir)
  node -e "
var fs=require('fs');
var entries=[];
for(var i=0;i<9;i++) entries.push({
  timestamp:'2026-01-0'+((i%9)+1)+'T00:00:00.000Z',
  intent:'existing '+i,routed_skill:'test',
  status:'success',error_summary:'',execution_summary:'',
  phase:null,plan:null,duration_ms:0
});
fs.writeFileSync('$tmpdir/feedback-state.json', JSON.stringify({
  counter:9,invocation_log:entries,
  last_feedback_at:null,last_update_check_at:null,
  ratings:[],skill_states:{},gaps:[],version:1
}),'utf8');
"
  local result10
  result10=$(FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "trigger 10" "skill" "success" "" "Trigger 10th" "" "" "0")
  assert_eq "rating trigger at %10" '{"rating":true,"update_check":false}' "$(echo "$result10" | tail -1)" || { rm -rf "$tmpdir"; return 1; }
  rm -rf "$tmpdir"

  # Test %20 trigger (rating + update)
  tmpdir=$(make_tempdir)
  node -e "
var fs=require('fs');
var entries=[];
for(var i=0;i<19;i++) entries.push({
  timestamp:'2026-01-0'+((i%9)+1)+'T00:00:00.000Z',
  intent:'existing '+i,routed_skill:'test',
  status:'success',error_summary:'',execution_summary:'',
  phase:null,plan:null,duration_ms:0
});
fs.writeFileSync('$tmpdir/feedback-state.json', JSON.stringify({
  counter:19,invocation_log:entries,
  last_feedback_at:null,last_update_check_at:null,
  ratings:[],skill_states:{},gaps:[],version:1
}),'utf8');
"
  local result20
  result20=$(FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "trigger 20" "skill" "success" "" "Trigger 20th" "" "" "0")
  assert_eq "rating+update trigger at %20" '{"rating":true,"update_check":true}' "$(echo "$result20" | tail -1)" || { rm -rf "$tmpdir"; return 1; }
  rm -rf "$tmpdir"

  return 0
}

# --- 10. test_error_summary: status=failure stores error, status=success null ---
test_error_summary() {
  local tmpdir
  tmpdir=$(make_tempdir)
  build_state 1 "$tmpdir/feedback-state.json"

  # Test with failure status + error summary
  FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "error test" "skill" "failure" "Something went wrong" "Error execution" "" "" "0" > /dev/null

  node -e "
var s=JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8'));
var e=s.invocation_log[1];
if(e.status!=='failure'){console.log('status not failure');process.exit(1);}
if(e.error_summary!=='Something went wrong'){console.log('error_summary not stored');process.exit(1);}
console.log('OK');
" || { echo "  FAIL: error_summary for failure status"; rm -rf "$tmpdir"; return 1; }

  # Test with success status — error_summary should still be empty string
  FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "success test" "skill" "success" "" "Success execution" "" "" "0" > /dev/null

  node -e "
var s=JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8'));
var e=s.invocation_log[2];
if(e.status!=='success'){console.log('status not success');process.exit(1);}
if(e.error_summary!==''){console.log('error_summary should be empty: '+e.error_summary);process.exit(1);}
console.log('OK');
" || { echo "  FAIL: error_summary for success status"; rm -rf "$tmpdir"; return 1; }

  # Test with partial status
  FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" "partial test" "skill" "partial" "Partially completed" "Partial execution" "" "" "0" > /dev/null

  node -e "
var s=JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8'));
var e=s.invocation_log[3];
if(e.status!=='partial'){console.log('status not partial');process.exit(1);}
if(e.error_summary!=='Partially completed'){console.log('error_summary not stored for partial');process.exit(1);}
console.log('OK');
" || { echo "  FAIL: error_summary for partial status"; rm -rf "$tmpdir"; return 1; }

  rm -rf "$tmpdir"
  return 0
}

# ============================================================
# Main
# ============================================================

MODE="${1:---all}"
trap cleanup EXIT

echo "=== test-append-invocation-log.sh ==="
echo "Script under test: $APPEND_SCRIPT"
echo ""

case "$MODE" in
  --smoke)
    run_test "test_init" test_init
    run_test "test_append" test_append
    run_test "test_lock" test_lock
    ;;
  --all|*)
    run_test "test_init" test_init
    run_test "test_append" test_append
    run_test "test_lock" test_lock
    run_test "test_archive" test_archive
    run_test "test_counter" test_counter
    run_test "test_summary" test_summary
    run_test "test_supplement" test_supplement
    run_test "test_no_gsd_output" test_no_gsd_output
    run_test "test_triggers" test_triggers
    run_test "test_error_summary" test_error_summary
    ;;
esac

echo "=== Results: $PASS passed, $FAIL failed ==="

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
