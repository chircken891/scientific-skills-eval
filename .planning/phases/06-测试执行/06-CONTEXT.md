# Phase 6: 测试执行 - Context

**Gathered:** 2026-05-12
**Status:** Ready for planning

<domain>
## Phase Boundary

执行Phase 5创建的测试文档，验证已安装的7个核心Skill和Scientific-Do协调器功能。测试在新建Claude Code session中进行。

</domain>

<decisions>
## Implementation Decisions

### 测试执行方式
- **D-01:** 手动测试 — 在Claude Code session中逐个调用skill测试

### 失败处理
- **D-02:** 分级处理策略：
  - 关键功能失败 → 立即尝试修复skill配置
  - 边缘情况失败 → 记录到问题清单，暂不修复

### Scientific-Do测试
- **D-03:** 两者结合：
  - 预设场景测试：验证协调器核心路由功能
  - 自由测试：测试边缘情况和实际科研场景

### 测试环境
- **D-04:** 新建Claude Code session执行测试
- **D-05:** 每个测试记录结果和发现

### 测试优先级
- **D-06:** 按以下顺序执行：
  1. 7个核心Skill冒烟测试（05-TEST-GUIDE.md）
  2. Scientific-Do协调器测试（预设场景）
  3. 端到端工作流测试（05-WORKFLOW-TEST.md）
  4. 边界情况和异常处理测试

### Claude's Discretion
- 具体测试输入内容（除了预设场景外）
- 测试结果记录格式
- 问题的具体修复方案

</decisions>

<specifics>
## Specific Ideas

从Phase 5继承：
- 测试通过标准：100%
- 测试格式：混合模式（手动测试 + 自动化脚本模板已备好）
- Scientific-Do协调器已创建（intent-parser.ts, skill-router.ts）

预设测试场景（Scientific-Do）：
- 场景1：「搜索机器学习文献」→ 应路由到deepxiv_sdk
- 场景2：「分析数据并写论文」→ 应协调scientific-agent-skills + academic-writing-skills
- 场景3：「生成图表并润色」→ 应协调paper-plot-skills + Paper-Polish-Workflow-skill

</specifics>

<canonical_refs>
## Canonical References

### Phase 5 测试文档
- `.planning/phases/05-02-superpowers-structure/05-TEST-GUIDE.md` — 7个核心Skill功能测试指南
- `.planning/phases/05-02-superpowers-structure/05-WORKFLOW-TEST.md` — 端到端工作流测试
- `.planning/phases/05-02-superpowers-structure/05-VERIFICATION.md` — Phase 5验证报告

### Phase 5 实现
- `.planning/phases/05-02-superpowers-structure/05-SUMMARY.md` — Phase 5完整交付物清单
- `~/.claude/scientific-skills/skills/scientific-do/SKILL.md` — Scientific-Do协调器定义
- `~/.claude/scientific-skills/skills/scientific-do/intent-parser.ts` — 意图解析模块
- `~/.claude/scientific-skills/skills/scientific-do/skill-router.ts` — Skill路由模块

### Phase 5 决策
- `.planning/phases/05-02-superpowers-structure/05-CONTEXT.md` — Phase 5上下文和决策

</canonical_refs>

<codebase_context>
## Existing Code Insights

### 7个核心Skill
- deepxiv_sdk — 文献检索
- academic-paper-analysis — 论文分析
- scientific-agent-skills — 数据分析
- academic-writing-skills — 论文写作
- paper-plot-skills — 图表生成
- Paper-Polish-Workflow-skill — 投稿润色
- medsci-skills — 医学专项

### Scientific-Do协调器
- 3层路由：精确匹配 → 模糊fallback → 智能调优
- 依赖链：文献 → 分析 → 写作 → 图表 → 润色
- HARD-GATE节点

### 测试环境
- Skill安装位置：~/.claude/skills/
- 集合包位置：~/.claude/scientific-skills/
- 扩展Skill位置：~/.claude/skills-extensions/

</codebase_context>

<deferred>
## Deferred Ideas

- 自动化测试框架建设（需要skill支持CLI接口）
- 测试结果自动记录系统
- Skill性能基准测试

</deferred>

---
*Phase: 06-测试执行*
*Context gathered: 2026-05-12*
