# Retrospective

## Milestone: v1.0 — 科研Skill评测与集成

**Shipped:** 2026-05-12
**Phases:** 10 | **Plans:** 26 | **Timeline:** 2026-05-11 to 2026-05-12 (2 days)

### What Was Built

**Phase 1-1.5 搜索与发现：** 跨平台（GitHub/npm/MCP/VS Code）收集 39 个科研 skill 仓库，建立 SKILLS-INVENTORY.md。

**Phase 1.5.1-02 评测体系：** 两阶段评估架构（安全否决 + 专业深度评分），对 39 个仓库全量评测，输出 25 AUTO-RECOMMEND / 14 CANDIDATE / 0 EXCLUDE / 0 VETOED。

**Phase 03-04 组合生成：** 按 6 类功能角色分组分析，双重冗余检测，生成 1+N 最优组合（6 学术 + 1 工具 = 核心方案，N 个角色替换扩展）。

**Phase 05-06 集成与测试：** 创建 scientific-skills 集合包和 scientific-do 5-step 协调器。4 层测试（冒烟→协调器→端到端→边界）全部通过。

**Phase 07 持续优化：** 结构化 skill 注册、主动意图检测、后置验证闭环、性能基准、更新检测、缺口发现管线。

最终交付：7 核心 skill + 3 扩展 skill + scientific-do + 全套运维脚本。

### What Worked

- **安全一票否决制** — 4 项硬检查独立于评分，在 Phase 2 早期建立清晰边界，整个 v1.0 零否决（说明收集到的 skill 质量基线高）
- **专业深度取代全能评分** — Phase 1.5.1 的关键调整：不因为"不全能"惩罚专业化 skill，产出更有意义的排序
- **1+N 组合模式** — 核心固定 + 角色替换，既保证基础覆盖又允许灵活性。已被 Phase 8-9 的 confidence boost 机制复用
- **D-XX 决策体系** — 每 phase 锁定编号决策，下游 agent 强制引用。约 80+ 决策跨 9 个 phase，形成可追溯的设计链
- **Git history 作为归档** — phase 文件虽被清理，git show 随时恢复

### What Was Inefficient

- **Milestone 关闭执行偏差** — complete-milestone 的 evolve_project_full_review 未充分提取所有 phase 决策到 PROJECT.md。P1.5-P6 的决策虽然存在于 git，但跨 milestone 时完全不可见
- **MILESTONES.md 生成破损** — 模板变量未替换就提交（空字段行），SDK handler 缺乏输出完整性校验
- **Phase 编号碎片化** — 1.5、1.5.1、1.5.2、5-02 等小数编号表明 roadmap 在迭代中多次插入调整
- **跨 phase D-XX 引用模糊** — 每个 phase 有自己的 D-01，不标明 phase 前缀（如 P7 D-14）时无法定位

### Patterns Established

- **评估→组合→集成→优化 四阶段节奏** — Phase 1-2 评估、Phase 3-4 组合、Phase 5-6 集成、Phase 7 优化，形成完整的 skill 管理生命周期
- **协调器不替代调度器** — scientific-do 是执行引擎，GSD 是外层调度。P5 D-04、P7 D-01、P8 design 一致维护
- **自动化 + 人工确认边界** — 评分/分类/推荐全自动，最终方案人工确认。P2 D-11/D-12 确立，贯穿后续 phase

### Key Lessons

1. **Milestone 关闭必须覆盖所有 phase 的决策提取** — 当前设计依赖 AI 自觉，应改为自动化扫描：下游 phase 的 canonical_refs 和 Depends on 引用了哪些上游决策 → 自动保留到 PROJECT.md
2. **D-XX 需要全局唯一前缀** — 建议标准格式 P{N}-D{NN}，如 P7-D14，避免歧义
3. **MILESTONES.md 生成后需要 format validation** — 空字段/未替换模板变量应触发 retry 而非静默提交

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
