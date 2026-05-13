---
phase: 09-invocation-log
reviewed: 2026-05-13T12:00:00Z
depth: standard
files_reviewed: 4
files_reviewed_list:
  - C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\gsd-context-detect.sh
  - C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\append-invocation-log.sh
  - C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\test-append-invocation-log.sh
  - C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\skills\scientific-do\SKILL.md
findings:
  critical: 3
  warning: 5
  info: 4
  total: 12
status: issues_found
---

# Phase 09: Code Review Report

**Reviewed:** 2026-05-13T12:00:00Z
**Depth:** standard
**Files Reviewed:** 4
**Status:** issues_found

## Summary

Reviewed the GSD invocation log subsystem: context detection script, invocation log appender, test harness, and skill definition. Three critical findings: a path traversal vulnerability in the phase-to-directory resolution, a TOCTOU race condition in the mkdir-based lock, and Windows backslash path corruption in node -e heredoc arguments. Several warnings around error suppression and fragile test patterns.

---

## Critical Issues

### CR-01: Path traversal via phase parameter in GSD output routing

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\append-invocation-log.sh:93-104`
**Issue:** The `phase` positional argument is used directly in path construction without sanitizing directory traversal sequences (`..`). The path prefix validation at lines 114-126 only checks for a string prefix match without resolving the path first. A phase value like `../evil` produces:

1. Line 93: glob `$GSD_PROJECT_ROOT/.planning/phases/../evil-*` resolves to `$GSD_PROJECT_ROOT/.planning/evil-*`
2. Line 102 (fallback): `phase_dir="$GSD_PROJECT_ROOT/.planning/phases/../evil"` sets `phase_dir` to `$GSD_PROJECT_ROOT/.planning/evil`
3. The prefix check on line 118 matches `$GSD_PROJECT_ROOT/.planning/phases/` as a string prefix, but the path still contains `..` and writes to a parent directory.

An attacker controlling the `phase` argument can write an `SD-SUMMARY.md` or `SD-SUPPLEMENT.md` file to any directory one level above `.planning/phases/`, such as `.planning/` itself or other phase directories.
**Fix:** Resolve the path to its canonical form before performing the prefix check. Add the following after line 112:

```bash
  # Resolve to canonical path to block directory traversal
  output_norm=$(cd "$(dirname "$output_file")" 2>/dev/null && pwd -P)/$(basename "$output_file")
  output_norm="${output_norm//\\//}"
  prefix_norm="${GSD_PROJECT_ROOT//\\//}/.planning/phases/"
  # Strip trailing slash for prefix matching
  case "$output_norm" in
    ${prefix_norm}*)
      ;;
    *)
      echo "[WARN] Output path outside allowed directory: $output_file" >&2
      return 0
      ;;
  esac
```

### CR-02: TOCTOU race condition in stale lock detection

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\append-invocation-log.sh:50-51`
**Issue:** The stale lock guard has a time-of-check-time-of-use window between checking the lock directory mtime (line 50) and removing it (line 51). If two processes race:

1. Process A checks: lock mtime is 15s old (>10), lock is stale. Proceeds to remove.
2. Process B creates lock (mkdir succeeds). Now holds the lock.
3. Process A runs `rm -rf "$LOCK_DIR"` -- removes Process B's lock.
4. Process A runs `mkdir "$LOCK_DIR"` -- succeeds.
5. Process B's retry loop runs `mkdir` -- also succeeds (since A's mkdir replaced it).

Both processes now believe they hold the lock exclusively. This defeats the concurrency guarantee.
**Fix:** Use an atomic stale-lock replacement strategy. The only reliable way with mkdir is to attempt mkdir first, then check mtime of the lock you _did not create_:

```bash
acquire_lock() {
  # Try fast path first
  if mkdir "$LOCK_DIR" 2>/dev/null; then
    return 0
  fi

  # Check for stale lock
  if [ -d "$LOCK_DIR" ]; then
    local now lock_mtime
    now=$(date +%s 2>/dev/null)
    lock_mtime=$(stat -c %Y "$LOCK_DIR" 2>/dev/null)
    if [ -n "$now" ] && [ -n "$lock_mtime" ] && [ $((now - lock_mtime)) -gt 10 ] 2>/dev/null; then
      rm -rf "$LOCK_DIR" 2>/dev/null || true
      # Attempt to acquire after removal
      mkdir "$LOCK_DIR" 2>/dev/null && return 0
    fi
  fi

  # Retry with backoff
  for i in $(seq 2 $RETRIES); do
    sleep $RETRY_DELAY
    if mkdir "$LOCK_DIR" 2>/dev/null; then
      return 0
    fi
  done
  echo "[WARN] Could not acquire lock after $RETRIES retries" >&2
  return 1
}
```

