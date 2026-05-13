# 科研Skill评测项目 — 路线图

## Milestones

- ✅ **v1.0 科研Skill评测与集成** — Phases 0-7 (shipped 2026-05-12)
- **v1.1 GSD-scientific集成协议** — Phases 8-9 (planning)

## Phases

<details>
<summary>✅ v1.0 科研Skill评测与集成 (Phases 0-7) — SHIPPED 2026-05-12</summary>

- [x] Phase 0: 讨论与初始化 — completed 2026-05-11
- [x] Phase 1: 搜索与发现 — completed 2026-05-11
- [x] Phase 01.5: 自主搜索仓库补充 (1/1 plan) — completed 2026-05-11
- [x] Phase 01.5.1: 评测方法预测试 (3/3 plans) — completed 2026-05-12
- [x] Phase 01.5.2: 评测调整 (1/1 plan) — completed 2026-05-12
- [x] Phase 02: 安全初筛与功能评测 (3/3 plans) — completed 2026-05-12
- [x] Phase 03: 组合分析 (2/2 plans) — completed 2026-05-12
- [x] Phase 04: 最优组合生成 (1/1 plan) — completed 2026-05-12
- [x] Phase 05: 集成与验证 (6/6 plans) — completed 2026-05-12
- [x] Phase 06: 测试执行 (4/4 plans) — completed 2026-05-12
- [x] Phase 07: 持续优化 (5/5 plans) — completed 2026-05-12

</details>

<details open>
<summary>🔜 v1.1 GSD-scientific集成协议 (Phases 8-9) — PLANNING</summary>

- [ ] **Phase 8: GSD 项目上下文感知** — scientific-do 检测 `.planning/` 并读取 phase/plan 状态
- [ ] **Phase 9: 调用追踪与 GSD 合规产出** — invocation_log 结构化记录 + 产出写入 phase 目录

</details>

## Phase Details

### Phase 8: GSD 项目上下文感知

**Goal**: scientific-do 启动时自动检测 GSD 项目上下文，识别当前 phase/plan/requirement 状态，使后续路由和执行逻辑能感知项目阶段。

**Depends on**: Nothing (first phase of v1.1, builds on existing scientific-do infrastructure)

**Requirements**: GSD-01

**Success Criteria** (what must be TRUE):
1. scientific-do 启动时检测当前目录是否存在 `.planning/`，存在则自动读取 PROJECT.md / STATE.md / ROADMAP.md
2. scientific-do 能解析 STATE.md 中的 `current_position`（phase/plan/status）和 progress 字段
3. scientific-do 能解析 ROADMAP.md 中的 phase 列表和完成状态
4. 当不在 GSD 项目目录内（无 `.planning/`）时，scientific-do 正常降级运行，不报错
5. 上下文数据在路由决策中可用（后续 phase 可通过 env/context 访问）

**Plans**: 2 plans

```
Plans:
- [x] 08-01-PLAN.md — gsd-context-detect.sh 核心实现（检测+解析+测试框架）
- [x] 08-02-PLAN.md — scientific-do Step 1 集成（GSD 信号、置信度增强、环境变量）
```

### Phase 9: 调用追踪与 GSD 合规产出

**Goal**: 每次 scientific-do 执行生成结构化调用记录，并将产出写入 GSD phase 目录，实现执行追踪与项目可审计性。

**Depends on**: Phase 8

**Requirements**: GSD-02, GSD-03

**Success Criteria** (what must be TRUE):
1. 每次 scientific-do 调用在 feedback-state.json 的 invocation_log 数组新增一条记录，包含 timestamp、intent、routed_skill、execution_summary、phase/plan 关联、duration_ms
2. 在 GSD 项目内执行时，产出文件写入对应 phase 目录（`.planning/phases/phase-{N}/`），遵循 phase 命名约定
3. 生成的输出文件格式为 SUMMARY.md（phase 级总结）或 SUPPLEMENT.md（plan 级补充），包含 frontmatter 元数据
4. 非 GSD 项目环境下，调用日志仍正常记录（不包含 phase/plan 字段），产出写入默认位置
5. invocation_log 累计增长时可被用于后续分析（如执行频次统计、常用 skill 排行）

**Plans**: 2 plans


```
Plans:
- [ ] 09-01-PLAN.md - gsd-context-detect.sh current_plan field (D-06 follow-up)
- [ ] 09-02-PLAN.md - append-invocation-log.sh helper + tests + SKILL.md Step 5
```

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 0. 讨论与初始化 | v1.0 | — | Complete | 2026-05-11 |
| 1. 搜索与发现 | v1.0 | — | Complete | 2026-05-11 |
| 01.5. 自主搜索仓库补充 | v1.0 | 1/1 | Complete | 2026-05-11 |
| 01.5.1. 评测方法预测试 | v1.0 | 3/3 | Complete | 2026-05-12 |
| 01.5.2. 评测调整 | v1.0 | 1/1 | Complete | 2026-05-12 |
| 02. 安全初筛与功能评测 | v1.0 | 3/3 | Complete | 2026-05-12 |
| 03. 组合分析 | v1.0 | 2/2 | Complete | 2026-05-12 |
| 04. 最优组合生成 | v1.0 | 1/1 | Complete | 2026-05-12 |
| 05. 集成与验证 | v1.0 | 6/6 | Complete | 2026-05-12 |
| 06. 测试执行 | v1.0 | 4/4 | Complete | 2026-05-12 |
| 07. 持续优化 | v1.0 | 5/5 | Complete | 2026-05-12 |
| **8. GSD 上下文感知** | **v1.1** | **0/2** | **Planning** | **—** |
| **9. 调用追踪与合规产出** | **v1.1** | **0/0** | **Defined** | **—** |

---

See `.planning/milestones/v1.0-ROADMAP.md` for v1.0 full phase details.
