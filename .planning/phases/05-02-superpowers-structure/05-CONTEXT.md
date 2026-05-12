# Phase 5: 集成与验证 - Context

**Gathered:** 2026-05-12
**Updated:** 2026-05-12 (补充讨论05-03/05-04/05-05)
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 5：实际集成到Claude Code环境，包含5个子计划：
- 05-01：安装核心Skill（10个）
- 05-02：创建集合包（scientific-skills）
- 05-03：功能测试指南（7个skill完整测试套件）
- 05-04：工作流测试（端到端）
- 05-05：验证报告+SUMMARY

</domain>

<decisions>
## Implementation Decisions

### Phase 5-02 集合包结构（已讨论）
- **D-01:** superpowers标准插件风格
- **D-02:** 触发模式：精确匹配 + 模糊fallback
- **D-03:** 依赖模式：独立+顺序+中央协调
- **D-04:** **scientific-do** 作为中央协调器
- **D-05:** 关键节点HARD-GATE（规划前必须研究、写作前必须设计、执行前必须确认）

### Phase 5-03 功能测试指南
- **D-06:** 测试覆盖范围：完整测试套件（冒烟测试 + 边界情况 + 异常处理）
- **D-07:** 测试用例格式：混合模式（手动测试文档 + 自动化验证脚本）
- **D-08:** 测试通过标准：100%通过

### Phase 5-04 工作流测试
- **D-09:** 端到端测试场景：完整场景测试 + 科研流程测试
- **D-10:** 工作流编排测试重点：全部（scientific-do协调 + 数据传递 + 冲突处理）

### Phase 5-05 验证报告
- **D-11:** 报告格式：Markdown报告
- **D-12:** 报告内容：执行摘要 + 测试结果汇总 + 问题与解决 + 验收确认

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase 5-02 集合包结构
- `.planning/phases/05-02-superpowers-structure/05-CONTEXT.md` — 集合包设计决策
- `.planning/phases/05-02-superpowers-structure/05-02-RESEARCH.md` — Superpowers结构研究

### 核心组合（Phase 4决策）
- `.planning/phases/04-最优组合生成/04-CONTEXT.md` — 核心方案（7个skill）+ 扩展方案
- `.planning/phases/04-最优组合生成/04-OPTIMAL-COMBINATION.md` — 完整组合方案

### 项目文档
- `.planning/ROADMAP.md` — Phase 5 五个子计划定义
- `.planning/PROJECT.md` — 项目目标与评测体系架构

</canonical_refs>

<codebase_context>
## Phase 5 完整规划

### 子计划清单
| Plan | 内容 | 状态 |
|------|------|------|
| 05-01 | 安装核心Skill（10个） | 待开始 |
| 05-02 | 创建集合包（scientific-skills） | 已讨论 |
| 05-03 | 功能测试指南（7个skill） | 已讨论 |
| 05-04 | 工作流测试（端到端） | 已讨论 |
| 05-05 | 验证报告+SUMMARY | 已讨论 |

### 7个核心Skill
deepxiv_sdk, scientific-agent-skills, academic-writing-skills, paper-plot-skills, Paper-Polish-Workflow-skill, medsci-skills, everything-claude-code

### 测试要求
- 完整测试套件：冒烟测试 + 边界情况 + 异常处理
- 100%通过标准
- 端到端场景：完整场景 + 科研流程

</codebase_context>

<deferred>
## Deferred Ideas

- 扩展skill优先级：当核心skill和扩展skill都匹配时，如何决定？
- 跨领域触发：医学+统计场景，多个domain skill如何协调？

</deferred>

---

*Phase: 5-集成与验证*
*Context gathered: 2026-05-12*
*Updated: 2026-05-12 (补充讨论05-03/05-04/05-05)*