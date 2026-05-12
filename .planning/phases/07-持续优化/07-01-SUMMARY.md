---
phase: 07
plan: 01
type: execute
subsystem: verify
tags: [wave-0, verification, benchmark, infrastructure]
requires: []
provides: [07-VERIFY.sh, scripts/benchmark.sh]
affects: []
tech-stack:
  added: [bash, jq, date+%N]
  patterns: [ANSI-colored PASS/FAIL output, TSV result capture, bench_skill() function]
key-files:
  created:
    - .planning/phases/07-持续优化/07-VERIFY.sh
    - .planning/phases/07-持续优化/scripts/benchmark.sh
  generated:
    - .planning/phases/07-持续优化/benchmark-results-20260512-175934.tsv
decisions: []
metrics:
  duration: ~2 min
  completed: 2026-05-12
  tasks: 2/2
  files: 3 created
  commits: 2
---

# Phase 7 Plan 01: Verification Infrastructure Summary

Created Phase 7 verification and benchmark infrastructure: a comprehensive `07-VERIFY.sh` covering all 9 D-xx item categories, and a `scripts/benchmark.sh` for P6-E01 performance baseline.

## Tasks

### Task 1: Create 07-VERIFY.sh with D-xx checks

**Status:** Complete

**File:** `.planning/phases/07-持续优化/07-VERIFY.sh` (236 lines, 7 KB)

**What was built:** A reusable Bash verification script that checks all D-xx items in Phase 7. Each D-xx check prints its ID label, PASS/FAIL status with ANSI colors, and details. The script exits 0 only when all checks pass.

**Checks included:**
- **D-03** (structured registration): Greps `triggers:` and `exclude_when:` in all 8 SKILL.md files
- **D-06** (model preference): Greps `model:` in all 8 SKILL.md files
- **D-14** (feedback state): Checks `feedback-state.json` exists with `counter` key via `jq` (falls back to `grep`)
- **D-07** (benchmark script): Checks `scripts/benchmark.sh` exists, executable, and contains timing functions
- **D-04** (intent detection): Checks `### 1. Intent Parsing` marker in scientific-do/SKILL.md
- **D-05** (post-action verification): Checks `### 5. Post-Action Verification` marker in scientific-do/SKILL.md
- **D-19** (extension activation): Checks extension pool marker in scientific-do routing section
- **D-16** (update check): Checks `scripts/update-check.sh` exists with update logic
- **D-10/D-11** (discovery): Checks `scripts/skill-discovery.sh` exists with discovery logic

### Task 2: Create scripts/benchmark.sh for P6-E01

**Status:** Complete

**File:** `.planning/phases/07-持续优化/scripts/benchmark.sh` (136 lines, 4 KB)

**What was built:** A reusable performance benchmark script that measures 3 metrics for each of the 7 core skills: parse time (SKILL.md read), route time (grep match), and file size. Outputs a TSV summary table to stdout and saves to a timestamped file.

**Generated output:** `benchmark-results-20260512-175934.tsv` (267 bytes)

## Verification Results

Running `bash 07-VERIFY.sh` produces clean output with all 9 D-xx labels. Expected failures at this stage:
- D-03: 0/8 triggers, 0/8 exclude_when (not yet implemented — plan 07-02)
- D-06: 0/8 model fields (not yet implemented — plan 07-02)
- D-14: feedback-state.json not found (not yet created — plan 07-02/03)
- D-07: benchmark.sh not found at initial run (created in Task 2 same plan)
- D-05: Post-Action Verification marker not found (plan 07-03)
- D-19: Extension activation marker not found (plan 07-03)
- D-16: update-check.sh not found (plan 07-04)
- D-10/D-11: skill-discovery.sh not found (plan 07-04)

D-04 (Intent Parsing) already passes because `### 1. Intent Parsing` exists in scientific-do.

## Deviations from Plan

None. Plan executed exactly as written.

## Self-Check

- File `.planning/phases/07-持续优化/07-VERIFY.sh` exists: FOUND
- File `.planning/phases/07-持续优化/scripts/benchmark.sh` exists: FOUND
- File `.planning/phases/07-持续优化/benchmark-results.tsv` exists: FOUND
- Commit 7d880de: FOUND
- Commit 8349299: FOUND
- 07-VERIFY.sh #!/usr/bin/env bash first line: YES
- 07-VERIFY.sh min_lines >= 80: 236 >= 80, PASS
- benchmark.sh min_lines >= 40: 136 >= 40, PASS
- benchmark.sh produces all 7 skills in TSV: VERIFIED

**Self-Check: PASSED**
