# 科研Skill评测 — Phase 4 Context

**Gathered:** 2026-05-12
**Phase:** 4-最优组合生成
**Status:** Ready for execution

---

<domain>
## Phase Boundary

基于Phase 3的互补/冗余分析，生成1+N模式的最优组合方案：
- 1个核心方案（方案A：6个学术Skill + 1个工具Skill）
- N个扩展方案（通过角色替换生成）

</domain>

<decisions>
## Implementation Decisions

### 组合模式
- **D-01:** 1+N模式 — 1个核心方案 + N个扩展方案
- **D-02:** 核心方案 = 方案A（6个学术Skill）
- **D-03:** 扩展模式 = 角色替换（按需替换特定角色）

### 核心方案（方案A）
**学术Skill (6个):**
| 角色 | Skill | DepthScore | Integration |
|------|-------|-----------|-------------|
| 文献检索 | deepxiv_sdk | 4.0 | 13 |
| 数据分析 | scientific-agent-skills | 4.5 | 20 |
| 论文写作 | academic-writing-skills | 4.0 | 18 |
| 图表生成 | paper-plot-skills | 4.0 | 18 |
| 投稿润色 | Paper-Polish-Workflow-skill | 4.0 | 15 |
| 医学专项 | medsci-skills | 4.5 | 18 |

**工具Skill (1个):**
| Skill | 用途 |
|-------|------|
| everything-claude-code | Claude Code增强 |

### 扩展方案（角色替换）
- 医学研究：medsci-skills（已有）
- Nature投稿：nature-skills替换paper-plot-skills
- 引用管理：yy/claude-scholar添加
- OpenClaw用户：scientify添加

### 工具Skill
- **D-04:** 所有方案都带 everything-claude-code
- **D-05:** OpenClaw用户额外安装 scientify

</decisions>

<canonical_refs>
## Canonical References

### Phase 3 分析成果
- `.planning/phases/03-组合分析/03-COMBINATIONS.md` — 角色化组合方案
- `.planning/phases/03-组合分析/03-MATRIX.md` — 互补/冗余矩阵
- `.planning/phases/03-组合分析/03-ROLES.md` — 角色化定义

### Phase 2 评测结果
- `.planning/phases/02-安全初筛与功能评测/02-MATRIX.md` — 39个仓库评分矩阵
- `.planning/phases/02-安全初筛与功能评测/02-SCORES-SAMPLE.tsv` — 评分数据

### 项目文档
- `.planning/ROADMAP.md` — Phase 4定义
- `.planning/REQUIREMENTS.md` — 需求定义

</canonical_refs>

<codebase_context>
## 组合数据基础

### 核心方案（方案A）
- 学术Skill：deepxiv_sdk + scientific-agent-skills + academic-writing-skills + paper-plot-skills + Paper-Polish-Workflow-skill + medsci-skills
- 工具Skill：everything-claude-code

### 扩展角色替换表
| 角色 | 核心 | 扩展1 | 扩展2 |
|------|------|--------|--------|
| 文献检索 | deepxiv_sdk | - | - |
| 数据分析 | scientific-agent-skills | medsci-skills | - |
| 论文写作 | academic-writing-skills | - | - |
| 图表生成 | paper-plot-skills | nature-skills | - |
| 投稿润色 | Paper-Polish-Workflow-skill | nature-skills | - |
| 医学专项 | medsci-skills | - | - |

</code_context>

<deferred>
## Deferred Ideas

- 自动化组合推荐（基于用户研究类型）
- 动态组合调整（根据用户反馈优化）

</deferred>

---

*Phase: 4-最优组合生成*
