#!/usr/bin/env bash
# test-gsd-context-detect.sh — Test harness for gsd-context-detect.sh
#
# Cross-platform: uses process.argv and process.stdin streaming for node -e
# (does not depend on /dev/stdin which is unavailable on Windows)
#
# Usage: bash test-gsd-context-detect.sh [--smoke|--all|--test-*]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GSD_SCRIPT="$SCRIPT_DIR/gsd-context-detect.sh"
FIXTURE_WITH_GSD="$SCRIPT_DIR/fixtures/with-gsd"
FIXTURE_WITHOUT_GSD="$SCRIPT_DIR/fixtures/without-gsd"

TESTS_PASSED=0
TESTS_FAILED=0

# Cross-platform: reads piped stdin from node via process.stdin streaming
PIPE_NODE='let d="";process.stdin.setEncoding("utf8");process.stdin.on("data",c=>d+=c);process.stdin.on("end",()=>{'

assert_eq() {
  local name="$1" actual="$2" expected="$3"
  if [ "$actual" = "$expected" ]; then
    echo "  PASS: $name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $name (expected: '$expected', actual: '$actual')"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

assert_contains() {
  local name="$1" string="$2" substring="$3"
  if echo "$string" | grep -qF "$substring"; then
    echo "  PASS: $name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $name (string does not contain '$substring')"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

# Evaluates a field path expression on a JSON string (passed as argument)
# Usage: json_field <json_string> <node_code_using_obj>
# Returns: script stdout (or "PARSE_ERROR" on failure)
json_field() {
  local json_string="$1" code="$2"
  node -e "
const obj = JSON.parse(process.argv[1]);
$code
" "$json_string" 2>/dev/null || echo "PARSE_ERROR"
}

assert_json_field() {
  local name="$1" json_string="$2" field_path="$3" expected_value="$4"
  local actual
  actual=$(json_field "$json_string" "console.log($field_path)")
  if [ "$actual" = "$expected_value" ]; then
    echo "  PASS: $name ($field_path == $expected_value)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $name ($field_path expected '$expected_value', got '$actual')"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

run_test() {
  local name="$1" cmd="$2"
  if eval "$cmd" 2>/dev/null; then
    echo "  PASS: $name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: $name (command exited non-zero)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

test_smoke() {
  echo ""
  echo "=== Smoke Tests ==="
  echo ""

  # Test 1: Script produces valid JSON with gsd_project boolean
  local output
  output=$(bash "$GSD_SCRIPT" "$FIXTURE_WITH_GSD" 2>/dev/null || echo "INVALID_JSON")
  local detected
  detected=$(json_field "$output" "console.log(typeof obj.gsd_project)")
  assert_eq "Script produces valid JSON with gsd_project field" "$detected" "boolean"

  # Test 2: Script detects with-gsd fixture
  local gsd_val
  gsd_val=$(json_field "$output" "console.log(obj.gsd_project)")
  assert_eq "Detects with-gsd fixture" "$gsd_val" "true"

  # Test 3: Script gracefully degrades on without-gsd fixture
  local output2
  output2=$(bash "$GSD_SCRIPT" "$FIXTURE_WITHOUT_GSD" 2>/dev/null || echo "INVALID_JSON")
  local gsd_val2
  gsd_val2=$(json_field "$output2" "console.log(obj.gsd_project)")
  assert_eq "Graceful degradation without GSD" "$gsd_val2" "false"
}

test_state_parsing() {
  echo ""
  echo "=== State Parsing Tests ==="
  echo ""

  local output
  output=$(bash "$GSD_SCRIPT" "$FIXTURE_WITH_GSD" 2>/dev/null)

  assert_json_field "Milestone is v1.1" "$output" "obj.state.milestone" "v1.1"
  assert_json_field "Status is planning" "$output" "obj.state.status" "planning"
  assert_json_field "Total phases is 1" "$output" "obj.state.progress.total_phases" "1"
  assert_json_field "Completed phases is 0" "$output" "obj.state.progress.completed_phases" "0"

  local has_position
  has_position=$(json_field "$output" "console.log(typeof obj.current_position === 'object')")
  assert_eq "Current position is an object" "$has_position" "true"
}

test_roadmap_parsing() {
  echo ""
  echo "=== Roadmap Parsing Tests ==="
  echo ""

  local output
  output=$(bash "$GSD_SCRIPT" "$FIXTURE_WITH_GSD" 2>/dev/null)

  local phase_count
  phase_count=$(json_field "$output" "console.log(Array.isArray(obj.phases) ? String(obj.phases.length) : '0')")
  if [ "$phase_count" -gt 0 ] 2>/dev/null; then
    echo "  PASS: phases is a non-empty array ($phase_count phases)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: phases array is empty or not an array (count=$phase_count)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi

  local phase_8_name
  phase_8_name=$(json_field "$output" "const p8=obj.phases.find(p=>p.number==='8');console.log(p8?p8.name:'NOT_FOUND')")
  assert_contains "Phase 8 found in phases array" "$phase_8_name" "GSD"
}

test_no_gsd() {
  echo ""
  echo "=== No-GSD Degradation Tests ==="
  echo ""

  local output
  output=$(bash "$GSD_SCRIPT" "$FIXTURE_WITHOUT_GSD" 2>/dev/null)

  assert_json_field "gsd_project is false" "$output" "obj.gsd_project" "false"
}

test_json_output() {
  echo ""
  echo "=== JSON Output Structure Tests ==="
  echo ""

  local output
  output=$(bash "$GSD_SCRIPT" "$FIXTURE_WITH_GSD" 2>/dev/null)

  local required_keys="gsd_project gsd_project_root state current_position phases project_core project_constraints claude_md planning_dir"
  for key in $required_keys; do
    local has_key
    has_key=$(json_field "$output" "console.log(obj.hasOwnProperty('$key') ? 'yes' : 'no')")
    assert_eq "Root key '$key' exists" "$has_key" "yes"
  done
}

test_env_vars() {
  echo ""
  echo "=== Env Var Mapping Tests ==="
  echo ""

  local output
  output=$(bash "$GSD_SCRIPT" "$FIXTURE_WITH_GSD" 2>/dev/null)

  # GSD_PROJECT_ROOT
  local project_root
  project_root=$(json_field "$output" "console.log(typeof obj.gsd_project_root === 'string' && obj.gsd_project_root.length > 0 ? obj.gsd_project_root : '')")
  if [ -n "$project_root" ]; then
    echo "  PASS: GSD_PROJECT_ROOT is extractable ($project_root)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: GSD_PROJECT_ROOT is not extractable"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi

  # GSD_CURRENT_PHASE from current_position
  local current_phase
  current_phase=$(json_field "$output" "const cp=obj.current_position||{};console.log(cp.phase||'NOT_FOUND')")
  if [ -n "$current_phase" ] && [ "$current_phase" != "NOT_FOUND" ]; then
    echo "  PASS: GSD_CURRENT_PHASE is extractable ($current_phase)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: GSD_CURRENT_PHASE is not extractable"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi

  # GSD_MILESTONE
  local milestone
  milestone=$(json_field "$output" "console.log(obj.state&&obj.state.milestone?obj.state.milestone:'NOT_FOUND')")
  if [ -n "$milestone" ] && [ "$milestone" != "NOT_FOUND" ]; then
    echo "  PASS: GSD_MILESTONE is extractable ($milestone)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: GSD_MILESTONE is not extractable"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

test_quick_flag() {
  echo ""
  echo "=== Quick Flag Tests ==="
  echo ""

  local output
  output=$(bash "$GSD_SCRIPT" --quick "$FIXTURE_WITH_GSD" 2>/dev/null)

  assert_json_field "quick: gsd_project is true" "$output" "obj.gsd_project" "true"

  local has_root
  has_root=$(json_field "$output" "console.log(typeof obj.gsd_project_root === 'string' && obj.gsd_project_root.length > 0 ? 'yes' : 'no')")
  assert_eq "quick: gsd_project_root is non-empty string" "$has_root" "yes"

  # With --quick, state should be absent/unset
  local state_milestone
  state_milestone=$(json_field "$output" "console.log(obj.state&&obj.state.milestone?obj.state.milestone:'NO_STATE')")
  assert_eq "quick: state is not fully parsed (milestone missing)" "$state_milestone" "NO_STATE"
}

show_summary() {
  echo ""
  echo "=== Summary ==="
  echo "Passed: $TESTS_PASSED"
  echo "Failed: $TESTS_FAILED"
  if [ "$TESTS_FAILED" -eq 0 ]; then
    echo "Result: ALL TESTS PASSED"
  else
    echo "Result: SOME TESTS FAILED"
  fi
}

# ---- Command-line dispatch ----
if [ $# -eq 0 ]; then
  echo "Usage: bash test-gsd-context-detect.sh [--smoke|--all|--test-state-parsing|--test-roadmap-parsing|--test-no-gsd|--test-json-output|--test-env-vars]"
  exit 1
fi

case "$1" in
  --smoke)
    test_smoke
    show_summary
    ;;
  --test-state-parsing)
    test_state_parsing
    show_summary
    ;;
  --test-roadmap-parsing)
    test_roadmap_parsing
    show_summary
    ;;
  --test-no-gsd)
    test_no_gsd
    show_summary
    ;;
  --test-json-output)
    test_json_output
    show_summary
    ;;
  --test-env-vars)
    test_env_vars
    show_summary
    ;;
  --all)
    test_smoke
    test_state_parsing
    test_roadmap_parsing
    test_no_gsd
    test_json_output
    test_env_vars
    test_quick_flag
    show_summary
    ;;
  *)
    echo "Unknown option: $1"
    echo "Usage: bash test-gsd-context-detect.sh [--smoke|--all|--test-state-parsing|--test-roadmap-parsing|--test-no-gsd|--test-json-output|--test-env-vars]"
    exit 1
    ;;
esac

exit $([ "$TESTS_FAILED" -eq 0 ] && echo 0 || echo 1)