### CR-03: Windows backslash path corruption in node -e heredoc strings

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\append-invocation-log.sh:173,204,216`
**Issue:** Shell variables containing filesystem paths (e.g., `$STATE_FILE`, `$LOCK_DIR`, `$ARCHIVE_FILE`, `$FEEDBACK_DIR`) are expanded directly into double-quoted `node -e` JavaScript strings. On Windows, paths like `C:\Users\Admin\file.json` contain backslashes that JavaScript interprets as escape sequences. For example, `\U` in `C:\Users` is an invalid escape that, in non-strict mode, silently drops the backslash, producing `C:UsersAdmin\file.json` (corrupted path). This causes all file operations to fail silently.

The same pattern exists in `gsd-context-detect.sh` lines 44-49 (lock_mtime fallback) and the test file `test-append-invocation-log.sh` at lines 49-51, 86-90, 135, 164, 174, 211, 228, 232, 236, 264-265, 335, 402, 413, 424 (all `$tmpdir` expansions in node -e strings).
**Fix:** Never interpolate shell paths directly into JS string literals. Use `process.argv` to pass paths as arguments:

```bash
# Before (corrupted on Windows):
node -e "
  const state = JSON.parse(fs.readFileSync('$STATE_FILE', 'utf8'));
  ...
"

# After (safe):
node -e "
  const state = JSON.parse(fs.readFileSync(process.argv[1], 'utf8'));
  ...
" "$STATE_FILE"
```

Apply this pattern to all `node -e` invocations that reference shell variables containing path values.

---

## Warnings

### WR-01: awk regex injection via header parameter

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\gsd-context-detect.sh:115`
**Issue:** The `extract_section` function passes the `$2` header argument directly into awk's `~` regex operator via `-v h="$header"`. If `header` contains regex special characters (`.`, `*`, `[`, `]`, `\`, `+`, `^`, `$`), the pattern match produces incorrect results or crashes awk. Currently only called with static strings (`"Current Position"`, etc.), but the function is public API and could be called with dynamic values.
**Fix:** Use `awk index()` for literal string matching instead of regex, or escape the header string:

```awk
awk -v h="$header" 'BEGIN{found=0} index($0, \"## \" h) == 1 || index($0, \"## \" h \" \") == 1 {found=1; next} /^## /{found=0} found{print}'
```

Or escape the header in the shell call:
```bash
escape_awk_regex() { sed 's/[][\.*^$+?{}|()]/\\&/g' <<< "$1"; }
HEADER_ESC=$(escape_awk_regex "$header")
```

