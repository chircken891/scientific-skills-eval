#!/usr/bin/env bash
# Phase 7 Performance Benchmark Script (P6-E01)
# Measures parse time, route time, and file size for all 7 core scientific skills.
# Usage: bash scripts/benchmark.sh
# Output: TSV table to stdout + saved to benchmark-results-<timestamp>.tsv

set -uo pipefail

SKILLS_BASE="$HOME/.claude/scientific-skills/skills"

# Define the 7 core skills (excluding scientific-do which is the coordinator)
SKILL_NAMES=(
  "deepxiv_sdk"
  "academic-paper-analysis"
  "scientific-agent-skills"
  "academic-writing-skills"
  "paper-plot-skills"
  "Paper-Polish-Workflow-skill"
  "medsci-skills"
)

REPRESENTATIVE_QUERIES=(
  "search for papers on CRISPR"
  "analyze this paper methodology"
  "run statistical analysis on dataset"
  "write paper introduction section"
  "create figure from data"
  "polish manuscript for submission"
  "check PRISMA compliance"
)

bench_skill() {
  local name="$1"
  local query="$2"
  local skill_dir="$SKILLS_BASE/$name"

  # Check if skill exists
  if [ ! -d "$skill_dir" ] || [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "  [SKIP] $name: SKILL.md not found"
    return 1
  fi

  local file_size=0
  local parse_time_ms=0
  local route_time_ms=0
  local start=0
  local load_end=0
  local match_end=0

  # Get file size
  file_size=$(wc -c < "$skill_dir/SKILL.md" 2>/dev/null || echo 0)

  # Measure SKILL.md parse time (head + read to a variable)
  start=$(date +%s%N)
  # Simulate loading and parsing SKILL.md frontmatter
  head -20 "$skill_dir/SKILL.md" > /dev/null
  local content
  content=$(head -20 "$skill_dir/SKILL.md" 2>/dev/null)
  load_end=$(date +%s%N)
  parse_time_ms=$(( (load_end - start) / 1000000 ))

  # Measure route/match time (grep for trigger fields)
  start=$(date +%s%N)
  grep -q "triggers\|description" "$skill_dir/SKILL.md" 2>/dev/null
  match_end=$(date +%s%N)
  route_time_ms=$(( (match_end - start) / 1000000 ))

  # Print this skill's results
  # Intent: This indentation style works with the column-aligned TSV below
  echo "  $name"
  echo "    Query: \"$query\""
  echo "    Parse time: ${parse_time_ms}ms"
  echo "    Route time: ${route_time_ms}ms"
  echo "    File size: ${file_size} bytes"
  echo ""

  # Return tab-separated row for the summary table
  printf "%s\t%d\t%d\t%d\n" "$name" "$parse_time_ms" "$route_time_ms" "$file_size"
}

# --- Main ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PHASE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_FILE="$PHASE_DIR/benchmark-results-$(date +%Y%m%d-%H%M%S).tsv"
LATEST_LINK="$PHASE_DIR/benchmark-results.tsv"

echo "========================================"
echo " Phase 7 Performance Benchmark (P6-E01)"
echo "========================================"
echo ""
echo "Measuring 7 core skills..."
echo ""

# Run benchmarks, collecting TSV rows
TSV_ROWS=""
for i in "${!SKILL_NAMES[@]}"; do
  name="${SKILL_NAMES[$i]}"
  query="${REPRESENTATIVE_QUERIES[$i]}"

  echo "=== Benchmarking: $name ==="
  row=$(bench_skill "$name" "$query")
  # Extract only the TSV row (last line of output that starts with skill name)
  tsv_line=$(echo "$row" | grep "^${name}\s")
  if [ -n "$tsv_line" ]; then
    TSV_ROWS="${TSV_ROWS}${tsv_line}"$'\n'
  fi
done

# Print TSV summary table
echo "========================================"
echo " Benchmark Results (TSV)"
echo "========================================"
echo -e "Skill\tParse(ms)\tRoute(ms)\tFileSize(bytes)"
echo -e "$TSV_ROWS" | head -n 7

# Save to file
{
  echo -e "Skill\tParse(ms)\tRoute(ms)\tFileSize(bytes)"
  echo -e "$TSV_ROWS" | head -n 7
} > "$OUTPUT_FILE"

# Update latest symlink (or copy on Windows without ln -f)
if command -v ln &>/dev/null; then
  ln -sf "$(basename "$OUTPUT_FILE")" "$LATEST_LINK" 2>/dev/null || \
    cp "$OUTPUT_FILE" "$LATEST_LINK"
else
  cp "$OUTPUT_FILE" "$LATEST_LINK"
fi

echo ""
echo "Saved to: $OUTPUT_FILE"
echo "Latest:   $LATEST_LINK"
echo ""
echo "========================================"
echo " Benchmark Complete"
echo "========================================"
