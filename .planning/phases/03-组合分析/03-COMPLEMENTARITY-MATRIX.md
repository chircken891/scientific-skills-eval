# 03-COMPLEMENTARITY-MATRIX: 互补矩阵

**Generated:** 2026-05-11
**Source:** 03-MATRIX-GROUPS.md

---

## 互补性评估标准

- **互补度(1-5):** 5=完美互补，1=完全重合
- **深度补充:** DepthScore差距≥1.0时标记
- **覆盖补充:** Coverage_Stages无重叠时标记

---

## Category 1: 文献检索类 (7个)

### Pairwise Complementarity

| Skill A | Skill B | 互补度 | 深度补充 | 覆盖补充 | 互补说明 |
|---------|---------|--------|----------|----------|----------|
| deepxiv_sdk | Academix | 4 | - | - | 两者都是文献检索，deepxiv专注渐进式阅读，Academix专注引文分析，互补性中等 |
| deepxiv_sdk | openalex-mcp | 4 | - | - | deepxiv专注阅读体验，openalex专注引文网络，互补性中等 |
| deepxiv_sdk | research-superpower | 3 | - | - | 都做文献综述，research-superpower的8步流程更系统，互补度较低 |
| deepxiv_sdk | ARIS | 4 | - | ✓ | ARIS覆盖全流程(文献→分析→写作→投稿)，deepxiv专注检索，互补性强 |
| deepxiv_sdk | AI-Powered-Lit | 3 | - | - | 都是综述工具，互补度较低 |
| deepxiv_sdk | scholar_mcp_server | 3 | - | - | 都是检索工具，互补度较低 |
| Academix | openalex-mcp | 4 | - | - | Academix专注引文分析，openalex专注引文网络分析，功能高度相似，互补度较低 |
| Academix | research-superpower | 4 | - | ✓ | Academix专注检索+引文，research-superpower专注综述，互补性强 |
| Academix | ARIS | 4 | - | ✓ | Academix专注检索，ARIS覆盖全流程，互补性强 |
| Academix | AI-Powered-Lit | 3 | - | - | 都是综述相关，互补度较低 |
| Academix | scholar_mcp_server | 3 | - | - | 都是检索工具，互补度较低 |
| openalex-mcp | research-superpower | 4 | - | ✓ | openalex专注引文，research-superpower专注综述，互补性强 |
| openalex-mcp | ARIS | 4 | - | ✓ | openalex专注引文，ARIS覆盖全流程，互补性强 |
| openalex-mcp | AI-Powered-Lit | 3 | - | - | 都是综述相关，互补度较低 |
| openalex-mcp | scholar_mcp_server | 3 | - | - | 都是检索工具，互补度较低 |
| research-superpower | ARIS | 4 | - | ✓ | research-superpower专注综述，ARIS覆盖全流程，互补性强 |
| research-superpower | AI-Powered-Lit | 4 | - | - | 都是综述工具，8步流程vs多数据库并行，互补性中等 |
| research-superpower | scholar_mcp_server | 3 | - | - | 都是检索相关，互补度较低 |
| ARIS | AI-Powered-Lit | 3 | - | - | 都是综述工具，ARIS功能更全，互补度较低 |
| ARIS | scholar_mcp_server | 3 | - | - | 都是检索相关，互补度较低 |
| AI-Powered-Lit | scholar_mcp_server | 3 | - | - | 都是检索相关，互补度较低 |

### 关键发现
- **高度互补对:** deepxiv_sdk+ARIS, Academix+research-superpower, openalex-mcp+ARIS (互补度4+，覆盖互补)
- **功能重叠对:** Academix+openalex-mcp (都是引文分析)
- **推荐组合:** deepxiv_sdk + research-superpower (检索+综述分工明确)

---

## Category 2: 学术写作类 (6个)

### Pairwise Complementarity

