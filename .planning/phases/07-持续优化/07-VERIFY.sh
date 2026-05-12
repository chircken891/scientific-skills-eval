#!/usr/bin/env bash
# Phase 7 Verification Suite
# Verifies all D-xx items across the Phase 7 plans.
# Usage: bash 07-VERIFY.sh
# Exit code: 0 if all checks pass, 1 if any check fails.

set -uo pipefail

# --- Colors ---
PASS="\033[32mPASS\033[0m"
FAIL="\033[31mFAIL\033[0m"
ALL_PASS=true

# --- Paths ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PHASE_DIR="$SCRIPT_DIR"

SKILLS_BASE="$HOME/.claude/scientific-skills/skills"
DOCTOR_SKILL="$SKILLS_BASE/scientific-do/SKILL.md"
FEEDBACK_FILE="$HOME/.claude/scientific-skills/feedback-state.json"
SCIDO_FILE="$HOME/.claude/scientific-skills/skills/scientific-do/SKILL.md"

SKILL_DIRS=(
  "$SKILLS_BASE/deepxiv_sdk"
  "$SKILLS_BASE/academic-paper-analysis"
  "$SKILLS_BASE/scientific-agent-skills"
  "$SKILLS_BASE/academic-writing-skills"
  "$SKILLS_BASE/paper-plot-skills"
  "$SKILLS_BASE/Paper-Polish-Workflow-skill"
  "$SKILLS_BASE/medsci-skills"
  "$SKILLS_BASE/scientific-do"
)

echo "==== Phase 7 Verification Suite ===="
echo ""

