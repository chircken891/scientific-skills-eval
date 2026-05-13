---
phase: 09-invocation-log
plan: 02
subsystem: scientific-do-invocation
tags:
  - invocation-log
  - GSD-output
  - concurrency-lock
  - scientific-do
requires:
  - 09-01 (gsd-context-detect.sh with current_plan field)
provides:
  - append-invocation-log.sh (invocation_log write pipeline)
  - test-append-invocation-log.sh (test harness)
  - SKILL.md Step 5 revision (invocation log integration)
affects:
  - feedback-state.json (adds invocation_log array)
  - scientific-do orchestration cycle (Step 5 counter logic replaced)
tech-stack:
  added:
    - bash 5.2 (script orchestration, mkdir lock)
    - node 24.14.0 (JSON serde, file I/O)
    - mkdir (concurrency lock)
  patterns:
    - mkdir-based concurrency lock with stale guard
    - node -e for all JSON processing (no jq, no string concat)
    - Counter sync with invocation_log.length (D-02)
    - Trigger output via stdout JSON (rating %10, update_check %20)
key-files:
  created:
    - ~/.claude/scientific-skills/scripts/append-invocation-log.sh (241 lines)
    - ~/.claude/scientific-skills/scripts/test-append-invocation-log.sh (360+ lines)
  modified:
    - ~/.claude/scientific-skills/skills/scientific-do/SKILL.md (Step 5 revision)
key-decisions:
  - Counter = invocation_log.length (D-02 literal, every invocation counts, no substantive-only filter)
  - Archive inline at write time (not phase-end batch)
  - Single archive file (invocation-log-archive.json, append mode)
  - Trigger flags passed via stdout JSON (rating at %10, update at %20)
  - Output file body: duration_ms, execution_summary, frontmatter (self-contained)
metrics:
  duration: ~20 minutes
  completed: 2026-05-13
  tasks: 3/3
  tests: 10/10 pass
---

# Phase 09 Plan 02: Invocation Log Write Pipeline and GSD Output

Created the `append-invocation-log.sh` helper script implementing the full invocation_log write pipeline with mkdir concurrency lock, D-01 schema enforcement, 200-entry trim with archive, counter sync, trigger detection, and GSD output routing (SD-SUMMARY.md / SD-SUPPLEMENT.md). Created a 10-test test harness (`test-append-invocation-log.sh`) covering all acceptance criteria. Updated SKILL.md Step 5 to remove old substantive-only counter logic and integrate the new invocation log pipeline.

## Task Summary

### Task 1: Create append-invocation-log.sh (241 lines)

Full write pipeline script at `~/.claude/scientific-skills/scripts/append-invocation-log.sh`.

**Key functions:**
- `acquire_lock()` — mkdir-based concurrency lock with stale guard (10s mtime threshold), 3 retries x 200ms
- `release_lock()` — clean up lock directory
- `write_gsd_output()` — conditional SD-SUMMARY.md / SD-SUPPLEMENT.md write with path validation

**Pipeline flow inside lock:**
1. Init state file if missing (default structure with empty invocation_log)
2. Single node -e read-modify-write: read state, build D-01 entry (9 fields), push to invocation_log, trim to 200, archive older entries to invocation-log-archive.json
3. Set counter = invocation_log.length (D-02)
4. Compute trigger flags: rating at counter % 10 == 0, update_check at counter % 20 == 0
5. Output trigger JSON to stdout
6. Call write_gsd_output for GSD projects
7. Release lock

**Security (threat model compliance):**
- T-09-01: All fields serialized via node -e JSON.stringify(), never shell string concatenation
- T-09-02: Stale lock guard removes orphan .lock dirs older than 10s
- T-09-03: Output path validated against GSD_PROJECT_ROOT/.planning/phases/ prefix
- T-09-04: Archive writes protected by same mkdir lock

### Task 2: Create test-append-invocation-log.sh (10 tests, all pass)

Test harness at `~/.claude/scientific-skills/scripts/test-append-invocation-log.sh`.

| Test | Description | Result |
|------|-------------|--------|
| test_init | No state file → creates default with empty invocation_log | PASS |
| test_append | 3 existing entries → appends 1, verifies 9 D-01 fields | PASS |
| test_lock | .lock dir exists → script fails gracefully (exit 1) | PASS |
| test_archive | 200 entries → trims to 200, archives 1 | PASS |
| test_counter | 5 entries → counter=6 after append | PASS |
| test_summary | GSD_PROJECT_ROOT set, no plan → SD-SUMMARY.md | PASS |
| test_supplement | GSD_PROJECT_ROOT set, plan=09-01 → SD-SUPPLEMENT.md | PASS |
| test_no_gsd_output | GSD_PROJECT_ROOT unset → no SD-*.md, log still written | PASS |
| test_triggers | Counter %10 → rating=true; %20 → rating+update=true | PASS |
| test_error_summary | status=failure stores error; success stores empty | PASS |