| Skill A | Skill B | 互补度 | 深度补充 | 覆盖补充 | 互补说明 |
|---------|---------|--------|----------|----------|----------|
| academic-writing-skills | Nature-Paper-Skills | 4 | - | - | 通用学术写作vs Nature专精，功能相似度高，互补性中等 |
| academic-writing-skills | claude-scientific-writer | 4 | - | - | 都是学术写作，claude-scientific-writer支持更多期刊格式 |
| academic-writing-skills | Paper-Polish | 4 | - | ✓ | academic-writing专注写作，Paper-Polish专注润色，互补性强 |
| academic-writing-skills | Master-cai | 4 | - | - | 都是写作，Master-cai专注ML/CV/NLP领域 |
| academic-writing-skills | Claude-Scientific-Skills | 3 | - | - | 都是写作，信息有限，互补度较低 |
| Nature-Paper-Skills | claude-scientific-writer | 4 | - | - | 都是期刊写作，Nature vs Nature/Science/NeurIPS |
| Nature-Paper-Skills | Paper-Polish | 3 | - | - | 都是写作相关，互补度较低 |
| Nature-Paper-Skills | Master-cai | 4 | - | - | 都是写作，Nature vs ML/CV/NLP |
| Nature-Paper-Skills | Claude-Scientific-Skills | 3 | - | - | 都是写作，互补度较低 |
| claude-scientific-writer | Paper-Polish | 4 | - | ✓ | claude-scientific-writer专注写作，Paper-Polish专注润色，互补性强 |
| claude-scientific-writer | Master-cai | 4 | - | - | 都是写作，claude-scientific-writer覆盖更广 |
| claude-scientific-writer | Claude-Scientific-Skills | 3 | - | - | 都是写作，互补度较低 |
| Paper-Polish | Master-cai | 3 | - | - | 都是写作相关，互补度较低 |
| Paper-Polish | Claude-Scientific-Skills | 3 | - | - | 都是写作相关，互补度较低 |
| Master-cai | Claude-Scientific-Skills | 3 | - | - | 都是写作，互补度较低 |

### 关键发现
- **高度互补对:** academic-writing-skills+Paper-Polish, claude-scientific-writer+Paper-Polish (写作+润色分工)
- **功能重叠对:** academic-writing-skills+Nature-Paper-Skills (都是学术写作)
- **推荐组合:** academic-writing-skills + Paper-Polish-Workflow-skill (完整写作+润色流程)

---

## Category 3: 数据分析类 (5个)

### Pairwise Complementarity

| Skill A | Skill B | 互补度 | 深度补充 | 覆盖补充 | 互补说明 |
|---------|---------|--------|----------|----------|----------|
| scientific-agent-skills | medsci-skills | 4 | ✓ | ✓ | 通用分析vs医学专项，深度差异0.5，互补性强 |
| scientific-agent-skills | get-research-done | 4 | - | ✓ | 通用分析vs生物医学专项，互补性强 |
| scientific-agent-skills | ScienceClaw | 4 | - | - | 都是通用分析工具，互补度中等 |
| scientific-agent-skills | scientify | 4 | - | - | 都是通用分析工具，scientify专注OpenClaw生态 |
| medsci-skills | get-research-done | 4 | - | ✓ | 都是医学相关，medsci专注PRISMA/STROBE合规，get-research-done专注全流程 |
| medsci-skills | ScienceClaw | 4 | - | ✓ | 医学专项vs20+学科通用，互补性强 |
| medsci-skills | scientify | 4 | - | - | 都是分析工具，互补度中等 |
| get-research-done | ScienceClaw | 3 | - | - | 都是分析工具，功能相似度高 |
| get-research-done | scientify | 3 | - | - | 都是分析工具，功能相似度高 |
| ScienceClaw | scientify | 4 | - | - | ScienceClaw专注自进化，scientify专注OpenClaw生态 |

### 关键发现
- **高度互补对:** scientific-agent-skills+medsci-skills (通用+医学专项，深度补充+覆盖补充)
- **功能重叠对:** scientific-agent-skills+scientify (都是通用分析)
- **推荐组合:** scientific-agent-skills + medsci-skills (完整通用+医学覆盖)

---

## Category 4: 图表生成类 (4个)

### Pairwise Complementarity

| Skill A | Skill B | 互补度 | 深度补充 | 覆盖补充 | 互补说明 |
|---------|---------|--------|----------|----------|----------|
| paper-plot-skills | nature-skills | 4 | - | ✓ | paper-plot专注论文图表，nature专注Nature期刊图表，互补性强 |
| paper-plot-skills | design-doc-mermaid | 3 | - | - | 都是图表工具，mermaid专注技术文档 |
| paper-plot-skills | luwill/research-skills | 4 | - | ✓ | paper-plot专注图表，luwill专注综述+幻灯片，互补性强 |
| nature-skills | design-doc-mermaid | 3 | - | - | 都是图表工具，功能相似 |
| nature-skills | luwill/research-skills | 4 | - | ✓ | nature专注期刊图表，luwill专注幻灯片，互补性强 |
| design-doc-mermaid | luwill/research-skills | 3 | - | - | 都是图表工具，功能相似 |

### 关键发现
- **高度互补对:** paper-plot-skills+luwill/research-skills (图表+幻灯片分工)
- **功能重叠对:** paper-plot-skills+nature-skills (都是论文图表，但nature专注Nature期刊)
- **推荐组合:** paper-plot-skills + luwill/research-skills (论文图表+幻灯片完整覆盖)

