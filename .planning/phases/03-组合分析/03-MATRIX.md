# Phase 03: 互补/冗余矩阵

**Generated:** 2026-05-11
**Phase:** 3-组合分析
**Total Repositories:** 39

---

## 执行摘要

Phase 3分析39个已评测仓库的互补性和冗余度，识别出：
- **7个功能类别**，覆盖文献检索、学术写作、数据分析、图表生成、引用管理、科研工具、医学研究
- **6对高度互补skill组合**（跨类别互补）
- **5个应排除/降级的skill**
- **14个核心skill**推荐保留

---

## 功能类别分组

| 类别 | 数量 | 核心skill | 深度范围 | 集成范围 |
|------|------|-----------|----------|----------|
| 文献检索类 | 7 | deepxiv_sdk | 3.5-4.0 | 9-17 |
| 学术写作类 | 6 | academic-writing-skills | 3.5-4.0 | 10-18 |
| 数据分析类 | 5 | scientific-agent-skills | 4.0-4.5 | 13-20 |
| 图表生成类 | 4 | paper-plot-skills | 3.5-4.0 | 8-18 |
| 引用管理类 | 3 | yy/claude-scholar | 3.5-4.0 | 11-16 |
| 科研工具类 | 4 | AI-Research-SKILLs | 3.0-4.5 | 12-19 |
| 医学研究类 | 4 | medsci-skills | 3.5-4.5 | 13-18 |

---

## 互补矩阵

### Category 1: 文献检索类

| Skill | DepthScore | Integration | 互补评价 |
|-------|-----------|-------------|----------|
| deepxiv_sdk | 4.0 | 13 | 渐进式阅读专项 |
| research-superpower | 4.0 | 9 | 8步综述流程专项 |
| Academix | 4.0 | 13 | 引文分析专项 |
| openalex-mcp | 4.0 | 13 | 引文网络专项 |
| ARIS | 3.5 | 17 | 全流程覆盖(文献→分析→写作→投稿) |
| AI-Powered-Lit | 3.5 | 15 | 多数据库并行检索 |
| scholar_mcp_server | 3.5 | 12 | 轻量级检索 |

**推荐组合:** deepxiv_sdk + ARIS（检索专项+全流程覆盖）

### Category 2: 学术写作类

| Skill | DepthScore | Integration | 互补评价 |
|-------|-----------|-------------|----------|
| academic-writing-skills | 4.0 | 18 | 通用学术写作，多格式支持 |
| Nature-Paper-Skills | 4.0 | 12 | Nature期刊专项 |
| claude-scientific-writer | 4.0 | 14 | Nature/Science/NeurIPS多期刊 |
| Paper-Polish-Workflow-skill | 4.0 | 15 | 润色+去AI化专项 |
| Master-cai | 3.5 | 10 | ML/CV/NLP专项 |
| Claude-Scientific-Skills | 3.5 | 10 | 信息有限 |

**推荐组合:** academic-writing-skills + Paper-Polish-Workflow-skill（写作+润色分工）

### Category 3: 数据分析类

| Skill | DepthScore | Integration | 互补评价 |
|-------|-----------|-------------|----------|
| scientific-agent-skills | 4.5 | 20 | 通用分析最高分 |
| medsci-skills | 4.5 | 18 | 医学专项最高分 |
| get-research-done | 4.0 | 13 | 生物医学全流程 |
| ScienceClaw | 4.0 | 14 | 20+学科自进化 |
| scientify | 4.0 | 15 | OpenClaw生态 |

**推荐组合:** scientific-agent-skills + medsci-skills（通用+医学专项分工）

### Category 4: 图表生成类

| Skill | DepthScore | Integration | 互补评价 |
|-------|-----------|-------------|----------|
| paper-plot-skills | 4.0 | 18 | 论文图表专项 |
| nature-skills | 4.0 | 18 | Nature图表专项 |
| luwill/research-skills | 4.0 | 13 | 综述+幻灯片 |
| design-doc-mermaid | 3.5 | 8 | 技术文档图表 |

**推荐组合:** paper-plot-skills + luwill/research-skills（图表+幻灯片分工）

### Category 5: 引用管理类

| Skill | DepthScore | Integration | 互补评价 |
|-------|-----------|-------------|----------|
| yy/claude-scholar | 4.0 | 11 | 引文+LaTeX检查 |
| citation-assistant | 3.5 | 16 | 引用管理专项 |
| openalex-mcp | 4.0 | 13 | 引文网络分析 |

**推荐组合:** yy/claude-scholar + citation-assistant（引文+引用管理分工）

### Category 6: 科研工具类

