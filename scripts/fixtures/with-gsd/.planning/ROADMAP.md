# 科研Skill评测项目 — 路线图

## Milestones

- ✅ **v1.0 科研Skill评测与集成** — Phases 0-7 (shipped 2026-05-12)
- **v1.1 GSD-scientific集成协议** — Phases 8-9 (planning)

## Phases

<details>
<summary>✅ v1.0 科研Skill评测与集成 (Phases 0-7) — SHIPPED 2026-05-12</summary>

- [x] Phase 0: 讨论与初始化 — completed 2026-05-11
- [x] Phase 1: 搜索与发现 — completed 2026-05-11
- [x] Phase 2: 安全初筛与功能评测 — completed 2026-05-12
- [x] Phase 3: 组合分析 — completed 2026-05-12

</details>

<details open>
<summary>🔜 v1.1 GSD-scientific集成协议 (Phases 8-9) — PLANNING</summary>

- [ ] **Phase 8: GSD 项目上下文感知** — scientific-do 检测 `.planning/` 并读取 phase/plan 状态
- [ ] **Phase 9: 调用追踪与 GSD 合规产出** — invocation_log 结构化记录 + 产出写入 phase 目录

</details>

## Phase Details

### Phase 8: GSD 项目上下文感知

**Goal**: scientific-do 启动时自动检测 GSD 项目上下文，识别当前 phase/plan/requirement 状态

**Depends on**: Nothing

**Requirements**: GSD-01

**Success Criteria**: 5 criteria defined

**Plans**: 2 plans

### Phase 9: 调用追踪与 GSD 合规产出

**Goal**: 每次 scientific-do 执行生成结构化调用记录

**Depends on**: Phase 8

**Requirements**: GSD-02, GSD-03

**Success Criteria**: 5 criteria defined

**Plans**: TBD

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 0. 讨论与初始化 | v1.0 | — | Complete | 2026-05-11 |
| 1. 搜索与发现 | v1.0 | — | Complete | 2026-05-11 |
| 2. 安全初筛与功能评测 | v1.0 | 3/3 | Complete | 2026-05-12 |
| **8. GSD 上下文感知** | **v1.1** | **0/2** | **Planning** | **—** |
| **9. 调用追踪与合规产出** | **v1.1** | **0/0** | **Defined** | **—** |
