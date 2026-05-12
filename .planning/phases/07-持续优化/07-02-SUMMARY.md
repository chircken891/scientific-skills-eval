---
phase: 07
plan: 02
subsystem: scientific-skills
tags: [skilling, frontmatter, config, feedback]
requires:
  - 07-01 (verification scripts)
provides:
  - 7 core SKILL.md files with triggers + model + exclude_when frontmatter
  - scientific-do SKILL.md with coordinator triggers frontmatter
  - feedback-state.json (D-14 counter file)
  - scientific-skills-config.json (central config with model_map, skill_registry, thresholds)
affects:
  - scientific-do routing logic (reads triggers and model fields)
  - scripts/update-check.sh (reads repo URLs from config)
  - feedback collection flow (reads/writes feedback-state.json)
tech-stack:
  added:
    - "YAML frontmatter schema v2 with triggers: keywords/scenarios/exclude_when"
    - "JSON config with model_map + skill_registry + thresholds"
  patterns:
    - "Structured skill registration per D-03"
    - "Model preference declaration per D-06"
    - "Feedback counter initialization per D-14"
key-files:
  created:
    - "~/.claude/scientific-skills/feedback-state.json"
    - "~/.claude/scientific-skills/scientific-skills-config.json"
  modified:
    - "~/.claude/scientific-skills/skills/deepxiv_sdk/SKILL.md"
    - "~/.claude/scientific-skills/skills/academic-paper-analysis/SKILL.md"
    - "~/.claude/scientific-skills/skills/scientific-agent-skills/SKILL.md"
    - "~/.claude/scientific-skills/skills/academic-writing-skills/SKILL.md"
    - "~/.claude/scientific-skills/skills/paper-plot-skills/SKILL.md"
    - "~/.claude/scientific-skills/skills/Paper-Polish-Workflow-skill/SKILL.md"
    - "~/.claude/scientific-skills/skills/medsci-skills/SKILL.md"
    - "~/.claude/scientific-skills/skills/scientific-do/SKILL.md"
decisions:
  - "D-03: 8/8 SKILL.md files have triggers frontmatter (keywords + scenarios + exclude_when)"
  - "D-06: 8/8 SKILL.md files have model: claude-sonnet-4-20250514"
  - "D-14: feedback-state.json created with counter=0, skill_states for 10 skills"
  - "academic-paper-analysis has repo: null (local skill, not from GitHub)"
  - "scientify uses tsingyuai/scientify as GitHub org"
metrics:
  duration: ~15m
  completed: 2026-05-12
---

# Phase 7 Plan 2: Structured Skill Registration Frontmatter + Config Files

Added structured trigger registration fields (triggers, exclude_when, model) to all 8 SKILL.md files and created the central config JSON files (feedback-state.json and scientific-skills-config.json), fulfilling D-03 (trigger schema), D-06 (model declaration), and D-14 (feedback counter initialization).

## Task Summary

| # | Name | Commit | Files |
|---|------|--------|-------|
| 1 | Add triggers + model + exclude_when frontmatter to 7 core skills | dc71863 | 7 SKILL.md files modified, +123 lines |
| 2 | Add triggers + model + exclude_when frontmatter to scientific-do | 20b3af5 | scientific-do/SKILL.md created (was untracked), +80 lines |
| 3 | Create feedback-state.json and scientific-skills-config.json | 5845647 | 2 JSON files created, +49 lines |

## Deviations from Plan

None -- plan executed exactly as written.

## Known Stubs

None -- all 8 SKILL.md files have complete trigger data, config files have all required fields populated (no placeholder/null values except intentional `repo: null` for academic-paper-analysis). Counter starts at 0 as designed.

## Threat Surface Scan

No new network endpoints, auth paths, or schema changes at trust boundaries introduced beyond what the plan specified. The `repo` field values in skill_registry are hardcoded strings (not user input), consistent with T-7-03 mitigation (Spoofing) requiring non-user-controlled repo URLs. The `feedback-state.json` file accepts structured data only (no user comment input at this stage) -- T-7-01 (Tampering via comment injection) is not applicable until the feedback prompt logic reads user input in a later plan.

## Verification Results

| Check | Result |
|-------|--------|
| D-03: triggers in 8/8 SKILL.md | PASS |
| D-03: exclude_when in 8/8 SKILL.md | PASS |
| D-06: model in 8/8 SKILL.md | PASS |
| D-14: feedback-state.json has counter=0 | PASS |
| D-14: feedback-state.json has skill_states (10 entries) | PASS |
| Config: model_map has 8 entries | PASS |
| Config: skill_registry has 10 entries | PASS |
| Config: academic-paper-analysis repo=null | PASS |
| Config: thresholds present | PASS |

Expected FAILs (belong to later plans 07-03/07-04/07-05): D-05, D-19, D-16, D-10/D-11

## Key Decisions

1. **Model value**: All 8 skills use `claude-sonnet-4-20250514` as the model identifier, matching the settings.json ANTHROPIC_DEFAULT_SONNET_MODEL.
2. **academic-paper-analysis repo**: Set to `null` because this is a local skill not sourced from GitHub -- update-check.sh will skip it.
3. **Threshold values**: core_auto_activate=4.0, extension_download=3.0, exclude_below=3.0 — matching D-12 discovery thresholds.
4. **scientify GitHub org**: `tsingyuai/scientify` per RESEARCH.md resolution.

## Commits

- `dc71863`: feat(07-02): add triggers + model + exclude_when frontmatter to 7 core skills
- `20b3af5`: feat(07-02): add triggers + model + exclude_when frontmatter to scientific-do
- `5845647`: feat(07-02): create feedback-state.json and scientific-skills-config.json

## Self-Check: PASSED

- [x] 8/8 SKILL.md files have triggers, model, exclude_when, version: 2 frontmatter
- [x] feedback-state.json valid JSON with counter=0, skill_states with 10 entries
- [x] scientific-skills-config.json valid JSON with model_map (8 entries), skill_registry (10 entries), thresholds
- [x] All 3 commits exist in scientific-skills git log
