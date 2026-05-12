#!/usr/bin/env bash
# update-check.sh
# D-16: Compare local skill state against GitHub upstream for all 10 installed skills.
# D-17: Notification only — no auto-update. Human confirmation required.
#
# Design decisions:
# - Sequential execution to avoid GitHub API rate limiting (D-16 pitfall mitigation)
#   Rate limits: 60 req/hr unauthenticated, 5000 req/hr via gh CLI.
#   With 10 skills serialized, each run uses ~10 calls — well within limits.
# - Uses `gh` CLI first (authenticated, 5000 req/hr), falls back to `curl` (60 req/hr)
# - academic-paper-analysis gets SKIP (repo: null — local skill, no remote upstream)
# - SHAs persisted in feedback-state.json skill_states for cross-session tracking
# - Exit code 0 always — notification only, no error on "updates found" (per D-17)

set -euo pipefail

CONFIG_FILE="$HOME/.claude/scientific-skills/scientific-skills-config.json"
STATE_FILE="$HOME/.claude/scientific-skills/feedback-state.json"

echo "=== Skill Update Check ==="
echo "Date: $(date)"
echo ""

# Read skill_registry from config
SKILLS=$(jq -r '.skill_registry | to_entries[] | "\(.key)|\(.value.repo)"' "$CONFIG_FILE")

UPDATES_FOUND=0

while IFS='|' read -r skill_name repo; do
  if [ "$repo" = "null" ]; then
    echo "SKIP: $skill_name (no remote repo — local skill)"
    continue
  fi

  echo -n "CHECK: $skill_name ($repo) ... "

  # Get last known SHA from state file
  LAST_SHA=$(jq -r --arg s "$skill_name" '(.skill_states | .[$s]) .last_known_sha // ""' "$STATE_FILE")

  # Get remote SHA from GitHub API
  REMOTE_SHA=""
  if command -v gh &>/dev/null; then
    REMOTE_SHA=$(gh api "repos/$repo/commits/HEAD" --jq '.sha' 2>/dev/null || echo "")
  fi
  if [ -z "$REMOTE_SHA" ]; then
    REMOTE_SHA=$(curl -sf "https://api.github.com/repos/$repo/commits/HEAD" | jq -r '.sha' 2>/dev/null || echo "")
  fi

  if [ -z "$REMOTE_SHA" ] || [ "$REMOTE_SHA" = "null" ]; then
    echo "API FAILED"
    continue
  fi

  if [ -z "$LAST_SHA" ]; then
    # First check — store SHA, no comparison
    echo "INITIAL CHECK: $REMOTE_SHA"
    jq --arg s "$skill_name" --arg sha "$REMOTE_SHA" \
      '.skill_states[$s].last_known_sha = $sha | .skill_states[$s].updated_at = now' \
      "$STATE_FILE" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "$STATE_FILE"
  elif [ "$LAST_SHA" != "$REMOTE_SHA" ]; then
    echo "UPDATE AVAILABLE"
    echo "  Local:  $LAST_SHA"
    echo "  Remote: $REMOTE_SHA"
    UPDATES_FOUND=$((UPDATES_FOUND + 1))
    # Update SHA
    jq --arg s "$skill_name" --arg sha "$REMOTE_SHA" \
      '.skill_states[$s].last_known_sha = $sha | .skill_states[$s].updated_at = now' \
      "$STATE_FILE" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "$STATE_FILE"
  else
    echo "UP TO DATE"
  fi
done <<< "$SKILLS"

echo ""
if [ "$UPDATES_FOUND" -gt 0 ]; then
  echo "=== $UPDATES_FOUND update(s) available ==="
  echo "NOTIFICATION: Updates detected for $UPDATES_FOUND skill(s)."
  echo "Action required: Review update summaries before applying."
  echo "WARNING: Auto-update disabled per D-17. Human confirmation required."
  exit 0
else
  echo "=== All skills up to date ==="
  exit 0
fi
