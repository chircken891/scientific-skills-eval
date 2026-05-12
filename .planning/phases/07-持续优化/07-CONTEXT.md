# Phase 7: 持续优化 - Context

**Gathered:** 2026-05-12
**Status:** Ready for planning

<domain>
## Phase Boundary

基于Phase 5-6已验证的7核心Skill + Scientific-Do协调器，进行增量改进：优化协调器能力、建立反馈闭环、发现新Skill、性能基准测试。不重新评估已有skill，不开发新skill。

</domain>

<decisions>
## Implementation Decisions

### Scientific-Do改进（借鉴ECC模式）
- **D-01:** 保持中央协调器架构，不改为分布式agent
- **D-02:** 3个改进按顺序实施：结构化Skill注册 → 主动意图检测 → 后置验证闭环
- **D-03:** 结构化Skill注册：每个skill加触发条件字段（触发关键词 + 典型场景 + 排除场景）
- **D-04:** 主动意图检测：从上下文推断科研意图，不等用户显式说出关键词
- **D-05:** 后置验证闭环：每个科研阶段完成后增加轻量验证节点

### 配置优化
- **D-06:** Skill声明模型偏好：每个skill的SKILL.md中声明模型偏好，调用时自动切换

### Phase 6遗留问题
- **D-07:** P6-E01做性能基准测试
- **D-08:** P6-E02不做自动化测试框架（维护成本高，ROI低）

### 发现Skill机制
- **D-09:** 自动检测缺口：Scientific-Do执行任务时自动检测能力缺口
- **D-10:** 发现缺口后GitHub自动搜索候选skill
- **D-11:** 沿用Phase 2标准筛选（安全否决 + DepthScore阈值）
- **D-12:** 新发现skill分级入库：DepthScore > 4.0 → 核心直接激活 / 3.0-4.0 → 扩展预下载不激活 / < 3.0 → 不入库
- **D-13:** 替换逻辑：新角色→新增核心 / 同角色更强→替换旧核心，旧的降级为扩展 / 同角色差不多→加入扩展池由协调器选择

### 反馈收集 + 更新机制
- **D-14:** 静默自动记录：每次skill调用自动记录成功/失败状态和耗时
- **D-15:** 每10次Scientific-Do编排弹出1-5分评分 + 选填文字评价
- **D-16:** 更新检查与反馈绑定：每10次一并检查所有已安装skill的GitHub上游更新
- **D-17:** 发现更新→通知摘要+人工确认，不自动更新
- **D-18:** 更新后全量冒烟测试（7个核心skill）

### 扩展Skill
- **D-19:** Phase 5预下载的3个扩展skill（nature-skills / claude-scholar / scientify）按需自动激活

### 核心 vs 扩展优先级
- **D-20:** 不预设优先级，Scientific-Do按场景匹配选择最合适的skill

</decisions>

<specifics>
## Specific Ideas

- Scientific-Do改进借鉴ECC的三个具体模式：agent主动识别域、执行后自动review、结构化的触发条件注册
- 反馈计数器文件位置：`.claude/scientific-skills/feedback-state.json`
- 更新检查利用GitHub API对比本地commit hash与远程
- Phase 5的3个扩展skill已预下载，按需激活即可

</specifics>

<canonical_refs>
## Canonical References

### Phase 6 测试成果
- `.planning/phases/06-测试执行/06-FINAL-REPORT.md` — 测试执行最终报告（16/16 PASS）
- `.planning/phases/06-测试执行/06-04-ISSUES.md` — 问题清单（P6-E01待处理，P6-E02 wontfix）

### Scientific-Do 协调器
- `~/.claude/scientific-skills/skills/scientific-do/SKILL.md` — Scientific-Do协调器定义
- `.planning/phases/05-02-superpowers-structure/05-CONTEXT.md` — Phase 5集合包设计决策

### Phase 4-5 组合方案
- `.planning/phases/04-最优组合生成/04-CONTEXT.md` — 核心方案（7个skill）+ 扩展方案
- `.planning/phases/04-最优组合生成/04-OPTIMAL-COMBINATION.md` — 完整组合方案
- `.planning/phases/05-集成与验证/05-CONTEXT.md` — Phase 5集成决策

### 评测体系
- `.planning/PROJECT.md` — 两阶段评估架构（Tier 1深度 + Tier 2集成度）
- `.planning/ROADMAP.md` — Phase 7定义

</canonical_refs>

<code_context>
## Existing Code Insights

### 7个核心Skill
deepxiv_sdk / academic-paper-analysis / scientific-agent-skills / academic-writing-skills / paper-plot-skills / Paper-Polish-Workflow-skill / medsci-skills

### 3个扩展Skill（预下载未激活）
nature-skills / claude-scholar / scientify

### Scientific-Do协调器
- 3层路由：精确匹配 → 模糊fallback → 智能调优
- 依赖链：文献 → 分析 → 写作 → 图表 → 润色
- HARD-GATE节点：规划前必须研究 / 写作前必须设计 / 执行前必须确认
- 全局状态管理

### 安装位置
- Skill安装：~/.claude/skills/
- 集合包：~/.claude/scientific-skills/
- 扩展Skill：~/.claude/skills-extensions/
</code_context>

<deferred>
## Deferred Ideas

无 — 讨论保持在Phase 7范围内

</deferred>

---

*Phase: 07-持续优化*
*Context gathered: 2026-05-12*