### WR-02: Glob character injection in phase directory resolution

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\append-invocation-log.sh:93,97`
**Issue:** The `phase` variable is used in a glob pattern with the `*` wildcard outside quotes: `ls -d "$GSD_PROJECT_ROOT/.planning/phases/${phase}-"*`. If `$phase` contains glob metacharacters (`*`, `?`, `[`), they are expanded by the shell before `ls` sees them. A phase value of `?` lists all single-character-prefix directories under `phases/`. Additionally, if zero directories match the pattern, bash's `failglob` or `nullglob` options could cause the `ls` to error, though the `2>/dev/null` mitigates the error message.
**Fix:** Use `find` with `-maxdepth 1 -name` pattern, or disable glob expansion for this operation:

```bash
# Safer approach using find with literal prefix matching:
set -f  # disable glob
phase_dir=$(find "$GSD_PROJECT_ROOT/.planning/phases" -maxdepth 1 -type d -name "${phase}-*" 2>/dev/null | head -1)
set +f  # re-enable glob
```

### WR-03: Empty catch blocks suppress all errors silently

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\append-invocation-log.sh:204,208`
**Issue:** Line 204 `catch(e) {}` and line 208 `catch(e) { console.error(...) }` both handle archive read/write errors. The read error on line 204 is completely silent — if the archive file exists but has corrupt JSON (e.g., truncated write from a crash), the error is swallowed and the data is silently lost. The archive already has the `try { archive = ... } catch(e) {}` pattern on line 204 where even the fallback `[]` from the `var archive = []` line 203 may not be properly scoped to the outer variable (though `var` is function-scoped, so it is fine in this specific case). The deeper issue is silent data loss.
**Fix:** Log a warning at minimum:

```javascript
try { archive = JSON.parse(fs.readFileSync('$ARCHIVE_FILE', 'utf8')); } catch(e) {
  console.error('[WARN] Failed to read archive: ' + e.message);
}
```

### WR-04: Test suppresses all output masking failure diagnostics

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\test-append-invocation-log.sh:124`
**Issue:** All test invocations of `APPEND_SCRIPT` use `> /dev/null 2>&1`, which hides both stdout (the trigger JSON) and stderr (error/warning messages). If the script fails, the only signal is the exit code. Test failures are hard to diagnose because diagnostic messages (`[WARN]`, `[ERROR]`) never reach the test runner output.
**Fix:** Redirect stderr separately to capture diagnostics, or only suppress stdout:

```bash
# Capture stderr for diagnosis on failure:
FEEDBACK_DIR="$tmpdir" bash "$APPEND_SCRIPT" ... > /tmp/test-output-$$.json 2>/tmp/test-err-$$.txt || {
  echo "  STDERR: $(cat /tmp/test-err-$$.txt)"
  ...
}
```

### WR-05: Fragile timestamp-counting assertion for log entry count

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\test-append-invocation-log.sh:143`
**Issue:** The test counts log entries by splitting on the string `"invocation_log"` and counting `"timestamp"` occurrences. This is fragile — any field value or key that contains the substring `"timestamp"` would produce a false count. A more robust approach would parse the JSON and read `invocation_log.length` directly, as done in other tests (e.g., lines 228, 265).
**Fix:** Replace with a direct JSON length query consistent with the rest of the test file:

```bash
assert_eq "log has 1 entry" "1" "$(node -e "console.log(JSON.parse(require('fs').readFileSync('$tmpdir/feedback-state.json','utf8')).invocation_log.length)")"
```

---

## Info

### IN-01: pipe_json API injects raw JavaScript via shell argument

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\gsd-context-detect.sh:124-131`
**Issue:** The `pipe_json` function's `$1` argument is raw JavaScript code interpolated directly into a `node -e` string via `(function() { $1 })()`. All current call sites pass static strings, so this is not exploitable today. But the API design is dangerous — if any caller ever passes user-controllable content (e.g., parsed from a file), it becomes arbitrary code execution. Consider passing the transformation logic as a separate script file or restricting the API to built-in transformation names only.

### IN-02: GSD output `duration_ms` path not JSON-escaped

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\append-invocation-log.sh:154`
**Issue:** The `$duration_ms` argument and `$output_file` path are passed directly to node without JSON escaping, unlike all other arguments (lines 148-153). While `duration_ms` is numeric and `output_file` is constructed from `$GSD_PROJECT_ROOT` + known suffixes, this is an inconsistency that breaks the pattern. If `$GSD_PROJECT_ROOT` ever contains backslashes or special characters, `process.argv[8]` would receive raw text without JSON encoding.

### IN-03: gsd-context-detect.sh -- args 7-10 may pass raw JSON when caller expects string

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\gsd-context-detect.sh:222-229`
**Issue:** `ARG_STATE` (line 222) is set from `$STATE_FRONTMATTER` which is already JSON (output of `extract_frontmatter`). This is passed as `process.argv[3]` and parsed with `JSON.parse()` — correct. But `ARG_CURRENT_POSITION` (line 223) is also pre-encoded JSON, then serialized via `json_str`... no, wait, it's NOT passed through `json_str` — it's assigned directly: `ARG_CURRENT_POSITION="$CURRENT_POSITION"`. Then on line 238 it's parsed with `JSON.parse(process.argv[4])`. This is correct because `$CURRENT_POSITION` is already JSON. But the inconsistent use of `json_str` for some args (lines 220, 221, 226, 227, 228) and direct assignment for others (lines 222, 223, 224, 225, 229) is confusing and error-prone — a future maintainer might accidentally wrap a pre-encoded JSON string in `json_str`, double-encoding it.

### IN-04: test-append-invocation-log.sh -- temp dir is never cleaned up on early exit

**File:** `C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\scientific-skills\scripts\test-append-invocation-log.sh:27-29`
**Issue:** The `cleanup` function is a no-op (`:`). Each `rm -rf "$tmpdir"` is done manually in each test, but only on failure paths. If a test exits early due to `return 1` in a nested assertion, the cleanup relies on the explicit `rm -rf` before each `return 1`. The `trap cleanup EXIT` on line 440 does nothing since `cleanup` is empty. If a test crashes (e.g., SIGTERM), temp directories leak. This is a test quality issue, not a production bug.

---

## SKILL.md Technical Accuracy Check

The SKILL.md accurately reflects the script APIs:

- GSD context detection calls match the script signature (`--quick` flag, `<cwd>` argument). Matches.
- Append script positional parameters match 1:1 with the script's `$1`-`$8`. Matches.
- Trigger flag JSON structure `{rating, update_check}` matches script output. Matches.
- Phase-to-role mapping is documentation of the orchestrator's logic, not a script concern. No discrepancy.
- Gap detection recording in `feedback-state.json` `gaps` array is an orchestrator-side operation; the append script does not write to the `gaps` field but also does not overwrite it (the entire state object is read-modify-written). Correct.

One minor documentation gap: the SKILL.md says `error_summary` is "only when status != success", but the append script always accepts it as `$4` regardless of status. The orchestrator documents the intended behavior correctly — the script itself is unopinionated.

---

_Reviewed: 2026-05-13T12:00:00Z_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