# -------------------------------------------------------
# D-03: Structured registration (triggers + exclude_when)
# -------------------------------------------------------
echo "--- D-03: Structured Skill Registration ---"
TRIGGER_COUNT=0
EXCLUDE_COUNT=0
TOTAL_SKILLS=${#SKILL_DIRS[@]}

for dir in "${SKILL_DIRS[@]}"; do
  f="$dir/SKILL.md"
  if [ -f "$f" ]; then
    grep -q 'triggers:' "$f" && ((TRIGGER_COUNT++))
    grep -q 'exclude_when:' "$f" && ((EXCLUDE_COUNT++))
  fi
done

if [ "$TRIGGER_COUNT" -eq "$TOTAL_SKILLS" ]; then
  echo -e "  D-03 triggers: $TRIGGER_COUNT/$TOTAL_SKILLS $PASS"
else
  echo -e "  D-03 triggers: $TRIGGER_COUNT/$TOTAL_SKILLS $FAIL"
  ALL_PASS=false
fi

if [ "$EXCLUDE_COUNT" -eq "$TOTAL_SKILLS" ]; then
  echo -e "  D-03 exclude_when: $EXCLUDE_COUNT/$TOTAL_SKILLS $PASS"
else
  echo -e "  D-03 exclude_when: $EXCLUDE_COUNT/$TOTAL_SKILLS $FAIL"
  ALL_PASS=false
fi
echo ""

# -------------------------------------------------------
# D-06: Model preference field
# -------------------------------------------------------
echo "--- D-06: Model Preference Declaration ---"
MODEL_COUNT=0
for dir in "${SKILL_DIRS[@]}"; do
  f="$dir/SKILL.md"
  if [ -f "$f" ]; then
    grep -q '^model:' "$f" && ((MODEL_COUNT++))
  fi
done

if [ "$MODEL_COUNT" -eq "$TOTAL_SKILLS" ]; then
  echo -e "  D-06 model: $MODEL_COUNT/$TOTAL_SKILLS $PASS"
else
  echo -e "  D-06 model: $MODEL_COUNT/$TOTAL_SKILLS $FAIL"
  ALL_PASS=false
fi
echo ""

# -------------------------------------------------------
# D-14: Feedback state file
# -------------------------------------------------------
echo "--- D-14: Feedback State File ---"
if [ -f "$FEEDBACK_FILE" ]; then
  if command -v jq &>/dev/null; then
    if jq -e '.counter' "$FEEDBACK_FILE" > /dev/null 2>&1; then
      echo -e "  D-14 PASS: feedback-state.json exists with counter key $PASS"
    else
      echo -e "  D-14 FAIL: feedback-state.json missing 'counter' key $FAIL"
      ALL_PASS=false
    fi
  else
    # jq not available — fallback to grep
    if grep -q '"counter"' "$FEEDBACK_FILE" 2>/dev/null; then
      echo -e "  D-14 PASS: feedback-state.json has counter field $PASS"
    else
      echo -e "  D-14 FAIL: feedback-state.json missing counter field $FAIL"
      ALL_PASS=false
    fi
  fi
else
  echo -e "  D-14 FAIL: feedback-state.json not found at $FEEDBACK_FILE $FAIL"
  ALL_PASS=false
fi
echo ""

# -------------------------------------------------------
# D-07: Benchmark script exists and is executable
# -------------------------------------------------------
echo "--- D-07: Benchmark Script ---"
BENCH_SCRIPT="$PHASE_DIR/scripts/benchmark.sh"
if [ -f "$BENCH_SCRIPT" ] && [ -x "$BENCH_SCRIPT" ]; then
  if grep -q 'bench_skill\|Benchmarking\|Parse time\|Route time' "$BENCH_SCRIPT" 2>/dev/null; then
    echo -e "  D-07 PASS: benchmark.sh exists and contains timing functions $PASS"
  else
    echo -e "  D-07 FAIL: benchmark.sh missing expected content $FAIL"
    ALL_PASS=false
  fi
else
  if [ -f "$BENCH_SCRIPT" ]; then
    echo -e "  D-07 FAIL: benchmark.sh exists but is NOT executable $FAIL"
  else
    echo -e "  D-07 FAIL: benchmark.sh not found at $BENCH_SCRIPT $FAIL"
  fi
  ALL_PASS=false
fi
echo ""

# -------------------------------------------------------
# D-04: Proactive Intent Detection marker in scientific-do
# -------------------------------------------------------
echo "--- D-04: Proactive Intent Detection ---"
if [ -f "$DOCTOR_SKILL" ]; then
  if grep -q '### 1. Proactive Intent Parsing' "$DOCTOR_SKILL"; then
    echo -e "  D-04 PASS: '### 1. Proactive Intent Parsing' found $PASS"
  else
    echo -e "  D-04 FAIL: '### 1. Proactive Intent Parsing' not found in scientific-do $FAIL"
    ALL_PASS=false
  fi
else
  echo -e "  D-04 FAIL: scientific-do/SKILL.md not found $FAIL"
  ALL_PASS=false
fi
echo ""

# -------------------------------------------------------
# D-05: Post-Action Verification marker in scientific-do
# -------------------------------------------------------
echo "--- D-05: Post-Action Verification ---"
if [ -f "$DOCTOR_SKILL" ]; then
  if grep -q '### 5. Post-Action Verification' "$DOCTOR_SKILL"; then
    echo -e "  D-05 PASS: '### 5. Post-Action Verification' found $PASS"
  else
    echo -e "  D-05 FAIL: '### 5. Post-Action Verification' not found in scientific-do $FAIL"
    ALL_PASS=false
  fi
else
  echo -e "  D-05 FAIL: scientific-do/SKILL.md not found $FAIL"
  ALL_PASS=false
fi
echo ""

# -------------------------------------------------------
# D-09: Gap Detection in scientific-do
# -------------------------------------------------------
echo "--- D-09: Gap Detection ---"
if [ -f "$DOCTOR_SKILL" ]; then
  if grep -q 'Gap Detection (D-09)' "$DOCTOR_SKILL"; then
    echo -e "  D-09 PASS: Gap Detection section found in scientific-do $PASS"
  else
    echo -e "  D-09 FAIL: 'Gap Detection (D-09)' not found in scientific-do $FAIL"
    ALL_PASS=false
  fi

  if grep -q 'skill-discovery.sh' "$DOCTOR_SKILL"; then
    echo -e "  D-09 PASS: skill-discovery.sh reference found in scientific-do $PASS"
  else
    echo -e "  D-09 FAIL: skill-discovery.sh not referenced in scientific-do $FAIL"
    ALL_PASS=false
  fi
else
  echo -e "  D-09 FAIL: scientific-do/SKILL.md not found $FAIL"
  ALL_PASS=false
fi

# Check feedback-state.json has gaps array
if [ -f "$FEEDBACK_FILE" ]; then
  if command -v jq &>/dev/null; then
    if jq -e '.gaps | type == "array"' "$FEEDBACK_FILE" > /dev/null 2>&1; then
      echo -e "  D-09 PASS: feedback-state.json has gaps array $PASS"
    else
      echo -e "  D-09 FAIL: feedback-state.json missing gaps array $FAIL"
      ALL_PASS=false
    fi
  else
    if grep -q '"gaps"' "$FEEDBACK_FILE" 2>/dev/null; then
      echo -e "  D-09 PASS: feedback-state.json has gaps field $PASS"
    else
      echo -e "  D-09 FAIL: feedback-state.json missing gaps field $FAIL"
      ALL_PASS=false
    fi
  fi
else
  echo -e "  D-09 FAIL: feedback-state.json not found $FAIL"
  ALL_PASS=false
fi
echo ""

# -------------------------------------------------------
# D-19: Extension activation marker in scientific-do routing
# -------------------------------------------------------
echo "--- D-19: Extension Skill Activation ---"
if [ -f "$DOCTOR_SKILL" ]; then
  if grep -q 'Extension pool check' "$DOCTOR_SKILL"; then
    echo -e "  D-19 PASS: Extension pool check found in scientific-do $PASS"
  else
    echo -e "  D-19 FAIL: Extension pool check not found in scientific-do $FAIL"
    ALL_PASS=false
  fi
else
  echo -e "  D-19 FAIL: scientific-do/SKILL.md not found $FAIL"
  ALL_PASS=false
fi
echo ""

# -------------------------------------------------------
# D-16: Update check script
# -------------------------------------------------------
echo "--- D-16: Update Check Script ---"
UPDATE_SCRIPT="$PHASE_DIR/scripts/update-check.sh"
if [ -f "$UPDATE_SCRIPT" ]; then
  if grep -q 'LOCAL_SHA\|REMOTE_SHA\|git rev-parse\|update' "$UPDATE_SCRIPT" 2>/dev/null; then
    echo -e "  D-16 PASS: update-check.sh exists with update logic $PASS"
  else
    echo -e "  D-16 FAIL: update-check.sh missing expected content $FAIL"
    ALL_PASS=false
  fi
else
  echo -e "  D-16 FAIL: update-check.sh not found at $UPDATE_SCRIPT $FAIL"
  ALL_PASS=false
fi
echo ""

# -------------------------------------------------------
# D-10/D-11: Discovery script
# -------------------------------------------------------
echo "--- D-10/D-11: Skill Discovery Script ---"
DISCOVERY_SCRIPT="$PHASE_DIR/scripts/skill-discovery.sh"
if [ -f "$DISCOVERY_SCRIPT" ]; then
  if grep -q 'GITHUB\|skill-discovery\|DepthScore\|discovery' "$DISCOVERY_SCRIPT" 2>/dev/null; then
    echo -e "  D-10/D-11 PASS: skill-discovery.sh exists with discovery logic $PASS"
  else
    echo -e "  D-10/D-11 FAIL: skill-discovery.sh missing expected content $FAIL"
    ALL_PASS=false
  fi
else
  echo -e "  D-10/D-11 FAIL: skill-discovery.sh not found at $DISCOVERY_SCRIPT $FAIL"
  ALL_PASS=false
fi
echo ""

# -------------------------------------------------------
# D-16 check: update-check.sh (Plan 04 version)
# -------------------------------------------------------
echo ""
echo "--- D-16: Update Check Script ---"
UPDATE_SCRIPT_NEW="$PHASE_DIR/scripts/update-check.sh"
if [ -x "$UPDATE_SCRIPT_NEW" ]; then
  echo -e "  D-16 PASS: update-check.sh exists and executable $PASS"
else
  echo -e "  D-16 FAIL: update-check.sh missing or not executable $FAIL"
  ALL_PASS=false
fi

# -------------------------------------------------------
# D-10/D-11 check: skill-discovery.sh (Plan 04 version)
# -------------------------------------------------------
echo ""
echo "--- D-10/D-11: Skill Discovery ---"
DISCOVERY_SCRIPT_NEW="$PHASE_DIR/scripts/skill-discovery.sh"
if [ -x "$DISCOVERY_SCRIPT_NEW" ]; then
  echo -e "  D-10/D-11 PASS: skill-discovery.sh exists and executable $PASS"
else
  echo -e "  D-10/D-11 FAIL: skill-discovery.sh missing or not executable $FAIL"
  ALL_PASS=false
fi

# -------------------------------------------------------
# D-18 check: Smoke test procedure documented
# -------------------------------------------------------
echo ""
echo "--- D-18: Smoke Test Procedure ---"
if grep -q "完成后必须验证" "$SCIDO_FILE" 2>/dev/null || grep -q "smoke" "$PHASE_DIR/scripts/update-check.sh" 2>/dev/null; then
  echo -e "  D-18 PASS: Post-update verification documented $PASS"
else
  echo -e "  D-18 FAIL: Post-update verification not found $FAIL"
  ALL_PASS=false
fi

# -------------------------------------------------------
# Summary
# -------------------------------------------------------
echo "==== Summary ===="
if [ "$ALL_PASS" = true ]; then
  echo -e "  $PASS All checks passed"
  exit 0
else
  echo -e "  $FAIL One or more checks failed"
  exit 1
fi
