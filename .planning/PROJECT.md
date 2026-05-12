# 科研Skill/Plugin 评测与集成

## What This Is

一个系统化的评测与整合流程：从海量科研相关 skill/plugin 中筛选出最优组合（7个核心 + 3个扩展），集成到 Claude Code 形成 `scientific-skills` 系列，通过 `scientific-do` 协调器实现意图驱动的自动路由。覆盖流行病学、生物统计学、肿瘤学等领域，配备完整验证、更新检测和反馈收集基础设施。

## Core Value

科学工作流的自动化编排 — 意图检测 → 技能路由 → 执行 → 反馈闭环。

## Requirements

### Validated

- ✓ 建立评测体系（两阶段架构：安全否决 + 专业深度评分） — v1.0
- ✓ 收集/搜索科研方向 skill/plugin（共39个仓库） — v1.0
- ✓ 对每个 skill 进行独立评测（21个完整评测） — v1.0
- ✓ 生成最优组合方案（7核心 + 3扩展） — v1.0
- ✓ 完成集成（scientific-do 协调器 + 8 SKILL.md 注册） — v1.0
- ✓ 持续优化基础设施（验证脚本、更新检测、反馈收集、性能基准） — v1.0

### Active

- [ ] everything-claude-code 域识别路由集成（deferred — see STATE.md）

### Out of Scope

- 不做 skill/plugin 开发（除非现有方案都不满足）
- 不评价学术论文内容本身
- everything-claude-code 完全集成（v1.0 仅限科研域）

## Context

- **Shipped:** v1.0 — 9 phases, 26 plans, ~26K LOC (scripts + docs + YAML)
- **Tech stack:** Claude Code skills (YAML + Markdown), Bash scripts, JSON configs
- **Delivered:** scientific-skills bundle (7 core + 3 extension skills), scientific-do coordinator, 07-VERIFY.sh (315 lines, 16 D-xx checks), benchmark/update/discovery scripts
- **Known deferred:** VS Code marketplace search (tools unavailable), everything-claude-code routing (Phase 7.1 candidate)

## Constraints

- **安全**：数据安全、权限范围、网络请求、依赖来源 — 任一项不合格直接否决
- **流程**：先评后安装，Claude 主导执行
- **命名**：暂不自主命名，最后提醒用户

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| 安全一票否决 | 科研数据敏感，不可妥协 | ✓ Good — 0 否决项通过 |
| 主动搜索补充 | 不限于用户发来的 | ✓ Good — 39个仓库 → 21个评测 |
| 两阶段评估架构 | 专业深度驱动决策，非全能加权 | ✓ Good — D-06/D-07/D-08/D-09 验证通过 |
| 最后集成 | 先评后装 | ✓ Good — Phase 5 安装7核+3扩展 |
| D-xx 决策体系 | 21个可验证决策项 | ✓ Good — 16/16 自动化验证通过 |
| Structured Registration | triggers/model/exclude_when 注册 | ✓ Good — 8 SKILL.md v2 格式 |
| scientific-do 协调器 | 意图解析 + 路由 + 验证 + 反馈 | ✓ Good — 5步流程，4个 HARD-GATE |

---

*Last updated: 2026-05-12 after v1.0 milestone*
