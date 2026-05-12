# Phase 5 Plan 3: Scientific-Do Coordinator Summary

**Phase:** 5-集成与验证
**Plan:** 05-03
**Status:** Complete

## One-liner
Scientific-Do coordinator with intent parsing, skill routing, and dependency chain orchestration capabilities

## Context
Per D-16, D-17, D-18, D-19 design requirements from Phase 5-02 discussions.

## What Was Created

### Files Created (Outside Project Repo - User's ~/.claude)

| File | Path | Purpose |
|------|------|---------|
| SKILL.md | `~/.claude/scientific-skills/skills/scientific-do/SKILL.md` | Central coordinator definition |
| intent-parser.ts | `~/.claude/scientific-skills/skills/scientific-do/intent-parser.ts` | Intent parsing module |
| skill-router.ts | `~/.claude/scientific-skills/skills/scientific-do/skill-router.ts` | Skill routing module |

### SKILL.md Content
- Central coordinator for scientific-skills bundle
- Intent parsing: identify research stage, task type, domain keywords
- Skill routing: exact match -> fuzzy fallback -> smart tuning (Per D-17)
- Dependency chain orchestration: literature -> analysis -> writing -> figures -> polishing
- HARD-GATE nodes: research before planning, design before writing, confirm before execution
- Integrates 7 academic skills

### Intent Parser Module
- `Intent` interface: stage, taskType, domainKeywords, confidence
- `parseIntent()` function: extracts research intent from user input
- Supports Chinese and English keywords
- Calculates confidence based on word count and keyword presence

### Skill Router Module
- `RouteResult` interface: primarySkill, secondarySkills, executionOrder, confidence
- `routeSkill()` function: implements 3-tier routing (exact -> fuzzy -> smart tuning)
- `buildDependencyChain()` function: orchestrates skill execution order
- SKILL_MAP: mapping from task types to skill combinations

## Verification

```bash
ls -la ~/.claude/scientific-skills/skills/scientific-do/
# SKILL.md, intent-parser.ts, skill-router.ts all present
```

## Deviation from Plan
None - executed exactly as designed.

## Notes
- Files created in user's `~/.claude/scientific-skills/skills/scientific-do/` directory
- This directory is outside the project repository (D:/cc/项目/科研skill)
- Git commits were not made for files outside repo scope
- The bundle is ready for use in Claude Code environment

---
*Created: 2026-05-12*
*Plan: 05-03-Scientific-Do Coordinator*