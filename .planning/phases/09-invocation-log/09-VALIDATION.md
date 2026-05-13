---
phase: 09
slug: invocation-log
status: draft
nyquist_compliant: true
wave_0_complete: false
created: 2026-05-13
---

# Phase 09 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | bash script smoke tests + `node -e` inline assertions |
| **Config file** | none — test as `scripts/test-append-invocation-log.sh` |
| **Quick run command** | `bash scripts/test-append-invocation-log.sh --smoke` |
| **Full suite command** | `bash scripts/test-append-invocation-log.sh --all` |
| **Estimated runtime** | ~5 seconds |

---

## Sampling Rate

- **After every task commit:** Run `bash scripts/test-append-invocation-log.sh --smoke`
- **After every plan wave:** Run `bash scripts/test-append-invocation-log.sh --all`
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 5 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 09-01-01 | 01 | 1 | GSD-02 | — | JSON output includes current_plan field | unit | `bash scripts/test-append-invocation-log.sh --test-current-plan` | ❌ W0 | ⬜ pending |
| 09-02-01 | 02 | 2 | GSD-02 | T-09-01 | mkdir lock prevents concurrent write | unit | `bash scripts/test-append-invocation-log.sh --test-lock` | ❌ W0 | ⬜ pending |
| 09-02-01 | 02 | 2 | GSD-02 | T-09-02 | node -e JSON stringify prevents injection | unit | `bash scripts/test-append-invocation-log.sh --test-injection` | ❌ W0 | ⬜ pending |
| 09-02-01 | 02 | 2 | GSD-02 | — | Archive rotates at 200 entries | unit | `bash scripts/test-append-invocation-log.sh --test-archive` | ❌ W0 | ⬜ pending |
| 09-02-01 | 02 | 2 | GSD-03 | — | SD-SUMMARY.md written when GSD detected | integration | `bash scripts/test-append-invocation-log.sh --test-output-gsd` | ❌ W0 | ⬜ pending |
| 09-02-01 | 02 | 2 | GSD-03 | — | No output file in non-GSD mode | integration | `bash scripts/test-append-invocation-log.sh --test-output-no-gsd` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `scripts/test-append-invocation-log.sh` — test harness for append-invocation-log.sh
- [ ] Test fixture: temp feedback-state.json with mock invocation_log array
- [ ] Test fixture: temp .planning/ directory for GSD output tests

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Feedback rating popup appears after 10th invocation | GSD-02 | Requires live Claude Code session | Run scientific-do 10 times, verify rating prompt appears |
| Update check fires after 20th invocation | GSD-02 | Requires live GitHub API access | Run scientific-do 20 times, verify update check triggers |

---

## Threat Model

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Concurrent write via mkdir lock | Tampering | mkdir atomicity + 3 retries × 200ms |
| Command injection via JSON values | Tampering | node -e JSON.stringify for all values; never eval or source |
| Archive file unbounded growth | Denial of Service | 200-entry cap with rotation; old entries go to archive |

---

## Validation Sign-Off

- [ ] All tasks have automated verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 5s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
