---
phase: 08-gsd
plan: 01
subsystem: infrastructure
tags: ["gsd", "context-detection", "shell-script", "yaml-parsing", "json"]

requires: []
provides:
  - "GSD project context detection script (gsd-context-detect.sh) with upward traversal, STATE.md/ROADMAP.md/PROJECT.md/CLAUDE.md parsing, and structured JSON output"
  - "Cross-platform test harness (test-gsd-context-detect.sh) with 26 tests across detection, parsing, degradation, and output structure scenarios"
  - "Test fixtures (with-gsd and without-gsd) for all detection scenarios"
affects: ["08-gsd-02", "scientific-do"]

tech-stack:
  added:
    - "bash/awk/node-e for zero-dependency YAML frontmatter parsing"
    - "process.stdin streaming for cross-platform node pipe (no /dev/stdin dependency)"
    - "process.argv for safe JSON field passing from bash to node"
  patterns:
    - "awk '/^---/{c++;next} c==1{print}' | node -e for frontmatter extraction (D-06)"
    - "for/seq/dirname for bounded upward traversal (D-01)"
    - "JSON.stringify via process.argv for safe shell-to-node data transfer"

key-files:
  created:
    - "~/.claude/scientific-skills/scripts/gsd-context-detect.sh"
    - "~/.claude/scientific-skills/scripts/test-gsd-context-detect.sh"
    - "~/.claude/scientific-skills/scripts/fixtures/with-gsd/.planning/STATE.md"
    - "~/.claude/scientific-skills/scripts/fixtures/with-gsd/.planning/ROADMAP.md"
    - "~/.claude/scientific-skills/scripts/fixtures/with-gsd/.planning/PROJECT.md"
    - "~/.claude/scientific-skills/scripts/fixtures/with-gsd/CLAUDE.md"
    - "~/.claude/scientific-skills/scripts/fixtures/without-gsd/.gitkeep"
  modified: []

key-decisions:
  - "Used process.stdin streaming + process.argv instead of /dev/stdin for cross-platform Windows/Linux compatibility"
  - "Used process.argv for safe JSON field passing from bash to node (avoids shell injection via template interpolation)"

patterns-established:
  - "Cross-platform node -e pattern: process.stdin.setEncoding + on('data')/on('end') instead of require('fs').readFileSync('/dev/stdin')"
  - "Safe JSON assembly: pre-encode each field via json_str() helper, pass as process.argv args, parse with JSON.parse() in node"

requirements-completed:
  - GSD-01

duration: 8min
completed: 2026-05-13
---

# Phase 8 Plan 1: GSD Context Detection Script

**Zero-dependency shell script for GSD project context detection with upward traversal, YAML frontmatter parsing, and structured JSON output. Full test suite with 26 passing tests across detection, parsing, graceful degradation, and JSON structure scenarios.**

## Performance

- **Duration:** 8 min
- **Started:** 2026-05-13T01:29:00Z
- **Completed:** 2026-05-13T01:37:34Z
- **Tasks:** 3
- **Files modified:** 8

## Accomplishments

- Created `gsd-context-detect.sh` (248 lines) implementing all 10 locked decisions (D-01 through D-10): upward traversal (max 5 levels), STATE.md frontmatter with nested `progress` object parsing, ROADMAP.md phase list merging (collapsible + flat sections), PROJECT.md Core Value/Constraints extraction, CLAUDE.md inclusion (D-08), --quick flag, graceful degradation, and structured JSON stdout (D-10)
- Created `test-gsd-context-detect.sh` (293 lines) with helper functions (assert_eq, assert_contains, assert_json_field, run_test), dispatch for --smoke/--all/--test-*, and 26 passing tests covering detection, state parsing, roadmap parsing, graceful degradation, JSON output structure, env var extractability, and --quick flag behavior
- Created test fixture files: with-gsd (realistic STATE.md/ROADMAP.md/PROJECT.md/CLAUDE.md) and without-gsd (empty dir with .gitkeep)
- All 26 tests pass with `--all`, final 6-field JSON structure verification passes

## Task Commits

Each task was committed atomically in the scientific-skills repository:

1. **Task 1: Create test fixture files and test harness** - `88bb448` (feat)
2. **Task 2: Create gsd-context-detect.sh** - `ea6ea5a` (feat)
3. **Task 3: Run test suite** - `3a74cc8` (test)

**Plan metadata:** Pending (in main project repo)

## Files Created/Modified

All files are in `~/.claude/scientific-skills/scripts/` (scientific-skills repository):

- `scripts/gsd-context-detect.sh` - GSD project context detection and file parsing script
- `scripts/test-gsd-context-detect.sh` - Test harness with 26 tests across 7 scenarios
- `scripts/fixtures/with-gsd/.planning/STATE.md` - Test fixture: STATE.md with nested frontmatter + Current Position
- `scripts/fixtures/with-gsd/.planning/ROADMAP.md` - Test fixture: ROADMAP.md with collapsible + flat sections + Progress table
- `scripts/fixtures/with-gsd/.planning/PROJECT.md` - Test fixture: PROJECT.md with Core Value + Constraints
- `scripts/fixtures/with-gsd/CLAUDE.md` - Test fixture: project-level rules and conventions
- `scripts/fixtures/without-gsd/.gitkeep` - Test fixture: empty directory marker