| Skill | DepthScore | Integration | 互补评价 |
|-------|-----------|-------------|----------|
| AI-Research-SKILLs | 4.0 | 19 | 科研工具库最高分 |
| everything-claude-code | 4.5 | 17 | Agent优化专项 |
| anthropics/skills | 4.0 | 12 | Skills规范基准 |
| research-workflow-assistant | 3.0 | 13 | VS Code研究助手 |

**推荐组合:** AI-Research-SKILLs + everything-claude-code（科研工具+Agent优化分工）

### Category 7: 医学研究类

| Skill | DepthScore | Integration | 互补评价 |
|-------|-----------|-------------|----------|
| medsci-skills | 4.5 | 18 | 流行病学/生物统计 |
| MedgeClaw | 4.0 | 14 | RNA-seq/药物发现 |
| luwill/research-skills | 4.0 | 13 | 医学影像AI |
| beita6969/ScienceClaw | 3.5 | 14 | ScienceClaw fork |

**推荐组合:** medsci-skills + MedgeClaw + luwill/research-skills（医学研究三角覆盖）

---

## 冗余检测结果

### 应排除的Skill

| Skill | 当前分类 | 排除原因 |
|-------|----------|----------|
| research-workflow-assistant | CANDIDATE | 深度3.0，与everything-claude-code差距1.5 |
| nicholash84/Claude-Scientific-Skills | CANDIDATE | 信息有限，深度存疑 |

### 应降级的Skill

| Skill | 当前分类 | 建议分类 | 降级原因 |
|-------|----------|----------|----------|
| scientify | AUTO-RECOMMEND | CANDIDATE | 与scientific-agent-skills功能高度重叠 |
| beita6969/ScienceClaw | CANDIDATE | EXCLUDE | fork版本，有同步风险 |
| openalex-research-mcp | AUTO-RECOMMEND | CANDIDATE | 与引用管理类skill功能高度重叠 |
| AI-Powered-Lit | CANDIDATE | EXCLUDE | 与research-superpower功能重叠 |
| Master-cai | CANDIDATE | EXCLUDE | ML/CV/NLP专项，与其他写作skill重叠 |

---

## 跨类别高度互补对

| Skill A | Skill B | 类别A | 类别B | 互补说明 |
|---------|---------|-------|-------|----------|
| deepxiv_sdk | medsci-skills | 文献检索 | 数据分析 | 检索+医学分析 |
| academic-writing-skills | nature-skills | 学术写作 | 图表生成 | 写作+Nature图表 |
| scientific-agent-skills | paper-plot-skills | 数据分析 | 图表生成 | 分析+可视化 |
| AI-Research-SKILLs | medsci-skills | 科研工具 | 医学研究 | 工具+医学专项 |

---

## 关键发现

1. **文献检索高度重叠:** 7个文献检索skill中，5个专注引文/综述，功能高度相似
2. **学术写作分工明确:** academic-writing-skills(写作)+Paper-Polish(润色)是最佳组合
3. **数据分析核心突出:** scientific-agent-skills(4.5,20)是数据分析类最高分
4. **医学研究三角覆盖:** medsci-skills+MedgeClaw+luwill覆盖流行病学+药物+影像
5. **应排除2个CANDIDATE:** research-workflow-assistant和nicholash84/Claude-Scientific-Skills

---

## 更新后的评测矩阵

### AUTO-RECOMMEND (建议保留23个)

| Repo | Domain | DepthScore | Integration | 备注 |
|------|--------|-----------|-------------|------|
| scientific-agent-skills | 数据分析 | 4.5 | 20 | 保留 |
| medsci-skills | 医学专用 | 4.5 | 18 | 保留 |
| academic-writing-skills | 学术写作 | 4.0 | 18 | 保留 |
| paper-plot-skills | 图表生成 | 4.0 | 18 | 保留 |
| nature-skills | Nature系列 | 4.0 | 18 | 保留 |
| AI-Research-SKILLs | 科研工具 | 4.0 | 19 | 保留 |
| deepxiv_sdk | 文献检索 | 4.0 | 13 | 保留 |
| ... | ... | ... | ... | ... |

### CANDIDATE (建议降级/新增5个)

| Repo | 原分类 | 建议分类 | 原因 |
|------|--------|----------|------|
| scientify | AUTO-RECOMMEND | CANDIDATE | 与scientific-agent-skills重叠 |
| openalex-research-mcp | AUTO-RECOMMEND | CANDIDATE | 与引用管理skill重叠 |

### EXCLUDE (建议新增2个)

| Repo | 原分类 | 原因 |
|------|--------|------|
| research-workflow-assistant | CANDIDATE | 深度3.0，与everything-claude-code差距1.5 |
| nicholash84/Claude-Scientific-Skills | CANDIDATE | 信息有限，深度存疑 |

---

*Matrix generated: 2026-05-11*
*Source: Phase 2 evaluation (02-SCORES-SAMPLE.tsv)*
