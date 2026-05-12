# Phase 5: 集成与验证 - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-12
**Phase:** 5-02-superpowers-structure
**Areas discussed:** 集合包结构, 触发条件设计, Skill依赖图, 能力边界定义

---

## 集合包结构

| Option | Description | Selected |
|--------|-------------|----------|
| 标准插件结构 | hooks/ + skills/ + CLAUDE.md + README.md | |
| 扁平结构 | 所有skills在同一目录，不用子目录 | |
| 分层结构 | 按workflow分目录（research/planning/execute） | |
| superpowers风格 | superpowers的结构，hooks/ + skills/ + CLAUDE.md | ✓ |

**User's choice:** superpowers风格
**Notes:** 按最优的来，类似于superpowers和gsd

---

## 触发条件设计

| Option | Description | Selected |
|--------|-------------|----------|
| 场景精确匹配 | 每个skill的description精确描述触发场景 | |
| 模糊匹配 | 模糊匹配 + 优先级排序 | |
| 精确+模糊fallback | 精确优先，但精确没命中时fallback模糊 | ✓ |

**User's choice:** 精确+模糊fallback

---

## Skill依赖图

| Option | Description | Selected |
|--------|-------------|----------|
| 单向线性依赖 | research → planning → discuss → execute | |
| 星形（中央协调） | 有一个中央协调器决定调用哪个skill | |
| 链+独立混合 | 每个skill既可独立使用，又可组合成链 | |

**User's choice:** 独立+顺序+中央协调
**Notes:** 用户澄清：星形模式有一个中央协调器，所有skill围绕它。用户想要独立+顺序+中央协调三种模式结合。

---

## 能力边界

| Option | Description | Selected |
|--------|-------------|----------|
| 关键节点HARD-GATE | 规划前必须研究、写作前必须设计、执行前必须确认 | ✓ |
| 全量HARD-GATE | 所有决策点都加阻断 | |
| 仅关键HARD-GATE | 只在必要时阻断，其他由协调器决定 | |

**User's choice:** 关键节点HARD-GATE

---

## 中央协调器

| Option | Description | Selected |
|--------|-------------|----------|
| scientific-router | 科研助手路由，协调科研工作流 | |
| scientific-navigator | 科研导航，根据任务类型导向正确skill | |
| scientific-workflow | 科研工作流编排，协调各skill | |
| scientific-orchestrator | 科研编排器，协调多个skill执行 | |
| scientific-do | 功能类似gsd-do | ✓ |

**User's choice:** scientific-do
**Notes:** 不要叫gsd-do这个名字，只是功能相同

---

## Deferred Ideas

- 扩展skill优先级：当核心skill和扩展skill都匹配时，如何决定？
- 跨领域触发：医学+统计场景，多个domain skill如何协调？