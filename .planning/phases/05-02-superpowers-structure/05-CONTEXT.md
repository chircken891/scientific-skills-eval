# Phase 5: 集成与验证 - Context

**Gathered:** 2026-05-12
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 5-02：创建scientific-skills集合包，包含7个核心skill（文献检索/数据分析/论文写作/图表生成/投稿润色/医学专项/开发助手）+ 扩展skill + scientific-do协调器。

</domain>

<decisions>
## Implementation Decisions

### 集合包结构
- **D-01:** 目录结构采用superpowers标准插件风格
- **D-02:** 包含 `.claude-plugin/`、`skills/`、`hooks/`、`CLAUDE.md`、`README.md`
- **D-03:** skills/下按功能分子目录（每个skill一个子目录）

### 触发条件设计
- **D-04:** 触发模式：精确匹配 + 模糊fallback
- **D-05:** 每个skill的description字段精确描述触发场景，未命中时fallback模糊匹配

### Skill依赖图
- **D-06:** 依赖模式：独立+顺序+中央协调
- **D-07:** 7个核心skill可独立使用，组合时自动按顺序执行
- **D-08:** **scientific-do** 作为中央协调器，负责路由决策和skill编排

### 能力边界
- **D-09:** HARD-GATE策略：关键节点HARD-GATE
- **D-10:** 关键阻断点：规划前必须研究、写作前必须设计、执行前必须确认
- **D-11:** 其他决策点由scientific-do协调器动态决定

### scientific-do 协调器
- **D-12:** 名称：scientific-do（功能类gsd-do，但独立命名）
- **D-13:** 职责：用户意图解析、skill路由、依赖链编排、冲突处理
- **D-14:** 默认按顺序执行，可跳过（当用户明确需求时）

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### 核心组合（Phase 4决策）
- `.planning/phases/04-最优组合生成/04-CONTEXT.md` — 核心方案（7个skill）+ 扩展方案
- `.planning/phases/04-最优组合生成/04-OPTIMAL-COMBINATION.md` — 完整组合方案

### Superpowers结构参考
- `.planning/phases/05-02-superpowers-structure/05-02-RESEARCH.md` — Superpowers插件结构、SKILL.md模板、触发机制研究

### 项目文档
- `.planning/ROADMAP.md` — Phase 5 五个子计划定义
- `.planning/PROJECT.md` — 项目目标与评测体系架构

</canonical_refs>

<codebase_context>
## 集合包规划

### 核心Skill（7个）
| 角色 | Skill | 用途 |
|------|-------|------|
| 文献检索 | deepxiv_sdk | 科研文献调研 |
| 数据分析 | scientific-agent-skills | 研究方法论 |
| 论文写作 | academic-writing-skills | 学术写作 |
| 图表生成 | paper-plot-skills | 数据可视化 |
| 投稿润色 | Paper-Polish-Workflow-skill | 论文润色 |
| 医学专项 | medsci-skills | 医学领域 |
| 开发助手 | everything-claude-code | Claude Code增强 |

### 扩展Skill（3个）
- nature-skills（Nature投稿）
- claude-scholar（引用管理）
- scientify（OpenClaw用户）

### 中央协调器
- **scientific-do**：协调7个核心skill + 3个扩展skill

</codebase_context>

<deferred>
## Deferred Ideas

- 扩展skill优先级：当核心skill和扩展skill都匹配时，如何决定？
- 跨领域触发：医学+统计场景，多个domain skill如何协调？

</deferred>

---

*Phase: 5-集成与验证*
*Context gathered: 2026-05-12*