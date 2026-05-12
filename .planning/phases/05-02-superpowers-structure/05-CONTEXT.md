# Phase 5: 集成与验证 - Context

**Gathered:** 2026-05-12
**Updated:** 2026-05-12 (补充讨论05-03/05-04/05-05)
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 5：实际集成到Claude Code环境，包含6个子计划：
- 05-01：安装核心Skill
- 05-02：创建集合包（scientific-skills）
- 05-03：制作scientific-do协调器
- 05-04：功能测试指南
- 05-05：工作流测试（端到端）
- 05-06：验证报告+SUMMARY

</domain>

<decisions>
## Implementation Decisions

### Phase 5-01 安装核心Skill
- **D-20:** 检测7个学术skill，已安装则移动/配置到集合，未安装则安装
- **D-21:** everything-claude-code独立于集合，外部引用（地位等同于gsd、superpowers）
- **D-22:** 3个扩展skill预下载不激活（nature-skills, claude-scholar, scientify）

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

### 替换方案处理
- **D-13:** 核心方案装好，替换方案预下载不激活
- **D-14:** 用户切换方式：scientific-do智能推荐
- **D-15:** 冲突处理：由scientific-do协调器决策

### Phase 5-03 scientific-do协调器
- **D-16:** 核心功能：意图解析 + skill路由 + 依赖链编排 + 冲突处理
- **D-17:** 触发优先级逻辑：智能调优（精确匹配 + 模糊fallback + 智能调优）
- **D-18:** 冲突处理：综合决策（上下文 + 用户偏好 + 历史使用习惯）
- **D-19:** 状态管理：全局状态（所有skill可读写）

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
| 05-01 | 检测核心Skill，已安装则移动/配置到集合，未安装则安装 | 已讨论 |
| 05-02 | 创建集合包（scientific-skills，不含scientific-do） | 已讨论 |
| 05-03 | 制作scientific-do协调器 | 已讨论 |
| 05-04 | 功能测试指南（6个学术skill） | 已讨论 |
| 05-05 | 工作流测试（端到端） | 已讨论 |
| 05-06 | 验证报告+SUMMARY | 已讨论 |

### 学术skill（7个，安装到集合）
deepxiv_sdk, academic-paper-analysis, scientific-agent-skills, academic-writing-skills, paper-plot-skills, Paper-Polish-Workflow-skill, medsci-skills

### 外部引用skill（独立安装）
everything-claude-code（等同于gsd、superpowers）

### 扩展skill（预下载不激活）
| 角色 | 核心方案 | 替换方案 |
|------|---------|---------|
| 图表生成 | paper-plot-skills | nature-skills |
| 投稿润色 | Paper-Polish-Workflow-skill | nature-skills |
| 引用管理 | — | claude-scholar |
| OpenClaw用户 | — | scientify |

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