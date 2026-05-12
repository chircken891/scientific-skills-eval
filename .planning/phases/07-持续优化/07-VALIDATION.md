---
phase: 7
slug: 持续优化
status: planned
nyquist_compliant: true
wave_0_complete: true
created: 2026-05-12
---

# Phase 7 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Manual verification + Bash assertions |
| **Config file** | `07-VERIFY.sh` (Wave 0) |
| **Quick run command** | `bash .planning/phases/07-持续优化/07-VERIFY.sh` |
| **Full suite command** | `bash .planning/phases/07-持续优化/07-VERIFY.sh` |
| **Estimated runtime** | ~180 seconds |

---

## Sampling Rate

- **After every task commit:** Execute modified skill's basic functionality (e.g., if editing deepxiv_sdk SKILL.md, run `grep -q 'triggers:'` to verify)
- **After every plan wave:** Run full 07-VERIFY.sh
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 120 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 07-01-01 | 01 | 0 | D-07 | — | N/A | automated | `bash .planning/phases/07-持续优化/07-VERIFY.sh > /dev/null 2>&1; echo $?` | ✅ W0 | ⬜ pending |
| 07-01-02 | 01 | 0 | D-07 | — | N/A | automated | `bash .planning/phases/07-持续优化/scripts/benchmark.sh 2>&1 | grep -q 'Parse time'` | ✅ W0 | ⬜ pending |
| 07-02-01 | 02 | 1 | D-03 | — | N/A | file check | `C=0; for f in ~/.claude/scientific-skills/skills/*/SKILL.md; do grep -q 'triggers:' "$f" && ((C++)); done; echo "$C/8"` | ✅ W0 | ⬜ pending |
| 07-02-02 | 02 | 1 | D-03 | — | N/A | file check | same loop for `exclude_when:` | ✅ W0 | ⬜ pending |
| 07-02-03 | 02 | 1 | D-06 | — | N/A | file check | same loop for `model:` | ✅ W0 | ⬜ pending |
| 07-02-04 | 02 | 1 | D-14 | T-7-01 | No injection via comment field | file check | `jq '.counter' ~/.claude/scientific-skills/feedback-state.json` | ✅ W0 | ⬜ pending |
| 07-03-01 | 03 | 2 | D-04 | T-7-02 | Input not parsed as code | file check | `grep -q 'Proactive Intent Parsing' ~/.claude/scientific-skills/skills/scientific-do/SKILL.md` | ✅ W0 | ⬜ pending |
| 07-03-02 | 03 | 2 | D-05 | — | N/A | file check | `grep -q '5. Post-Action Verification' ~/.claude/scientific-skills/skills/scientific-do/SKILL.md` | ✅ W0 | ⬜ pending |
| 07-03-03 | 03 | 2 | D-19 | T-7-04 | Only activate pre-vetted skills | file check | `grep -q 'Extension pool check' ~/.claude/scientific-skills/skills/scientific-do/SKILL.md` | ✅ W0 | ⬜ pending |
| 07-03-04 | 03 | 2 | D-14/D-15 | T-7-01 | Comment sanitized before JSON write | file check | `grep -q 'Usage Tracking (D-14, D-15)' ~/.claude/scientific-skills/skills/scientific-do/SKILL.md` | ✅ W0 | ⬜ pending |
| 07-04-01 | 04 | 2 | D-16 | T-7-03 | Validate repo owner/name before API call | file check | `test -x .planning/phases/07-持续优化/scripts/update-check.sh` | ✅ W0 | ⬜ pending |
| 07-04-02 | 04 | 2 | D-17 | — | N/A | file check | `grep -q 'no auto-update\|human confirmation' .planning/phases/07-持续优化/scripts/update-check.sh` | ✅ W0 | ⬜ pending |
| 07-04-03 | 04 | 2 | D-11/D-12 | T-7-03 | Phase 2 thresholds enforced | file check | `grep -q 'DepthScore' .planning/phases/07-持续优化/scripts/skill-discovery.sh` | ✅ W0 | ⬜ pending |
| 07-05-01 | 05 | 3 | D-09 | — | N/A | file check | `grep -q 'Gap Detection (D-09)' ~/.claude/scientific-skills/skills/scientific-do/SKILL.md` | ✅ W0 | ⬜ pending |
| 07-05-02 | 05 | 3 | D-07 | — | N/A | automated | `test -f .planning/phases/07-持续优化/benchmark-results.tsv && grep -q 'deepxiv_sdk' benchmark-results.tsv` | ✅ W0 | ⬜ pending |
| 07-05-03 | 05 | 3 | D-18 | — | N/A | checkpoint | User confirms smoke test procedure documented | ✅ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [x] `.planning/phases/07-持续优化/07-VERIFY.sh` — verification script for all D-xx items
- [x] `.planning/phases/07-持续优化/scripts/benchmark.sh` — performance benchmark script for P6-E01
- [x] `.planning/phases/07-持续优化/scripts/update-check.sh` — update check for all 10 skills
- [x] `.planning/phases/07-持续优化/scripts/skill-discovery.sh` — GitHub search + Phase 2 filtering

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Gap detection UX | D-09 | Requires user interaction (confirm discovery) | Submit unmatched query; verify gap notification + discovery offer |
| Feedback prompt appearance | D-15 | Interactive prompt cannot be automated | Counter logic triggered in scientific-do Step 5 after 10 orchestrations |
| Update notification display | D-17 | Interactive notification requires visual verification | Force SHA mismatch; confirm notification is display-only (no auto-update) |
| Smoke test after update | D-18 | Requires multi-skill execution across 7 skills | Run each core skill with a representative query |
| Extension activation | D-19 | Requires context-specific routing trigger | Submit Nature-journal-specific query; verify extension pool check |

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references
- [x] No watch-mode flags
- [x] Feedback latency < 120s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
