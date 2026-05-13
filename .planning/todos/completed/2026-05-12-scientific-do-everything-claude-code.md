---
created: 2026-05-12T07:05:29.707Z
title: scientific-do集成everything-claude-code域识别路由
area: planning
resolves_phase: "7"
files:
  - "~/.claude/scientific-skills/skills/scientific-do/intent-parser.ts"
  - "~/.claude/scientific-skills/skills/scientific-do/skill-router.ts"
  - "~/.claude/scientific-skills/skills/scientific-do/SKILL.md"
  - "~/.claude/skills/everything-claude-code/"
---

## Problem

Phase 6审计发现：everything-claude-code（33个Claude Code技能，通用开发增强）已安装并正常工作，但scientific-do完全不感知它的存在。当前scientific-do的SKILL_MAP只有7个科研skill，对非科研请求（如"写API"、"安全审计"）无路由能力。

D-21决策将everything-claude-code定位为独立外部工具（等同于gsd/superpowers），但未定义两者的交互边界。

## Solution

轻量域识别路由方案（Phase 7.1）：

1. **intent-parser.ts**: Intent接口增加`domain?: 'scientific' | 'engineering' | 'general'`字段，新增`detectDomain()`函数
2. **skill-router.ts**: 增加`FALLBACK_GUIDE`常量，非scientific域导向everything-claude-code
3. **SKILL.md**: 增加能力边界说明和交叉引用

不动现有7-skill路由逻辑，不维护everything-claude-code的完整路由表。

详细计划见：`C:\Users\Administrator.DESKTOP-BD1JUD0\.claude\plans\sharded-weaving-narwhal.md`
