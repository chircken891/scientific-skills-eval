# v1.1 Requirements: GSD-scientific 集成协议

## GSD Integration

- [ ] **GSD-01**: GSD 项目上下文感知 — scientific-do 启动时检测 `.planning/` 目录，自动读取 PROJECT.md / STATE.md / ROADMAP.md，识别当前 phase、plan、requirement 状态
- [ ] **GSD-02**: 调用日志系统 — feedback-state.json 扩展 invocation_log 数组，每条记录包含：timestamp、intent、routed_skill、execution_summary、phase/plan 关联、duration_ms
- [ ] **GSD-03**: GSD 合规输出 — 在 GSD 项目内执行时，产出写入对应 phase 目录，支持生成 SUMMARY.md 或 plan-specific SUPPLEMENT.md 格式，遵循 GSD 命名约定

### Future

- [ ] **GSD-04**: 长任务会话管理 — 跨多次对话的任务连续性、checkpoint 支持
- [ ] **GSD-05**: 自动 plan 建议 — 基于 invocation_history 推荐下一步 phase

### Out of Scope

- 论文润色实战（后续 milestone）
- everything-claude-code 集成
- GSD 调度器替代（GSD 仍是外层，scientific-do 是执行引擎）

## Traceability

| REQ-ID | Description | Phase |
|--------|-------------|-------|
| GSD-01 | GSD context detection | — |
| GSD-02 | invocation log | — |
| GSD-03 | GSD output format | — |