### Task 3: Update SKILL.md Step 5

Modified `~/.claude/scientific-skills/skills/scientific-do/SKILL.md` Step 5:
- Removed old "Usage Tracking (D-14, D-15)" subsection (substantive-only counter logic)
- Removed old "Counter trigger (every 10)" subsection (reset-to-0 logic)
- Inserted "Invocation Logging and GSD Output (D-01 through D-05, D-14)" section
- New section documents: duration_ms calculation, entry field building, append-invocation-log.sh call, trigger flag parsing and handling
- Verification Gates (GATE 1-4) and Gate Responses preserved unchanged
- Frontmatter and Integration section intact

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed missing closing parenthesis in command substitution**
- **Found during:** Task 1 smoke test
- **Issue:** `TRIGGER_JSON=$(node -e "..." ... || { ... })` was missing the closing `)` for the `$(` command substitution, causing "unexpected EOF" syntax error
- **Fix:** Added `)` after `}` to properly close the `$(` subshell
- **Files modified:** `append-invocation-log.sh`
- **Commit:** N/A (files outside git repo)

**2. [Rule 1 - Bug] Fixed "null" string vs JSON null normalization**
- **Found during:** Task 1 smoke test
- **Issue:** `"null"` in JavaScript used double quotes which conflicted with the outer double-quoted bash string, preventing the toNull normalization function from executing
- **Fix:** Changed JavaScript comparison to use single quotes: `val === 'null'`
- **Files modified:** `append-invocation-log.sh`

**3. [Rule 1 - Bug] Fixed phase directory resolution for leading-zero phase numbers**
- **Found during:** Task 1 GSD output test
- **Issue:** `printf "%02d" 09` treated input as octal (invalid), causing phase directory lookup to fail
- **Fix:** Changed to try original phase value first, then zero-padded after stripping leading zeros

**4. [Rule 1 - Bug] Fixed path validation for GSD output on Windows**
- **Found during:** Task 1 GSD output test
- **Issue:** `pwd -P` resolved paths differently than GSD_PROJECT_ROOT, causing false "path outside allowed directory" warnings
- **Fix:** Replaced `pwd -P` resolution with simple string prefix check after normalizing backslashes

**5. [Rule 2 - Missing] Added JSON encoding for write_gsd_output args**
- **Found during:** Task 1 SD-SUMMARY.md test
- **Issue:** Node -e in write_gsd_output received raw values (e.g., "09") causing JSON.parse to fail
- **Fix:** Wrapped args through JSON.stringify before passing to node -e (matching the pattern used in the main pipeline)
- **Files modified:** `append-invocation-log.sh`

## Test Results

```text
=== test-append-invocation-log.sh ===
[TEST] test_init ........ PASS
[TEST] test_append ...... PASS
[TEST] test_lock ........ PASS
[TEST] test_archive ..... PASS
[TEST] test_counter ..... PASS
[TEST] test_summary ..... PASS
[TEST] test_supplement .. PASS
[TEST] test_no_gsd_output PASS
[TEST] test_triggers .... PASS
[TEST] test_error_summary PASS
=== Results: 10 passed, 0 failed ===
```

## Self-Check

- [x] `append-invocation-log.sh` exists (241 lines, executable)
- [x] `test-append-invocation-log.sh` exists, all 10 tests pass
- [x] `SKILL.md` Step 5 references append-invocation-log.sh, no old substantive logic
- [x] Script creates default feedback-state.json if missing
- [x] Script appends D-01-compliant entries (9 fields)
- [x] Script uses mkdir lock with stale guard
- [x] Script trims to 200 and archives older entries
- [x] Script sets counter = invocation_log.length
- [x] Script outputs trigger flags (%10 rating, %20 update_check)
- [x] Script writes SD-SUMMARY.md / SD-SUPPLEMENT.md when GSD_PROJECT_ROOT set
- [x] Script skips GSD output when GSD_PROJECT_ROOT not set
- [x] Script validates output path prefix (T-09-03)
- [x] SKILL.md Verification Gates and Gate Responses preserved
