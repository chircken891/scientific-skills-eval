# Phase 2: 安全初筛与功能评测 - Context

**Gathered:** 2026-05-11
**Status:** Ready for planning

<domain>
## Phase Boundary

对39个科研skill仓库进行安全否决筛选和功能评分，输出每个仓库的完整评分卡 + 横向矩阵 + 推荐组合。

</domain>

<decisions>
## Implementation Decisions

### 评测范围与策略
- **D-01:** 评测范围 — 39个仓库（Phase 1的21个 + Phase 1.5新增18个）
- **D-02:** 评测策略 — 先抽样验证（每功能领域各抽1个共约9个），确认标准无误后全量执行

### 抽样维度
- **D-03:** 抽样方式 — 按功能领域分组，每领域抽1个代表性仓库
- **D-04:** 功能领域分类：文献检索(4)→文献综述(2)→学术写作(4)→Nature系列(2)→数据分析(3)→引用管理(2)→图表生成(3)→医学专用(2)→科研工具(4)

### 安全否决标准
- **D-05:** 安全否决 — 精确阈值，四项检查项各有明确判断标准
  - 数据安全：是否访问/存储敏感数据
  - 权限范围：是否申请过度权限
  - 网络请求：是否有可疑外网通信
  - 依赖来源：第三方依赖是否可信
- **D-06:** 任一项不合格 → 标记「否决 + 原因」，不进入组合候选

### 评分体系（Phase 01.5.1 验证后的新体系）
- **D-07:** 两阶段评估架构 — Tier 1 专业深度评分（1-5）驱动决策，Tier 2 描述性信息（集成度+覆盖度）用于组合决策
- **D-08:** 功能维度 — 专业深度评分1-5（只评1-2个最佳功能，0.5递增，共9级）
- **D-09:** 阈值映射 — <3.0 EXCLUDE / 3.0-4.0 CANDIDATE / >4.0 AUTO-RECOMMEND，边界包含
- **D-10:** 覆盖度维度 — 描述性（不评分），记录Coverage_Stages + Coverage_Description
- **D-11:** 集成度维度（保持评分）— 5项各1-5分，作为组合内排序次键

### 执行方式
- **D-11:** 执行方式 — Claude执行检查，用户审核阈值是否合理，最终由用户做否决/通过决定

### 输出格式
- **D-12:** 输出格式 — 评分卡 + 横向矩阵 + 推荐组合

### Phase 01.5.1 验证成果
- Phase 01.5.1 验证了D-06原则（medsci-skills #2→#1，paper-plot-skills +5位）
- Phase 01.5.1 发现7个问题，其中3个MEDIUM优先级需在Phase 2中验证

### Claude's Discretion
- 抽样顺序可按仓库质量/复杂度灵活调整
- 必须包含刻意选择的低能力仓库测试EXCLUDE阈值（<3.0）
- 必须包含有已知安全问题的仓库测试否决工作流

</decisions>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### 项目文档
- `.planning/ROADMAP.md` — Phase 2定义（39个仓库评测）
- `.planning/REQUIREMENTS.md` — 评测维度定义（安全/功能/集成度/覆盖度评分体系）
- `.planning/PROJECT.md` — 项目目标与约束（安全一票否决等）

### Phase 01.5.1 方法论验证成果
- `.planning/phases/01.5.1-评测方法预测试/01.5.1-METHODOLOGY-SPEC.md` — **Phase 2必须使用的新评分体系规范**
- `.planning/phases/01.5.1-评测方法预测试/01.5.1-SCORING-RUBRIC.md` — 10种功能类型的1-5评分标准
- `.planning/phases/01.5.1-评测方法预测试/01.5.1-SCORING-TEMPLATE.tsv` — 22列TSV模板
- `.planning/phases/01.5.1-评测方法预测试/01.5.1-DELTA-ANALYSIS.md` — 7个Phase 2建议（含MEDIUM优先级验证项）

### Phase 1.5 搜索成果
- `.planning/phases/01.5-自主搜索仓库补充/01.5-CONTEXT.md` — 搜索范围与策略决策
- `.planning/SKILLS-INVENTORY.md` — 39个仓库完整清单

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- REQUIREMENTS.md中的评分维度表格可直接作为评分卡模板
- SKILLS-INVENTORY.md的仓库分类可作为抽样分层依据

### Established Patterns
- 安全一票否决：数据安全/权限范围/网络请求/依赖来源四项检查（独立于评分运行）
- 两阶段评估：Tier 1专业深度评分(1-5)驱动决策，Tier 2描述性信息用于组合决策
- 功能选择优先级：自声明专长 > 证据最充分 > 实现细节最具体
- 阈值映射：<3.0 EXCLUDE / 3.0-4.0 CANDIDATE / >4.0 AUTO-RECOMMEND

### Integration Points
- 评分卡输出需对接Phase 3的组合分析矩阵
- 推荐组合输出需对接Phase 4的最优组合生成

</code_context>

<specifics>
## Specific Ideas

- 抽样顺序（按功能领域）：文献检索→文献综述→学术写作→Nature系列→数据分析→引用管理→图表生成→医学专用→科研工具
- 阈值确认流程：Claude初筛 → 用户审核阈值 → 确认后全量

</specifics>

<deferred>
## Deferred Ideas

None — 讨论保持在Phase 2范围内

</deferred>

---

*Phase: 2-安全初筛与功能评测*
*Context gathered: 2026-05-11*