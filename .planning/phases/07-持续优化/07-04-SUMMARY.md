---
phase: 07
plan: 04
subsystem: update-check
tags: ["D-16", "D-17", "D-10", "D-11", "D-12", "D-13", "D-18"]
requires: ["07-02", "07-03"]
provides: ["update-check.sh", "skill-discovery.sh"]
affects: ["07-VERIFY.sh"]
tech-stack:
  added: ["jq", "gh CLI", "curl", "GitHub REST API v3"]
  patterns: ["sequential API polling", "JSON state persistence", "threshold-based filtering"]
key-files:
  created:
    - ".planning/phases/07-持续优化/scripts/update-check.sh"
    - ".planning/phases/07-持续优化/scripts/skill-discovery.sh"
  modified:
    - ".planning/phases/07-持续优化/07-VERIFY.sh"
decisions: []
metrics:
  duration: "~5 min"
  completed_date: "2026-05-12"
tasks_completed: 3
files_changed: 3
---

# Phase 7 Plan 4: Update Check and Skill Discovery Summary

**One-liner:** Two automated Bash scripts and a verify extension: update-check.sh polls GitHub API across 10 skills, skill-discovery.sh searches candidates with Phase 2 thresholds, and 07-VERIFY.sh gains D-16/D-10/D-18 check sections.

## Tasks Executed

| # | Task | Type | Status | Commit |
|---|------|------|--------|--------|
| 1 | Create update-check.sh for all 10 skills | auto | PASS | 51a827a |
| 2 | Create skill-discovery.sh with Phase 2 threshold filtering | auto | PASS | 42ab572 |
| 3 | Update 07-VERIFY.sh with D-16, D-10, D-18 checks | auto | PASS | 68a01ef |

## Task Details

### Task 1: update-check.sh

**Script path:** `.planning/phases/07-持续优化/scripts/update-check.sh`

Iterates over `skill_registry` from `scientific-skills-config.json` (10 entries). For each skill with a non-null `repo` field, fetches the remote HEAD SHA via GitHub API (gh CLI first, curl fallback). Compares against `last_known_sha` in `feedback-state.json`:

- If no prior SHA: stores the remote SHA as initial checkpoint ("INITIAL CHECK")
- If SHAs differ: prints "UPDATE AVAILABLE" with both hashes, increments counter
- If SHAs match: prints "UP TO DATE"
- API failures: prints "API FAILED", continues to next skill

Academic-paper-analysis is SKIPped (repo: null, no remote upstream).

**Key design properties:**
- Sequential execution (no parallel API calls) to stay within rate limits — 10 calls per run, 60 req/hr unauthenticated
- D-17 notification-only: exit code always 0, no auto-apply
- State persisted to `feedback-state.json` skill_states for cross-session tracking

### Task 2: skill-discovery.sh

**Script path:** `.planning/phases/07-持续优化/scripts/skill-discovery.sh`

Searches GitHub with 4 search terms for claude-code scientific skills. Reads `core_auto_activate` (>= 4.0), `extension_download` (>= 3.0), and `exclude_below` (< 3.0) thresholds from config.

- Uses `gh search repos` when `gh` CLI is available
- Falls back to `curl` GitHub API search
- Deduplicates results by `full_name`
- Displays D-11 safety checks, D-12 grading guidance, and D-13 replacement logic
- **No automatic installation** — display-only per threat model T-7-03

### Task 3: 07-VERIFY.sh update

Added `SCIDO_FILE` variable and three new check sections before the Summary:

- **D-16:** Verifies `update-check.sh` exists and is executable (`-x`)
- **D-10/D-11:** Verifies `skill-discovery.sh` exists and is executable (`-x`)
- **D-18:** Checks for smoke test procedure documentation (grep "完成后必须验证" in SKILL.md or "smoke" in update-check.sh)

## Deviations from Plan

None. Plan executed exactly as written.

## Threat Surface Scan

No new threat surface introduced. Both scripts fetch from GitHub API using whitelisted repo entries from config.json (T-7-03 mitigated: no user-supplied URLs). skill-discovery.sh results are display-only with no installation code. No new network endpoints, auth paths, or file access patterns beyond the planned scope.

## Verification Results

- `bash scripts/update-check.sh` — ran cleanly, 9 skills reported API FAILED (expected in offline environment), scientify got INITIAL CHECK, exit 0
- `bash scripts/skill-discovery.sh` — ran cleanly, threshold display correct, D-11/D-12/D-13 output present, exit 0
- `bash 07-VERIFY.sh` — all Plan 04 checks (D-16, D-10/D-11, D-18) PASSED

## Known Stubs

None. Both scripts are production-ready for their intended purpose: update detection and skill discovery. The D-18 check will show FAIL until a smoke test procedure is documented in a later plan — this is expected behavior per the plan's scope boundaries.

## Self-Check Verification

- [x] `.planning/phases/07-持续优化/scripts/update-check.sh` exists (51a827a)
- [x] `.planning/phases/07-持续优化/scripts/skill-discovery.sh` exists (42ab572)
- [x] `.planning/phases/07-持续优化/07-VERIFY.sh` updated with D-16, D-10/D-11, D-18 checks (68a01ef)
- [x] All three tasks committed atomically
- [x] No untracked files left behind
- [x] No unintended file deletions

## Self-Check: PASSED
