#!/usr/bin/env bash
# skill-discovery.sh
# D-10: Search GitHub for candidate skills when gap is detected
# D-11: Phase 2 safety checks documented (security veto, DepthScore, integration)
# D-12: Grading guidance with DepthScore thresholds for skill classification
# D-13: Replacement logic for core/extension pool management
#
# NOTE: This script does NOT execute full Phase 2 evaluation.
# It searches GitHub for candidates and documents the grading framework.
# Full evaluation requires the Phase 2 scoring rubric (out of scope for Phase 7).

set -euo pipefail

CONFIG_FILE="$HOME/.claude/scientific-skills/scientific-skills-config.json"

echo "=== Skill Discovery ==="
echo ""

# Read thresholds from config
CORE_THRESHOLD=$(jq -r '.thresholds.core_auto_activate // 4.0' "$CONFIG_FILE")
EXT_THRESHOLD=$(jq -r '.thresholds.extension_download // 3.0' "$CONFIG_FILE")
EXCLUDE_THRESHOLD=$(jq -r '.thresholds.exclude_below // 3.0' "$CONFIG_FILE")

echo "Thresholds:"
echo "  Core auto-activate: >= $CORE_THRESHOLD"
echo "  Extension download: >= $EXT_THRESHOLD"
echo "  Exclude: < $EXCLUDE_THRESHOLD"
echo ""

# GitHub search for claude-code scientific skills
SEARCH_TERMS=(
  "claude+code+research+skill"
  "claude+code+scientific+skill"
  "claude+code+academic+writing"
  "claude+skill+literature+review"
)

echo "=== Search Results ==="
ALL_RESULTS=""

for term in "${SEARCH_TERMS[@]}"; do
  echo "Searching: $term"
  if command -v gh &>/dev/null; then
    RESULTS=$(gh search repos "$term" --limit 10 --json name,owner,description,url 2>/dev/null || echo "[]")
  else
    # Fallback: use curl to GitHub API search
    ENCODED_TERM=$(echo "$term" | sed 's/+/%20/g')
    RESULTS=$(curl -sf "https://api.github.com/search/repositories?q=${ENCODED_TERM}&per_page=5" | jq '.items[] | {name, full_name, description, html_url}' 2>/dev/null || echo "[]")
  fi

  if [ -n "$RESULTS" ] && [ "$RESULTS" != "[]" ]; then
    ALL_RESULTS="$ALL_RESULTS"$'\n'"$RESULTS"
  fi
  echo ""
done

# Deduplicate and display results
echo "=== Candidate Skills ==="
echo "$ALL_RESULTS" | jq -s 'unique_by(.full_name) | .[] | "\(.full_name // .name) — \(.description // "no description")"' 2>/dev/null || echo "(no results or jq parse failed)"
echo ""

echo "=== Exclusion Check (D-11) ==="
echo "Phase 2 safety checks would be applied:"
echo "1. Security veto check (data safety, permissions, network, dependencies)"
echo "2. DepthScore evaluation (Tier 1: 1-5)"
echo "3. Integration scoring (Tier 2: 5 dimensions)"
echo ""
echo "=== Grading Guidance (D-12) ==="
echo "DepthScore > $CORE_THRESHOLD -> Core (install to ~/.claude/scientific-skills/skills/)"
echo "DepthScore $EXT_THRESHOLD-$CORE_THRESHOLD -> Extension (download to ~/.claude/skills-extensions/)"
echo "DepthScore < $EXCLUDE_THRESHOLD -> Exclude (do not add)"
echo ""
echo "=== Replacement Logic (D-13) ==="
echo "New role -> Add as new core skill"
echo "Same role, stronger score -> Replace core, demote old to extension"
echo "Same role, similar score -> Add to extension pool, coordinator chooses"
