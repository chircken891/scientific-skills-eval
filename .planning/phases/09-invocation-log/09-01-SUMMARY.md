---
phase: 09-invocation-log
plan: 01
subsystem: gsd-runtime
tags: gsd-context-detect, json-output, state-parsing

requires:
  - phase: 08-gsd
    provides: gsd-context-detect.sh script with current_position parsing
provides:
  - current_plan field in gsd-context-detect.sh JSON output
affects:
  - 09-02: append-invocation-log.sh consumes current_plan for output routing
  - scientific-do Step 5: uses current_plan for SD-SUPPLEMENT.md routing

tech-stack:
  added: []
  patterns:
    - null normalization via explicit allowlist (em dash, hyphen, empty, none, tbd, "not started")
    - node -e for JSON-safe extraction (prevents injection from STATE.md content)

key-files:
  modified:
    - ~/.claude/scientific-skills/scripts/gsd-context-detect.sh

key-decisions:
  - "null normalization list: em dash (U+2014), hyphen, empty string, 'none', 'tbd', 'not started' — all 6 edge cases map to JSON null"
  - "Real plan IDs (matching any string not in null list) pass through as-is; no regex validation on format"
  - "current_plan is a top-level field (parallel to gsd_project, current_position), not nested"

requirements-completed:
  - GSD-02
  - GSD-03

duration: 22min
completed: 2026-05-13
---

# Phase 09 Plan 01: current_plan field in gsd-context-detect.sh Summary

**Add top-level `current_plan` field to gsd-context-detect.sh JSON output with null normalization for edge-case STATE.md values**

## Performance

- **Duration:** 22 min
- **Started:** 2026-05-13T03:21:00Z
- **Completed:** 2026-05-13T03:43:00Z
- **Tasks:** 2
- **Files modified:** 1 (external artifact at ~/.claude/scientific-skills/scripts/)

## Accomplishments

- Added `current_plan` extraction from `current_position.plan` with 6-value null normalization
- Added `ARG_CURRENT_PLAN` as 10th argument in OUTPUT_JSON node invocation block
- All 26 existing tests pass (0 failures) — existing fields and behavior fully preserved
- Non-GSD graceful degradation unchanged (no `current_plan` when gsd_project=false)

## Acceptance Criteria Verification

| Criterion | Result |
|-----------|--------|
| gsd-context-detect.sh has `current_plan` in top-level JSON output | PASS (value: "1 of 2" against actual project) |
| Null normalization: "not started", em dash, hyphen, empty, "none", "tbd" all produce null | PASS (6/6) |
| Real plan values pass through as strings | PASS ("09-01" -> "09-01") |
| Non-GSD graceful degradation: no current_plan field | PASS (gsd_project=false) |
| Script exits 0 for both GSD and non-GSD | PASS |
| All existing fields unchanged | PASS (existing test suite 26/26) |

## Task Commits

1. **Task 1: Add current_plan extraction and output** - `f97e47b` (feat)
2. **Task 2: Verify current_plan extraction end-to-end** - `8d773fa` (test)

**Plan metadata:** (commits above are the plan output)

## Files Modified

- `~/.claude/scientific-skills/scripts/gsd-context-detect.sh` (245 -> 260 lines)
  - Added CURRENT_PLAN extraction block after current_position parsing (4 insertion points total)

## Decisions Made

- **Null normalization list matches D-06 from CONTEXT.md:** em dash, hyphen, empty, none, tbd, "not started" all map to JSON null. Real plan values pass through unchanged.
- **Extraction placement:** CURRENT_PLAN is extracted immediately after CURRENT_POSITION is built (before ROADMAP.md parsing), available as `$CURRENT_PLAN` for the rest of the script.
- **All runtime script changes only:** No project git-tracked files were modified. The gsd-context-detect.sh is at `~/.claude/scientific-skills/scripts/` (scientific-skills runtime directory).

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

- **Node process.argv indexing verified:** On this platform (Node v24.14.0 on Windows), `node -e "code" arg1 arg2` has process.argv[0]=node_path, process.argv[1]=arg1 — the `-e` flag is NOT included in the argv array. The plan's use of process.argv[1] through process.argv[10] is correct.
- **Mock project testing required proper ROADMAP.md:** Minimal mock GSD projects fail with `set -euo pipefail` when ROADMAP.md lacks phase headers or progress table. This is pre-existing behavior unrelated to the current_plan changes.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- gsd-context-detect.sh now emits `current_plan` for plan 09-02 (append-invocation-log.sh)
- The SD-SUMMARY.md vs SD-SUPPLEMENT.md routing decision (D-04) can consume `current_plan` via the JSON output field

---
*Phase: 09-invocation-log*
*Plan: 01*
*Completed: 2026-05-13*
