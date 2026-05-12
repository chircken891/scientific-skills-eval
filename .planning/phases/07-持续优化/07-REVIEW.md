---
phase: 07-continuous-optimization
reviewed: 2026-05-12T18:50:00Z
depth: standard
files_reviewed: 15
files_reviewed_list:
  - .planning/phases/07-持续优化/07-VERIFY.sh
  - .planning/phases/07-持续优化/scripts/benchmark.sh
  - .planning/phases/07-持续优化/scripts/update-check.sh
  - .planning/phases/07-持续优化/scripts/skill-discovery.sh
  - ~/.claude/scientific-skills/feedback-state.json
  - ~/.claude/scientific-skills/scientific-skills-config.json
  - ~/.claude/scientific-skills/CLAUDE.md
  - ~/.claude/scientific-skills/skills/deepxiv_sdk/SKILL.md
  - ~/.claude/scientific-skills/skills/academic-paper-analysis/SKILL.md
  - ~/.claude/scientific-skills/skills/scientific-agent-skills/SKILL.md
  - ~/.claude/scientific-skills/skills/academic-writing-skills/SKILL.md
  - ~/.claude/scientific-skills/skills/paper-plot-skills/SKILL.md
  - ~/.claude/scientific-skills/skills/Paper-Polish-Workflow-skill/SKILL.md
  - ~/.claude/scientific-skills/skills/medsci-skills/SKILL.md
  - ~/.claude/scientific-skills/skills/scientific-do/SKILL.md
findings:
  critical: 0
  warning: 6
  info: 2
  total: 8
status: issues_found
---

# Phase 7: Code Review Report

**Reviewed:** 2026-05-12T18:50:00Z
**Depth:** standard
**Files Reviewed:** 15
**Status:** issues_found

## Summary

Reviewed 4 shell scripts, 2 JSON configuration files, 1 CLAUDE.md bundle descriptor, and 8 SKILL.md skill definitions. All SKILL.md files have valid YAML frontmatter with consistent required fields (triggers.keywords, triggers.scenarios, exclude_when, model). JSON files are valid. Shell scripts contain real bugs: a non-portable grep pattern that silently drops all benchmark TSV results (WARNING-01), a broken JSON deduplication pipeline that discards most search results (WARNING-02), a relative path that breaks when the script is run outside the repo root (WARNING-03), missing fallback error handling in a verification check (WARNING-04), an unused variable suggesting incomplete code (WARNING-05), and missing defensive jq error handling that causes a hard crash (WARNING-06). No security vulnerabilities or critical data loss risks were found.

## Warnings

### WR-01: grep pattern `\s` silently drops all benchmark TSV results

**File:** `D:\cc\项目\科研skill\.planning\phases\07-持续优化\scripts\benchmark.sh:103`
**Issue:** The pattern `\s` in `grep "^${name}\s"` is a GNU grep extension. On POSIX-only environments (BSD/macOS grep), `\s` matches the literal backslash-s character, which never appears in the TSV output (line 78 uses a literal tab character between fields). Result: `tsv_line` is always empty, every skill's row is silently dropped from the summary table, and `benchmark-results-*.tsv` contains only headers with no data rows. No error is raised.
**Fix:**

```bash
# Use a POSIX character class instead:
tsv_line=$(echo "$row" | grep "^${name}[[:space:]]")

# Or simpler: the skill name uniquely identifies the row as the first field:
tsv_line=$(echo "$row" | grep "^${name}")
```

---

### WR-02: Deduplication silently drops results from all but the first search term

**File:** `D:\cc\项目\科研skill\.planning\phases\07-持续优化\scripts\skill-discovery.sh:59`
**Issue:** When `gh` CLI is used (line 43), `gh search repos --json ...` returns a JSON **array**. After 4 search terms, `ALL_RESULTS` contains 4 JSON arrays concatenated with newlines. `jq -s` slurps them into `[[r1,r2], [r3], [r4], [r5]]`. Then `unique_by(.full_name)` evaluates `.full_name` on each top-level element: since each element is an array (not an object), `.full_name` is `null` for all 4. `unique_by` keeps only the first element with each key, meaning only the first search term's results survive. 3 out of 4 search terms' results are silently discarded.
**Fix:** Flatten the array of arrays before deduplication:

```bash
echo "$ALL_RESULTS" | jq -s 'add | unique_by(.full_name) | .[] | ...
```

Also normalize `gh` output to match curl's object-stream format for consistent accumulation:

```bash
# Line 44, normalize gh output:
RESULTS=$(gh search repos "$term" --limit 10 --json name,owner,description,url 2>/dev/null \
  | jq -c '.[] | {name, full_name: .fullName, description, html_url: .url}' 2>/dev/null || echo "[]")
```

---

### WR-03: Relative path breaks when script runs outside repo root

**File:** `D:\cc\项目\科研skill\.planning\phases\07-持续优化\07-VERIFY.sh:297`
**Issue:** The second grep in the D-18 check uses a hardcoded relative path `.planning/phases/07-持续优化/scripts/update-check.sh` while all other paths in the script use either `$PHASE_DIR` (absolute, resolved from `dirname $0`) or `$HOME`-rooted paths. Running `bash /absolute/path/to/07-VERIFY.sh` from any directory other than the repo root causes this grep to fail silently (stderr hidden by `2>/dev/null`). D-18 still passes because the first grep condition succeeds, but the check is incomplete. Additionally, `update-check.sh` does not contain the word "smoke", so this grep condition can never pass regardless.
**Fix:**

