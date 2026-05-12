---
phase: 07-continuous-optimization
fixed: 2026-05-12T19:00:00Z
source: 07-REVIEW.md
fix_scope: critical_warning
findings_in_scope: 8
fixed: 8
skipped: 0
iteration: 1
status: all_fixed
commits:
  - acc4347
  - 2bab704
  - 84467c7
  - 09ccbf3
  - ace7776
  - 3a5d277
  - 58a49ff
  - e7bfad3
---

# Phase 7: Code Review Fix Report

**Fixed:** 2026-05-12T19:00:00Z
**Source:** 07-REVIEW.md
**Status:** all_fixed

## Fix Summary

| ID | File | Issue | Commit |
|----|------|-------|--------|
| WR-01 | `scripts/benchmark.sh:103` | Non-portable `grep \s` | `acc4347` |
| WR-02 | `scripts/skill-discovery.sh:59` | jq dedup losing results | `2bab704` |
| WR-03 | `07-VERIFY.sh:297` | Hardcoded relative path | `84467c7` |
| WR-04 | `07-VERIFY.sh:196-203` | Missing jq fallback for D-09 | `09ccbf3` |
| WR-05 | `scripts/benchmark.sh:58` | Unused `content` variable | `ace7776` |
| WR-06 | `scripts/update-check.sh:38` | jq type error on missing key | `3a5d277` |
| IN-01 | `07-VERIFY.sh:131,241,261` | Dead grep on nonexistent files | `58a49ff` |
| IN-02 | `07-VERIFY.sh:121-126` | Redundant double-grep | `e7bfad3` |

## WR-01: `\s` to POSIX `[[:space:]]`

Replaced `grep "^${name}\s"` with `grep "^${name}[[:space:]]"` in benchmark.sh:103.

## WR-02: jq dedup pipeline

Added `flatten` before `unique_by` to handle array-of-arrays from multi-term `gh` searches. Normalized `gh` output to object-stream format matching curl output.

## WR-03: `$PHASE_DIR` path

Replaced hardcoded `.planning/phases/07-持续优化/scripts/update-check.sh` with `$PHASE_DIR/scripts/update-check.sh`.

## WR-04: D-09 grep fallback

Added `else` branch with grep-based fallback when `jq` is unavailable, consistent with D-14 pattern.

## WR-05: Dead variable

Removed unused `content` variable and updated stale comment.

## WR-06: jq null-safety

Changed `(.skill_states | .[$s]).last_known_sha` to `(.skill_states // {})[$s].last_known_sha` to handle missing `skill_states` key.

## IN-01: Dead grep lines

Removed 3 lines of dead `grep` calls in unreachable else branches.

## IN-02: Redundant double-grep

Consolidated 3 double-grep patterns into single `if/else` blocks.

---

_All 8 findings resolved. 0 skipped. 0 remaining._
