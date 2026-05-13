# Retrospective

## Milestone: v1.0 — 科研Skill评测与集成

**Shipped:** 2026-05-12
**Phases:** 10 | **Plans:** 26 | **Timeline:** 2026-05-11 to 2026-05-12 (2 days)

### What Was Built

从零到完整科研skill生态：评测体系 → 仓库发现 → 安全筛选 → 组合分析 → 集成协调器 → 测试验证 → 持续优化基础设施。最终交付 scientific-skills 集合包、scientific-do 5-step 协调器、更新/发现/基准全套脚本。

### What Worked

- **Phase 级原子规划** — 每 phase 有明确目标、可验证的 must_haves、独立的 CONTEXT.md，下游 agent 不需要理解全貌就能执行
- **安全一票否决制** — 4 项硬检查独立于评分，在 Phase 2 早期就建立了清晰边界
- **专业深度取代全能评分** — Phase 01.5.1 的关键调整：不因为"不全能"惩罚专业化 skill，产出更有意义的排序
- **Git history 作为归档** — v1.0 phase 文件虽被清理，但 git show 随时能恢复任意决策

### What Was Inefficient

- **Milestone 关闭执行偏差** — complete-milestone 的 evolve_project_full_review 步骤未充分提取 phase 决策到 PROJECT.md Key Decisions 表。导致 v1.1 Phase 9 讨论时需 git log 刨坟恢复 P7 决策
- **MILESTONES.md 摘要提取失败** — 模板变量未替换就提交了（空 Completed:/Status:/Phase: 行），说明 milestone.complete SDK handler 在缺少 SUMMARY.md 时未做校验
- **Phase 编号碎片化** — Phase 1、1.5、1.5.1、1.5.2、5-02 等子编号表明 roadmap 在多次调整中积累，初始划分不够清晰

### Patterns Established

- **D-XX 决策体系** — 每个 phase 锁定 D-01, D-02... 决策，下游 agent 强制引用。总计约 80+ 决策跨 9 个 phase
- **1+N 组合模式** — 核心方案固定，扩展方案按角色替换。已被 Phase 8-9 的 confidence boost 机制复用
- **协调器不替代调度器** — scientific-do 是执行引擎，GSD 是外层调度。这条边界在 Phase 7 D-01 和 Phase 8 design 中一致维护

### Key Lessons

1. **Milestone 关闭必须验证 PROJECT.md Key Decisions 表完整性** — 不应依赖 AI 执行者自觉。建议 automation：扫描被 downstream phase 引用的 D-XX 决策，自动保留到 Key Decisions
2. **D-XX 编号在 phase 间会重复** — 每个 phase 有自己的 D-01，跨 phase 引用时需要带上 phase 前缀（P7 D-14），否则混淆
3. **Subagent 输出不应无条件信任** — MILESTONES.md 空字段说明 SDK handler 和 AI executor 之间缺乏完整性校验

### Cost Observations

- Model mix: ~60% sonnet, ~40% opus（opus 用于 planner 和复杂规划，sonnet 用于 executor 和 checker）
- Executor agents 用 sonnet 足够满足大部分实现任务，opus 只在 plan-phase 的 planner 中使用

---

## Cross-Milestone Trends

| Metric | v1.0 |
|--------|------|
| Phases | 10 |
| Plans | 26 |
| avg Plans/Phase | 2.6 |
| avg Tasks/Plan | 3-4 |
| Timeline | 2 days |
| Verification pass rate | ~90% (some gaps deferred) |

---
