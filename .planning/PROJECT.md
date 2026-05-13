# 科研Skill/Plugin 评测与集成

## What This Is

一个系统化的评测与整合流程：从海量科研相关 skill/plugin 中筛选出最优组合（7个核心 + 3个扩展），集成到 Claude Code 形成 `scientific-skills` 系列，通过 `scientific-do` 协调器实现意图驱动的自动路由。覆盖流行病学、生物统计学、肿瘤学等领域，配备完整验证、更新检测和反馈收集基础设施。

## Core Value

科学工作流的自动化编排 — 意图检测 → 技能路由 → 执行 → 反馈闭环。

## Current Milestone: v1.1 GSD-scientific 集成协议

**Goal:** scientific-do 与 GSD 项目框架深度互操作，实现结构化调用记录与执行追踪。

**Target features:**
1. GSD 项目上下文感知 — 检测 `.planning/` 目录，读取 phase/plan/requirement
2. 调用日志系统 — invocation_log 扩展，每次调用记录时间、意图、路由、产出
3. GSD 合规输出 — 产出写入对应 phase 目录，支持 SUMMARY.md / SUPPLEMENT.md 格式

## Requirements

### Validated

- ✓ 建立评测体系（两阶段架构：安全否决 + 专业深度评分） — v1.0
- ✓ 收集/搜索科研方向 skill/plugin（共39个仓库） — v1.0
- ✓ 对每个 skill 进行独立评测（21个完整评测） — v1.0
- ✓ 生成最优组合方案（7核心 + 3扩展） — v1.0
- ✓ 完成集成（scientific-do 协调器 + 8 SKILL.md 注册） — v1.0
- ✓ 持续优化基础设施（验证脚本、更新检测、反馈收集、性能基准） — v1.0

### Active

- [ ] **GSD-01**: GSD 项目上下文感知 — scientific-do 检测 `.planning/` 并读取 phase/plan 状态
- [ ] **GSD-02**: 调用日志系统 — invocation_log 结构化记录每次执行
- [ ] **GSD-03**: GSD 合规输出 — 执行结果写入 phase 目录的 SUMMARY.md 或 SUPPLEMENT.md
- [ ] everything-claude-code 域识别路由集成（deferred — see STATE.md）

### Out of Scope

- 不做 skill/plugin 开发（除非现有方案都不满足）
- 不评价学术论文内容本身
- everything-claude-code 完全集成（v1.0 仅限科研域）
- 论文润色实战（留给后续 milestone）

## Context

- **Shipped:** v1.0 — 10 phases, 26 plans
- **Tech stack:** Claude Code skills (YAML + Markdown), Bash scripts, JSON configs
- **Delivered:** scientific-skills bundle (7 core + 3 extension), scientific-do coordinator, verification/benchmark/update/discovery infrastructure

## Constraints

- **安全**：数据安全、权限范围、网络请求、依赖来源 — 任一项不合格直接否决
- **流程**：先评后安装，Claude 主导执行

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| 安全一票否决 | 科研数据敏感，不可妥协 | ✓ Good — v1.0 |
| 两阶段评估架构 | 专业深度驱动决策 | ✓ Good — v1.0 |
| D-xx 决策体系 | 21个可验证决策项 | ✓ Good — v1.0 |
| GSD 做外层调度 | 不重复造轮子，scientific-do 做执行引擎 | — Pending |

---

*Last updated: 2026-05-12 after v1.0 milestone*
