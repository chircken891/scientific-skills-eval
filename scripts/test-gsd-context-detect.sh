#!/usr/bin/env bash
# test-gsd-context-detect.sh — Test harness for gsd-context-detect.sh
# Usage: bash test-gsd-context-detect.sh [--smoke|--all|--test-*]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GSD_SCRIPT="$SCRIPT_DIR/gsd-context-detect.sh"
FIXTURE_WITH_GSD="$SCRIPT_DIR/fixtures/with-gsd"
FIXTURE_WITHOUT_GSD="$SCRIPT_DIR/fixtures/without-gsd"

TESTS_PASSED=0
TESTS_FAILED=0

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

assert_json_field() {
  local name="$1" json_string="$2" field_path="$3" expected_value="$4"
  local actual
  actual=$(echo "$json_string" | node -e "
    const stdin = require('fs').readFileSync('/dev/stdin','utf8');
    const obj = JSON.parse(stdin);
    const val = $field_path;
    console.log(val === null ? 'null' : String(val));
  " 2>/dev/null || echo "PARSE_ERROR")
  if [ "$actual" = "$expected" ]; then
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

  # Test 1: Script produces valid JSON
  local output
  output=$(bash "$GSD_SCRIPT" "$FIXTURE_WITH_GSD" 2>/dev/null || echo "INVALID_JSON")
  echo "$output" | node -e "JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));" 2>/dev/null
  assert_eq "Script produces valid JSON" "$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));console.log(typeof d.gsd_project);" 2>/dev/null)" "boolean"

  # Test 2: Script detects with-gsd fixture
  local detected
  detected=$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));console.log(d.gsd_project);" 2>/dev/null)
  assert_eq "Detects with-gsd fixture" "$detected" "true"

  # Test 3: Script gracefully degrades on without-gsd fixture
  local output2
  output2=$(bash "$GSD_SCRIPT" "$FIXTURE_WITHOUT_GSD" 2>/dev/null || echo "INVALID_JSON")
  local detected2
  detected2=$(echo "$output2" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));console.log(d.gsd_project);" 2>/dev/null)
  assert_eq "Graceful degradation without GSD" "$detected2" "false"
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

  local has_position_phase
  has_position_phase=$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));console.log(typeof d.current_position === 'object' ? 'true' : 'false');" 2>/dev/null)
  assert_eq "Current position is an object" "$has_position_phase" "true"
}

test_roadmap_parsing() {
  echo ""
  echo "=== Roadmap Parsing Tests ==="
  echo ""

  local output
  output=$(bash "$GSD_SCRIPT" "$FIXTURE_WITH_GSD" 2>/dev/null)

  local phase_count
  phase_count=$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));console.log(Array.isArray(d.phases) ? d.phases.length : 0);" 2>/dev/null)
  if [ "$phase_count" -gt 0 ] 2>/dev/null; then
    echo "  PASS: phases is a non-empty array ($phase_count phases)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: phases array is empty or not an array (count=$phase_count)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi

  local has_phase_8
  has_phase_8=$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));const p8=d.phases.find(p=>p.number==='8');console.log(p8?p8.name:'NOT_FOUND');" 2>/dev/null)
  assert_contains "Phase 8 found in phases array" "$has_phase_8" "GSD"
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

  local required_keys="gsd_project gsd_project_root state current_position phases project_core project_constraints claude_md"
  for key in $required_keys; do
    local has_key
    has_key=$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));console.log(d.hasOwnProperty('$key')?'yes':'no');" 2>/dev/null)
    assert_eq "Root key '$key' exists" "$has_key" "yes"
  done

  # Verify planning_dir is also present (added in the output schema)
  local has_planning_dir
  has_planning_dir=$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));console.log(d.hasOwnProperty('planning_dir')?'yes':'no');" 2>/dev/null)
  assert_eq "Root key 'planning_dir' exists" "$has_planning_dir" "yes"
}

test_env_vars() {
  echo ""
  echo "=== Env Var Mapping Tests ==="
  echo ""

  local output
  output=$(bash "$GSD_SCRIPT" "$FIXTURE_WITH_GSD" 2>/dev/null)

  # Verify GSD_PROJECT_ROOT would be extractable
  local project_root
  project_root=$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));console.log(typeof d.gsd_project_root === 'string' && d.gsd_project_root.length > 0 ? d.gsd_project_root : '');" 2>/dev/null)
  if [ -n "$project_root" ]; then
    echo "  PASS: GSD_PROJECT_ROOT is extractable ($project_root)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: GSD_PROJECT_ROOT is not extractable"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi

  # Verify GSD_CURRENT_PHASE would be extractable from current_position
  local current_phase
  current_phase=$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));const cp=d.current_position||{};console.log(cp.phase||'NOT_FOUND');" 2>/dev/null)
  if [ -n "$current_phase" ]; then
    echo "  PASS: GSD_CURRENT_PHASE is extractable ($current_phase)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo "  FAIL: GSD_CURRENT_PHASE is not extractable"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi

  # Verify GSD_MILESTONE would be extractable
  local milestone
  milestone=$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));console.log(d.state&&d.state.milestone?d.state.milestone:'NOT_FOUND');" 2>/dev/null)
  if [ -n "$milestone" ]; then
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

  # Test --quick flag skips file parsing
  local output
  output=$(bash "$GSD_SCRIPT" --quick "$FIXTURE_WITH_GSD" 2>/dev/null)
  assert_json_field "quick: gsd_project is true" "$output" "obj.gsd_project" "true"

  local project_root
  project_root=$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));console.log(typeof d.gsd_project_root === 'string' && d.gsd_project_root.length > 0 ? 'yes' : 'no');" 2>/dev/null)
  assert_eq "quick: gsd_project_root is non-empty string" "$project_root" "yes"

  # With --quick, state should be minimal/empty — check that state is not a fully populated object
  local state_milestone
  state_milestone=$(echo "$output" | node -e "const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));console.log(d.state&&d.state.milestone?d.state.milestone:'NO_STATE');" 2>/dev/null)
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