## Decisions Made

- **Cross-platform stdin:** Used `process.stdin` streaming + `process.argv` instead of `/dev/stdin` for node -e patterns. On Windows (Git Bash/MSYS2), `/dev/stdin` does not exist, so all node -e pipes use the streaming approach (cross-platform).

- **Safe JSON assembly:** Pre-encode each output field via `json_str()` helper (uses `JSON.stringify(process.argv[1])`), then pass all fields as process.argv arguments to a single node -e invocation. This avoids shell injection via template interpolation (`$GSD_PROJECT_ROOT` in node -e double-quoted strings).

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Fixed null byte check for MSYS2/Git Bash compatibility**
- **Found during:** Task 2 (Creating gsd-context-detect.sh)
- **Issue:** The `[[ "$CWD" == *$'\0'* ]]` null byte detection pattern matches ALL strings on MSYS2/Git Bash because `$'\0'` expands to empty string in pattern context, turning `*$'\0'*` into `**` which matches everything. This caused the script to always exit early with `{"gsd_project":false,"error":"null byte in path"}`.
- **Fix:** Replaced with empty-path validation (`[ -z "$CWD" ]`). Null bytes cannot exist in bash variables (C string terminators), so the original check was a no-op on all POSIX systems. The empty-path check provides practical defense-in-depth for T-08-01.
- **Files modified:** scripts/gsd-context-detect.sh
- **Verification:** Script now correctly detects with-gsd fixture
- **Committed in:** ea6ea5a (Task 2 commit)

**2. [Rule 3 - Blocking] Fixed /dev/stdin not available on Windows**
- **Found during:** Task 2 (Creating gsd-context-detect.sh), Task 3 (Running tests)
- **Issue:** All node -e invocations used `require('fs').readFileSync('/dev/stdin','utf8')` which fails on Windows where `/dev/stdin` does not exist. Both gsd-context-detect.sh and test-gsd-context-detect.sh were affected.
- **Fix:** Rewrote all stdin-reading node -e patterns to use `process.stdin` streaming (`.on('data')`/`.on('end')` callbacks). For simple string values, switched to `process.argv` argument passing instead of piping.
- **Files modified:** scripts/gsd-context-detect.sh, scripts/test-gsd-context-detect.sh
- **Verification:** All 26 tests pass, JSON output correct on Windows
- **Committed in:** ea6ea5a (Task 2), 3a74cc8 (Task 3)

**3. [Rule 2 - Missing] Fixed json_field helper to support statement-type expressions**
- **Found during:** Task 3 (Running test suite)
- **Issue:** The `json_field` helper wrapped the field path in `const result = (expr); console.log(...)`, which fails for statement-type expressions like `const p8=obj.phases.find(...);console.log(...)`.
- **Fix:** Removed the auto-wrapping; `json_field` now passes raw JavaScript code through to node -e. Updated all callers to include explicit `console.log()` wrappers.
- **Files modified:** scripts/test-gsd-context-detect.sh
- **Verification:** Phase 8 name and GSD_CURRENT_PHASE tests now pass correctly
- **Committed in:** 3a74cc8 (Task 3)

---

**Total deviations:** 3 auto-fixed (2 blocking, 1 missing critical)
**Impact on plan:** All auto-fixes necessary for cross-platform correctness. No scope creep.

## Issues Encountered

- **MSYS2 $'\0' behavior:** On Git Bash for Windows, the bash `$'\0'` escape produces an empty string in pattern context, not a null byte. This is a known MSYS2 quirk. Workaround: use empty-path check instead of null-byte check.
- **Cross-platform node stdin:** Node.js on Windows does not expose `/dev/stdin`. All pipe-to-node patterns must use `process.stdin` streaming or `process.argv`.
- **Expression vs statement in node -e:** When passing dynamic JavaScript to node -e via bash, wrapping in `const result = (expr)` only works for expression-type code. Statement-type code (with `const`, `if`, etc.) needs to be passed directly.

## Stub Tracking

No stubs found. The gsd-context-detect.sh script performs real detection and parsing for all scenarios. Test fixtures are intentionally minimal for testing purposes.

## Threat Flags

None. No new security-relevant surface introduced beyond what the plan's threat model covers.

## Next Phase Readiness

- gsd-context-detect.sh is complete and tested for Phase 8 Plan 2 (scientific-do Step 1 integration)
- Test harness provides regression coverage for integration testing
- Cross-platform compatibility validated on Windows (Git Bash/MSYS2)

## Self-Check: PASSED

- All 8 created files verified present
- All 3 commits found in scientific-skills repo (88bb448, ea6ea5a, 3a74cc8)
- Full test suite: 26/26 passed
- Deferred: STATE.md and ROADMAP.md updates owned by orchestrator (not this plan)

---
*Phase: 08-gsd*
*Completed: 2026-05-13*