---

## Category 5: 引用管理类 (3个)

### Pairwise Complementarity

| Skill A | Skill B | 互补度 | 深度补充 | 覆盖补充 | 互补说明 |
|---------|---------|--------|----------|----------|----------|
| yy/claude-scholar | citation-assistant | 4 | - | ✓ | claude-scholar专注引文+LaTeX，citation-assistant专注引用管理，互补性强 |
| yy/claude-scholar | openalex-research-mcp | 3 | - | - | 都是引文相关，功能高度相似 |
| citation-assistant | openalex-research-mcp | 3 | - | - | 都是引文相关，功能高度相似 |

### 关键发现
- **推荐组合:** yy/claude-scholar + citation-assistant (引文+LaTeX vs 引用管理)
- **功能重叠对:** yy/claude-scholar + openalex-research-mcp (都是引文分析)

---

## Category 6: 科研工具类 (4个)

### Pairwise Complementarity

| Skill A | Skill B | 互补度 | 深度补充 | 覆盖补充 | 互补说明 |
|---------|---------|--------|----------|----------|----------|
| AI-Research-SKILLs | anthropics/skills | 4 | - | ✓ | AI-Research专注科研，anthropics专注Skills规范，互补性强 |
| AI-Research-SKILLs | research-workflow-assistant | 4 | - | ✓ | AI-Research专注科研工具，research-workflow专注VS Code |
| AI-Research-SKILLs | everything-claude-code | 4 | - | ✓ | AI-Research专注科研，everything-claude-code专注Agent优化，互补性强 |
| anthropics/skills | research-workflow-assistant | 4 | - | ✓ | anthropics专注Skills规范，research-workflow专注VS Code |
| anthropics/skills | everything-claude-code | 4 | - | ✓ | anthropics专注Skills规范，everything-claude-code专注Agent优化 |
| research-workflow-assistant | everything-claude-code | 4 | - | ✓ | research-workflow专注VS Code，everything-claude-code专注Agent优化 |

### 关键发现
- **高度互补对:** AI-Research-SKILLs + everything-claude-code (科研工具+Agent优化)
- **推荐组合:** AI-Research-SKILLs + anthropics/skills (科研工具+Skills规范)

---

## Category 7: 医学研究类 (4个)

### Pairwise Complementarity

| Skill A | Skill B | 互补度 | 深度补充 | 覆盖补充 | 互补说明 |
|---------|---------|--------|----------|----------|----------|
| medsci-skills | MedgeClaw | 4 | - | ✓ | medsci专注PRISMA/STROBE合规，MedgeClaw专注RNA-seq/药物发现，互补性强 |
| medsci-skills | luwill/research-skills | 4 | - | ✓ | medsci专注流行病学，luwill专注医学影像，互补性强 |
| medsci-skills | beita6969/ScienceClaw | 3 | - | - | medsci专注医学专项，ScienceClaw fork专注专利/临床 |
| MedgeClaw | luwill/research-skills | 4 | - | ✓ | MedgeClaw专注RNA-seq，luwill专注影像，互补性强 |
| MedgeClaw | beita6969/ScienceClaw | 4 | - | ✓ | MedgeClaw专注药物发现，ScienceClaw fork专注专利/临床，互补性强 |
| luwill/research-skills | beita6969/ScienceClaw | 4 | - | ✓ | luwill专注影像，ScienceClaw fork专注专利/临床，互补性强 |

### 关键发现
- **高度互补对:** medsci-skills + MedgeClaw + luwill/research-skills (流行病学+药物发现+医学影像)
- **推荐组合:** medsci-skills + MedgeClaw + luwill/research-skills (医学研究三角覆盖)

---

## 全局互补性总结

### 跨类别高度互补对 (互补度≥4)

| Skill A | Skill B | Category A | Category B | 互补说明 |
|---------|---------|------------|------------|----------|
| deepxiv_sdk | ARIS | 文献检索 | 文献检索 | 专注检索+全流程覆盖 |
| academic-writing-skills | Paper-Polish | 学术写作 | 学术写作 | 写作+润色分工 |
| scientific-agent-skills | medsci-skills | 数据分析 | 数据分析 | 通用+医学专项 |
| paper-plot-skills | luwill/research-skills | 图表生成 | 医学研究 | 图表+幻灯片分工 |
| AI-Research-SKILLs | everything-claude-code | 科研工具 | 科研工具 | 科研工具+Agent优化 |
| medsci-skills | MedgeClaw | 医学研究 | 医学研究 | 流行病学+药物发现 |
