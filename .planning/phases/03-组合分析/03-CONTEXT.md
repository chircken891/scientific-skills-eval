# 科研Skill评测 — Phase 3 Context

**Gathered:** 2026-05-11
**Phase:** 3-组合分析
**Status:** Ready for execution

---

<domain>
## Phase Boundary

分析Phase 2评测的39个仓库（25 AUTO-RECOMMEND + 14 CANDIDATE），输出：
1. 互补/冗余矩阵
2. 角色化精简组合方案
3. 互斥检测 + 安装顺序 + Mermaid依赖图

</domain>

<decisions>
## Implementation Decisions

### 互补分析
- **D-01:** 分析维度 — 按功能类别（检索/写作/分析/医学/工具/引用/图表）分组分析
- **D-02:** 分析范围 — 每个类别内两两对比，覆盖全面
- **D-03:** 分析方法 — 功能互补性评估 + 包含关系检测

### 冗余检测
- **D-04:** 双重检测机制
  - 阈值差异：DepthScore ≥ 1.5的同功能skill，弱者冗余 → EXCLUDE建议
  - 功能重叠：>80%功能重合的pair，标记冗余候选
- **D-05:** 冗余处理 — 强者保留，弱者标记为冗余备选

### 组合方案
- **D-06:** 输出形式 — 角色化精简组合（每个角色1-2个，形成5-7人核心团队）
- **D-07:** 角色定义 — 文献检索/数据分析/论文写作/图表生成/投稿润色/综合工具

### 互斥检测
- **D-08:** 输出内容 — 互斥skill pair + 建议安装顺序 + Mermaid依赖图
- **D-09:** 依赖关系 — 包括强制依赖（必须同时用）和顺序依赖（安装顺序）

</decisions>

<canonical_refs>
## Canonical References

### Phase 2 评测结果
- `.planning/phases/02-安全初筛与功能评测/02-MATRIX.md` — 39个仓库评分矩阵
- `.planning/phases/02-安全初筛与功能评测/02-RECOMMENDATIONS.md` — 分层推荐组合
- `.planning/phases/02-安全初筛与功能评测/02-SCORES-SAMPLE.tsv` — 评分数据（22列）

### 项目文档
- `.planning/ROADMAP.md` — Phase 3定义
- `.planning/PROJECT.md` — 项目目标
- `.planning/REQUIREMENTS.md` — 需求定义

</canonical_refs>

<codebase_context>
## 评测数据基础

### AUTO-RECOMMEND (25个)
| Repo | Domain | DepthScore | Integration | Coverage_Stages |
|------|--------|------------|-------------|-----------------|
| scientific-agent-skills | 数据分析 | 4.5 | 20 | 文献,分析,写作 |
| medsci-skills | 医学专用 | 4.5 | 18 | 文献,分析,写作,投稿 |
| academic-research-skills | 学术研究 | 4.5 | 11 | 文献,分析,写作,审稿,修订,发表 |
| academic-writing-skills | 学术写作 | 4.0 | 18 | 写作 |
| nature-skills | Nature系列 | 4.0 | 18 | 写作,投稿 |
| paper-plot-skills | 图表生成 | 4.0 | 18 | 分析 |
| AI-Research-SKILLs | 科研工具 | 4.0 | 19 | 文献,分析,写作 |
| deepxiv_sdk | 文献检索 | 4.0 | 13 | 搜索,评估,渐进式阅读 |
| ... |

### CANDIDATE (14个)
| Repo | Domain | DepthScore | Integration |
|------|--------|------------|-------------|
| ARIS | 文献检索 | 3.5 | 17 |
| AI-Powered-Literature-Review-Skills | 文献综述 | 3.5 | 15 |
| citation-assistant | 引用管理 | 3.5 | 16 |
| ... |

</code_context>

<specifics>
## Specific Ideas

- 互补分析按功能类别分组，检索类7个、写作类6个、分析类5个
- 冗余检测：阈值差异（≥1.5）+ 功能重叠（>80%）
- 组合方案：角色化精简，5-7个核心skill形成团队
- 互斥检测：pair列表 + 安装顺序 + Mermaid依赖图

</specifics>

<deferred>
## Deferred Ideas

- 自动化互补度计算（未来可集成到评分体系）
- 动态组合推荐（基于用户研究类型自动推荐组合）

</deferred>

---

*Phase: 3-组合分析*
