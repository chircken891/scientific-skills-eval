---
phase: 09-invocation-log
fixed_at: 2026-05-13T12:30:00Z
review_path: .planning/phases/09-invocation-log/09-REVIEW.md
iteration: 1
findings_in_scope: 8
fixed: 8
skipped: 0
status: all_fixed
---

# Phase 09: Code Review Fix Report

**Fixed at:** 2026-05-13T12:30:00Z
**Source review:** .planning/phases/09-invocation-log/09-REVIEW.md
**Iteration:** 1

**Summary:**
- Findings in scope: 8
- Fixed: 8
- Skipped: 0

## Fixed Issues

### CR-01: Path traversal via phase parameter in GSD output routing

**Files modified:** `scripts/append-invocation-log.sh`
**Commit:** 759fe08
**Applied fix:** Replaced string-prefix path validation with canonical path resolution using `cd "$(dirname "$output_file")" && pwd -P`. This resolves `..` traversal sequences before the prefix check, preventing `../evil` from writing outside `.planning/phases/`.

### CR-02: TOCTOU race condition in stale lock detection

**Files modified:** `scripts/append-invocation-log.sh`
**Commit:** 69b8082
**Applied fix:** Restructured `acquire_lock()` to attempt `mkdir` fast path first, then check stale lock mtime only if the fast path failed. Eliminates the window between stale check and removal where another process could create the lock. Added null guards on `$now` and `$lock_mtime` to prevent arithmetic errors.

### CR-03: Windows backslash path corruption in node -e heredoc strings

**Files modified:** `scripts/append-invocation-log.sh`
**Commit:** 3903eaf
**Applied fix:** Changed all filesystem path interpolations in `node -e` JavaScript strings to use `process.argv` argument passing instead of shell variable expansion. Covers `$STATE_FILE`, `$ARCHIVE_FILE`, and `$LOCK_DIR` references. The `json_str` function in `gsd-context-detect.sh` already used `process.argv`; no changes needed there. Test file paths via `$tmpdir` are already normalized to forward slashes by `make_tempdir`.

### WR-01: awk regex injection in extract_section

**Files modified:** `scripts/gsd-context-detect.sh`
**Commit:** 8fde28a
**Applied fix:** Replaced awk regex match operator (`$0 ~ "^## " h " "`) with literal string matching using `index()` and `length()` checks. This prevents regex special characters in the `$header` parameter from producing incorrect matches or awk errors.

### WR-02: Glob character injection in phase directory resolution

**Files modified:** `scripts/append-invocation-log.sh`
**Commit:** 2bc2abb
**Applied fix:** Replaced `ls -d "$GSD_PROJECT_ROOT/.planning/phases/${phase}-"*` with `find "$GSD_PROJECT_ROOT/.planning/phases" -maxdepth 1 -type d -name "${phase}-*"`, which prevents shell glob expansion of metacharacters in the `$phase` variable.

### WR-03: Empty catch blocks suppress all errors silently

**Files modified:** `scripts/append-invocation-log.sh`
**Commit:** bf78694
**Applied fix:** Added `console.error('[WARN] Failed to read archive: ' + e.message)` to the previously empty `catch(e) {}` block. The outer catch (archive write failure) already logged a warning.

### WR-04: Test suppresses all output masking failure diagnostics

**Files modified:** `scripts/test-append-invocation-log.sh`
**Commit:** b764878
**Applied fix:** Changed all test invocations from `> /dev/null 2>&1` to `> /dev/null`, preserving stderr visibility. Diagnostics (`[WARN]`, `[ERROR]`) from the append script are now visible during test runs instead of being silently discarded.

### WR-05: Fragile timestamp-counting assertion for log entry count

**Files modified:** `scripts/test-append-invocation-log.sh`
**Commit:** 3622902
**Applied fix:** Replaced two occurrences of `split('invocation_log')[1].split('timestamp').length-1` with `JSON.parse(...).invocation_log.length`, making entry count assertions robust against field values containing the substring "timestamp".

---

_Fixed: 2026-05-13T12:30:00Z_
_Fixer: Claude (gsd-code-fixer)_
_Iteration: 1_
