# Phase 2: 安全初筛与功能评测 - Context

**Gathered:** 2026-05-11
**Updated:** 2026-05-11 (aligned with Phase 01.5.1 new methodology)
**Status:** Ready for execution

<domain>
## Phase Boundary

使用Phase 01.5.1验证的两阶段评测体系，对39个科研skill仓库进行安全否决筛选和功能评分，输出完整评分卡 + 横向矩阵 + 推荐组合。

Phase 01.5.2已完成所有预测试调整（ARIS验证、academic-writing验证、弱能力仓库识别、安全问题仓库识别）。

</domain>

<decisions>
## Implementation Decisions

### 评测范围与策略
- **D-01:** 评测范围 — 39个仓库（Phase 1的21个 + Phase 1.5新增18个）
- **D-02:** Phase 01.5.2已完成调整验证，Phase 2直接使用调整后的9样本 + 评测剩余30个仓库

### 评分体系（Phase 01.5.1验证后的新体系）
- **D-03:** 两阶段评估架构 — Tier 1 专业深度评分（1-5）驱动决策，Tier 2 描述性信息用于组合决策
- **D-04:** 功能维度 — 专业深度评分1-5（只评1-2个最佳功能，0.5递增，共9级）
- **D-05:** 阈值映射 — <3.0 EXCLUDE / 3.0-4.0 CANDIDATE / >4.0 AUTO-RECOMMEND，边界包含
- **D-06:** 覆盖度维度 — 描述性（不评分），记录Coverage_Stages + Coverage_Description
- **D-07:** 集成度维度（保持评分）— 5项各1-5分，作为组合内排序次键

### 安全否决标准（不变）
- **D-08:** 安全否决 — 四项检查各有明确判断标准
  - 数据安全：是否访问/存储敏感数据
  - 权限范围：是否申请过度权限
  - 网络请求：是否有可疑外网通信
  - 依赖来源：第三方依赖是否可信
- **D-09:** 任一项不合格 → 标记「否决 + 原因」，不进入组合候选

### 执行方式
- **D-10:** Phase 02-01跳过抽样验证（Phase 01.5.2已完成），直接全量评测剩余30个仓库
- **D-11:** 自动化评分 + 人工最终组合确认

### 输出格式
- **D-12:** 输出格式 — 评分卡 + 横向矩阵（按阈值分类） + 推荐组合

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before implementing.**

### 评测体系（Phase 01.5.1验证成果）
- `.planning/phases/01.5.1-评测方法预测试/01.5.1-METHODOLOGY-SPEC.md` — **Phase 2必须使用的评分体系规范**
- `.planning/phases/01.5.1-评测方法预测试/01.5.1-SCORING-RUBRIC.md` — 10种功能类型的1-5评分标准
- `.planning/phases/01.5.1-评测方法预测试/01.5.1-SCORING-TEMPLATE.tsv` — 22列TSV模板
- `.planning/phases/01.5.1-评测方法预测试/01.5.1-EXCLUSION-REASON.md` — 结构化排除理由格式

### Phase 01.5.2 调整成果
- `.planning/phases/01.5.2-评测调整/01.5.2-EVALUATION-UPDATED.md` — 更新后的9样本评分（含ARIS和academic-writing验证结果）
- `.planning/phases/01.5.2-评测调整/01.5.2-SCORES-UPDATED.tsv` — 更新后的9样本TSV
- `.planning/phases/01.5.2-评测调整/01.5.2-VERIFICATION-UPDATE.md` — 边界案例验证 + 弱能力/安全问题仓库识别结果

### 项目文档
- `.planning/ROADMAP.md` — Phase 2定义（39个仓库评测）
- `.planning/REQUIREMENTS.md` — 评测维度定义
- `.planning/PROJECT.md` — 项目目标与约束
- `.planning/SKILLS-INVENTORY.md` — 39个仓库完整清单

</canonical_refs>

<codebase_context>
## 评测仓库清单

### Phase 01.5.2已评分(9个)
来自01.5.2-SCORES-UPDATED.tsv，无需重新评分。

### Phase 2需评测(剩余~30个)
来自SKILLS-INVENTORY.md，减去上述9个。

</code_context>

<specifics>
## Specific Ideas

- Phase 02-01跳过抽样，直接从Phase 01.5.2获取已验证的9样本
- 评测剩余30个仓库时，刻意寻找有安全问题的仓库以测试否决工作流
- 刻意寻找评分<3.0的仓库以验证EXCLUDE阈值

</specifics>

<deferred>
## Deferred Ideas

None — Phase 2保持在执行范围内

</deferred>

---

*Phase: 2-安全初筛与功能评测*
*Context updated: 2026-05-11 (aligned with Phase 01.5.1 new methodology)*
