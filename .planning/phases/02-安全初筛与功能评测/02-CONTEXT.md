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

### 评分体系
- **D-07:** 评分粒度 — 多级评分（功能40%/集成度30%/覆盖度30%）
- **D-08:** 功能维度（8项×5分）：核心能力、医学适配度、长文本适配、统计/数学能力、代码生成、工具调用效率、自主兜底、多模态
- **D-09:** 集成度维度（5项×5分）：Claude Code集成难度、MCP兼容性、冲突风险、维护成本、上下文依赖
- **D-10:** 覆盖度维度（4项×5分）：领域覆盖、科研阶段覆盖、互补性、冗余度

### 执行方式
- **D-11:** 执行方式 — Claude执行检查，用户审核阈值是否合理，最终由用户做否决/通过决定

### 输出格式
- **D-12:** 输出格式 — 评分卡 + 横向矩阵 + 推荐组合

### Claude's Discretion
- 抽样顺序可按仓库质量/复杂度灵活调整
- 阈值具体数值待Claude初筛后根据实际情况提出建议，用户确认

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### 项目文档
- `.planning/ROADMAP.md` — Phase 2定义（39个仓库评测）
- `.planning/REQUIREMENTS.md` — 评测维度定义（安全/功能/集成度/覆盖度评分体系）
- `.planning/PROJECT.md` — 项目目标与约束（安全一票否决等）

### Phase 1.5 成果
- `.planning/phases/01.5-自主搜索仓库补充/01.5-CONTEXT.md` — 搜索范围与策略决策
- `.planning/SKILLS-INVENTORY.md` — 39个仓库完整清单

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- REQUIREMENTS.md中的评分维度表格可直接作为评分卡模板
- SKILLS-INVENTORY.md的仓库分类可作为抽样分层依据

### Established Patterns
- 安全一票否决：数据安全/权限范围/网络请求/依赖来源四项检查
- 加权评分：功能40% + 集成度30% + 覆盖度30%

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