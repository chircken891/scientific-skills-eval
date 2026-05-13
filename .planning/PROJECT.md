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

### 搜索与发现 (v1.0 Phase 1.5-1.5.1)

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| 跨平台全局搜索 | 不限于 GitHub，覆盖 npm、VS Code marketplace、MCP registry | ✓ Good — v1.0 |
| 一次补充 + 保留更新窗口 | Phase 1.5 一次性搜索，留机制接口供后续补充 | ✓ Good — v1.0 |
| 去重：同名仓库保留最新 | 按 star、活跃度、维护状态选择 | ✓ Good — v1.0 |

### 评测方法论 (v1.0 Phase 1.5.1-02)

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| 安全一票否决 | 4 项硬检查（数据安全/权限/网络/依赖），任一不合格直接排除，独立于评分 | ✓ Good — v1.0 |
| 专业深度取代全能评分 | 只评 skill 最擅长的 1-2 个功能质量，不因为"不全能"惩罚专业化 skill | ✓ Good — v1.0 |
| 两阶段评估架构 | Tier 1 专业深度评分(1-5) 驱动决策，Tier 2 描述性信息(覆盖度/集成度) 辅助组合 | ✓ Good — v1.0 |
| 阈值自动化分类 | <3.0 EXCLUDE / 3.0-4.0 CANDIDATE / >4.0 AUTO-RECOMMEND | ✓ Good — v1.0 |
| 排除项必须附理由 | 自动化排除 + 理由生成，人工可复核 | ✓ Good — v1.0 |
| 最终组合方案人工确认 | 评分/分类/推荐自动化，最终方案由人确认 | ✓ Good — v1.0 |

### 组合分析 (v1.0 Phase 03-04)

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| 按功能类别分组分析 | 检索/写作/分析/医学/工具/引用/图表，每类内两两对比 | ✓ Good — v1.0 |
| 双重冗余检测 | 阈值差异(DepthScore >= 1.5) + 功能重叠(>80%)，强者保留弱者备选 | ✓ Good — v1.0 |
| 1+N 组合模式 | 1 个核心方案(6+1 skill) + N 个扩展方案(角色替换) | ✓ Good — v1.0 |
| 角色化输出 | 每个角色 1-2 个 skill，输出互补/冗余矩阵 + Mermaid 依赖图 | ✓ Good — v1.0 |

### 集成架构 (v1.0 Phase 05-06)

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| scientific-do 中央协调器 | 5-step：意图解析 → 路由 → 编排 → 验证 → 反馈；不改为分布式 agent | ✓ Good — v1.0 |
| GSD 做外层调度 | scientific-do 是执行引擎，不替代 GSD 调度器 | ✓ Good — v1.0 |
| HARD-GATE 策略 | 规划前必须研究、写作前必须设计、执行前必须确认 | ✓ Good — v1.0 |
| 结构化 Skill 注册 | 每个 skill 声明触发关键词 + 典型场景 + 排除场景 + 模型偏好 | ✓ Good — v1.0 |
| 扩展 skill 预下载不激活 | nature-skills/claude-scholar/scientify 按需自动激活 | ✓ Good — v1.0 |
| 测试：冒烟→协调器→端到端→边界 | 4 层优先级顺序，100% 通过标准 | ✓ Good — v1.0 |
| 测试失败分级处理 | 关键功能→立即修复 / 边缘情况→记录不阻塞 | ✓ Good — v1.0 |

### 持续优化基础设施 (v1.0 Phase 07)

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| P7 D-01: 保持中央协调器架构 | 不改为分布式 agent | ✓ Good — v1.0 |
| P7 D-02: 改进顺序 | 结构化注册 → 主动意图检测 → 后置验证闭环 | ✓ Good — v1.0 |
| P7 D-06: Skill 声明模型偏好 | SKILL.md 声明模型偏好，调用时自动切换 | ✓ Good — v1.0 |
| P7 D-09: 自动检测缺口 | scientific-do 执行时自动检测能力缺口 | ✓ Good — v1.0 |
| P7 D-10: GitHub 搜索候选 skill | 发现缺口后自动搜索 | ✓ Good — v1.0 |
| P7 D-12: 分级入库 | >4.0 核心直接激活 / 3.0-4.0 扩展预下载 / <3.0 不入库 | ✓ Good — v1.0 |
| P7 D-13: 替换逻辑 | 新角色→新增核心 / 同角色更强→替换旧核心 / 同角色差不多→扩展池 | ✓ Good — v1.0 |
| P7 D-14: 静默自动记录 | 每次 skill 调用自动记录成功/失败和耗时 → Phase 9 落地为 invocation_log | ✓ Good — v1.0 |
| P7 D-15: 评分触发 | 每 10 次 scientific-do 调用弹出 1-5 分评分 | — Pending (Phase 9) |
| P7 D-16: 更新检查与反馈绑定 | 每 20 次（已从 10 改为 20）检查已安装 skill 上游更新 | — Pending (Phase 9) |
| P7 D-17: 人工确认更新 | 不自动更新，通知摘要后人工确认 | — Pending |
| P7 D-18: 更新后冒烟测试 | 全量冒烟测试 7 核心 skill | — Pending |
| P7 D-19: 扩展按需激活 | Phase 5 预下载的 3 个扩展 skill 按需自动激活 | ✓ Good — v1.0 |
| P7 D-20: 不预设优先级 | scientific-do 按场景匹配选择最合适 skill | ✓ Good — v1.0 |

---

*Last updated: 2026-05-13 — v1.0 retrospective completed (Key Decisions fully populated, RETROSPECTIVE.md created, MILESTONES.md repaired)*
