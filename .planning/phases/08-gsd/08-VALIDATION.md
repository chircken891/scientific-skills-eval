---
phase: 08
slug: gsd
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-05-13
---

# Phase 08 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | bash script smoke tests + `node -e` inline assertions |
| **Config file** | none — test as `scripts/test-gsd-context-detect.sh` |
| **Quick run command** | `bash scripts/test-gsd-context-detect.sh --smoke` |
| **Full suite command** | `bash scripts/test-gsd-context-detect.sh --all` |
| **Estimated runtime** | ~5 seconds |

---

## Sampling Rate

- **After every task commit:** Run `bash scripts/test-gsd-context-detect.sh --smoke`
- **After every plan wave:** Run `bash scripts/test-gsd-context-detect.sh --all`
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 5 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 08-TBD | TBD | 1 | GSD-01 | T-08-01 | Path traversal bounded to 5 levels, command injection prevented via JSON stringify | smoke | `bash scripts/test-gsd-context-detect.sh --smoke` | ❌ W0 | ⬜ pending |
| 08-TBD | TBD | 1 | GSD-01 | — | Parses STATE.md frontmatter correctly | unit | `bash scripts/test-gsd-context-detect.sh --test-state-parsing` | ❌ W0 | ⬜ pending |
| 08-TBD | TBD | 1 | GSD-01 | — | Parses ROADMAP.md phase list correctly | unit | `bash scripts/test-gsd-context-detect.sh --test-roadmap-parsing` | ❌ W0 | ⬜ pending |
| 08-TBD | TBD | 1 | GSD-01 | — | Returns empty JSON when no .planning/ found | smoke | `bash scripts/test-gsd-context-detect.sh --test-no-gsd` | ❌ W0 | ⬜ pending |
| 08-TBD | TBD | 1 | GSD-01 | — | JSON output contains all required fields | integration | `bash scripts/test-gsd-context-detect.sh --test-json-output` | ❌ W0 | ⬜ pending |
| 08-TBD | TBD | 1 | GSD-01 | — | JSON output maps correctly to env vars via scientific-do | integration | `bash scripts/test-gsd-context-detect.sh --test-env-vars` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `scripts/test-gsd-context-detect.sh` — test harness for gsd-context-detect.sh
- [ ] Test fixture files: sample STATE.md, ROADMAP.md, PROJECT.md, CLAUDE.md in a temp `.planning/` dir
- [ ] Test fixture: a directory tree without `.planning/` for the graceful degradation test

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| scientific-do routes correctly with GSD context in actual Claude Code session | GSD-01 | Requires live Claude Code environment with GSD project | Run `scientific-do "search papers"` from GSD project dir, verify confidence boost applied |

---

## Threat Model

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Path traversal via `$1` | Tampering | Bound traversal to max 5 levels, use `dirname` (not string manipulation), reject paths with null bytes |
| Command injection via file content | Tampering | Use `node -e` with JSON stringification for file content output; never eval or source file content |
| Accidental `.planning/` in home dir | Information Disclosure | Depth limit prevents walking into unrelated dirs; 5 levels is intentional constraint (D-01) |

---

## Validation Sign-Off

- [ ] All tasks have automated verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 5s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