```bash
# Line 297: use $PHASE_DIR consistently
if grep -q "完成后必须验证" "$SCIDO_FILE" 2>/dev/null || grep -q "smoke" "$PHASE_DIR/scripts/update-check.sh" 2>/dev/null; then
```

---

### WR-04: D-09 gaps array check silently skips when jq is unavailable

**File:** `D:\cc\项目\科研skill\.planning\phases\07-持续优化\07-VERIFY.sh:196-203`
**Issue:** D-14's JSON validation (line 93-108) provides a `grep` fallback when `jq` is not installed. D-09's gaps array validation (lines 196-203) has no `else` branch for the `jq` availability check -- it silently skips the entire validation without any PASS/FAIL output when `jq` is missing. Cross-check result inconsistency: D-09 might falsely appear clean when `jq` is absent.
**Fix:** Add a grep fallback consistent with the D-14 pattern:

```bash
if command -v jq &>/dev/null; then
  if jq -e '.gaps | type == "array"' "$FEEDBACK_FILE" > /dev/null 2>&1; then
    echo -e "  D-09 PASS: ... $PASS"
  else
    echo -e "  D-09 FAIL: ... $FAIL"
    ALL_PASS=false
  fi
else
  if grep -q '"gaps"' "$FEEDBACK_FILE" 2>/dev/null; then
    echo -e "  D-09 PASS: feedback-state.json has gaps field $PASS"
  else
    echo -e "  D-09 FAIL: feedback-state.json missing gaps field $FAIL"
    ALL_PASS=false
  fi
fi
```

---

### WR-05: Unused variable `content` in benchmark function

**File:** `D:\cc\项目\科研skill\.planning\phases\07-持续优化\scripts\benchmark.sh:58`
**Issue:** The variable `content` is assigned the output of `head -20 "$skill_dir/SKILL.md"` but is never referenced afterward. This suggests incomplete implementation or dead code.
**Fix:** Remove the unused assignment. If the intent is to warm the disk cache or separate timing stages, discard output explicitly:

```bash
head -20 "$skill_dir/SKILL.md" > /dev/null 2>&1
```

---

### WR-06: jq type error crashes update-check when feedback-state.json is malformed

**File:** `D:\cc\项目\科研skill\.planning\phases\07-持续优化\scripts\update-check.sh:38`
**Issue:** The jq filter `(.skill_states | .[$s]).last_known_sha // ""` errors with "Cannot index null with string" (exit code 5) if the `skill_states` key is missing from `feedback-state.json`. With `set -e` active (line 15), this causes the script to exit immediately, skipping checks for all remaining skills. The `// ""` fallback only handles a null result, not a type error from indexing a missing key. The API calls (lines 43-47) correctly use `|| echo ""` to handle failure, but this line does not.
**Fix:** Add null-safety on the root of the traversal:

```bash
# Guard against missing skill_states key
LAST_SHA=$(jq -r --arg s "$skill_name" '(.skill_states // {})[$s].last_known_sha // ""' "$STATE_FILE")

# Or use try/catch:
LAST_SHA=$(jq -r --arg s "$skill_name" 'try (.skill_states[$s].last_known_sha) // ""' "$STATE_FILE")
```

---

## Info

### IN-01: Dead code grep on nonexistent file

**File:** `D:\cc\项目\科研skill\.planning\phases\07-持续优化\07-VERIFY.sh:131` (also lines 241, 261)
**Issue:** In the `else` branch where the script has already confirmed the file does not exist (`[ -f "$FILE" ]` returned false), a `grep -q 'nofile' "$FILE"` call is made. Its output is discarded (`2>/dev/null`), its exit code is never checked. The grep has zero effect on script behavior. Same pattern repeats for `$UPDATE_SCRIPT` (line 241) and `$DISCOVERY_SCRIPT` (line 261).

**Fix:** Remove lines 131, 241, and 261. They are unreachable in any meaningful sense and serve no functional purpose.

---

### IN-02: Redundant grep double-read in verification checks

**File:** `D:\cc\项目\科研skill\.planning\phases\07-持续优化\07-VERIFY.sh:121-126` (and lines 234-238, 253-257)
**Issue:** The same grep on the same file with the same pattern runs twice: first in a `&&`/`||` chain for output (line 121-123), then again in an `if` statement to set `ALL_PASS=false` (lines 124-126). The second grep could be replaced by checking the stored result of the first, or the structure could be consolidated into a single `if`/`else`.

**Fix:**

```bash
if grep -q 'bench_skill\|Benchmarking\|Parse time\|Route time' "$BENCH_SCRIPT" 2>/dev/null; then
    echo -e "  D-07 PASS: ... $PASS"
else
    echo -e "  D-07 FAIL: ... $FAIL"
    ALL_PASS=false
fi
```

---

_Reviewed: 2026-05-12T18:50:00Z_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
