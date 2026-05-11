# 03-REDUNDANCY-REPORT: 冗余检测报告

**Generated:** 2026-05-11
**Source:** 03-MATRIX-GROUPS.md, 02-SCORES-SAMPLE.tsv

---

## 冗余检测方法

1. **阈值差异检测:** 同类别DepthScore差距≥1.5，弱者标记为冗余候选
2. **功能重叠检测:** Coverage_Stages高度重叠(>80%相同)

---

## Category 1: 文献检索类 (7个)

### 阈值差异检测
| Skill A | Skill B | DepthScore A | DepthScore B | 差距 | 冗余候选 |
|---------|---------|--------------|--------------|------|----------|
| deepxiv_sdk (4.0) | ARIS (3.5) | 4.0 | 3.5 | 0.5 | 否 |
| deepxiv_sdk (4.0) | AI-Powered-Lit (3.5) | 4.0 | 3.5 | 0.5 | 否 |
| deepxiv_sdk (4.0) | scholar_mcp_server (3.5) | 4.0 | 3.5 | 0.5 | 否 |

**结论:** 文献检索类无阈值差异冗余（最大差距仅0.5）

### 功能重叠检测
| Skill A | Skill B | 重叠Coverage | 重叠度 | 冗余候选 |
|---------|---------|--------------|--------|----------|
| Academix | openalex-mcp | 都是引文分析 | 高 | 候选 |
| research-superpower | AI-Powered-Lit | 都是综述 | 中 | 候选 |

**结论:** Academix和openalex-mcp功能高度重叠

### 冗余建议
| Skill | 建议 | 理由 |
|-------|------|------|
| AI-Powered-Literature-Review-Skills | 降级为备选 | 深度3.5，功能与research-superpower重叠 |
| scholar_mcp_server | 降级为备选 | 深度3.5，与deepxiv_sdk功能重叠 |

---

## Category 2: 学术写作类 (6个)

### 阈值差异检测
| Skill A | Skill B | DepthScore A | DepthScore B | 差距 | 冗余候选 |
|---------|---------|--------------|--------------|------|----------|
| academic-writing-skills (4.0) | Master-cai (3.5) | 4.0 | 3.5 | 0.5 | 否 |
| academic-writing-skills (4.0) | Claude-Scientific-Skills (3.5) | 4.0 | 3.5 | 0.5 | 否 |
| Nature-Paper-Skills (4.0) | Master-cai (3.5) | 4.0 | 3.5 | 0.5 | 否 |

**结论:** 学术写作类无阈值差异冗余（最大差距仅0.5）

### 功能重叠检测
| Skill A | Skill B | 重叠Coverage | 重叠度 | 冗余候选 |
|---------|---------|--------------|--------|----------|
| academic-writing-skills | Nature-Paper-Skills | 都是写作 | 高 | 候选 |
| claude-scientific-writer | Nature-Paper-Skills | 都是写作 | 高 | 候选 |

**结论:** 多个skill都专注"学术写作"，功能高度相似

### 冗余建议
| Skill | 建议 | 理由 |
|-------|------|------|
| Master-cai/Research-Paper-Writing-Skills | 降级为备选 | 深度3.5，领域专精(ML/CV/NLP)，与其他写作skill重叠 |
| nicholash84/Claude-Scientific-Skills | 排除候选 | 深度3.5，信息有限，深度存疑 |

---

## Category 3: 数据分析类 (5个)

### 阈值差异检测
| Skill A | Skill B | DepthScore A | DepthScore B | 差距 | 冗余候选 |
|---------|---------|--------------|--------------|------|----------|
| scientific-agent-skills (4.5) | scientify (4.0) | 4.5 | 4.0 | 0.5 | 否 |
| medsci-skills (4.5) | scientify (4.0) | 4.5 | 4.0 | 0.5 | 否 |

**结论:** 数据分析类无阈值差异冗余（最大差距仅0.5）

### 功能重叠检测
| Skill A | Skill B | 重叠Coverage | 重叠度 | 冗余候选 |
|---------|---------|--------------|--------|----------|
| scientific-agent-skills | scientify | 都是通用分析 | 高 | 候选 |
| medsci-skills | get-research-done | 都是医学相关 | 中 | 候选 |

**结论:** scientific-agent-skills和scientify功能高度重叠

### 冗余建议
| Skill | 建议 | 理由 |
|-------|------|------|
| scientify | 降级为备选 | 与scientific-agent-skills功能高度重叠，但专注OpenClaw生态 |

---

## Category 4: 图表生成类 (4个)

### 阈值差异检测
| Skill A | Skill B | DepthScore A | DepthScore B | 差距 | 冗余候选 |
|---------|---------|--------------|--------------|------|----------|
| paper-plot-skills (4.0) | design-doc-mermaid (3.5) | 4.0 | 3.5 | 0.5 | 否 |

**结论:** 图表生成类无阈值差异冗余

### 功能重叠检测
| Skill A | Skill B | 重叠Coverage | 重叠度 | 冗余候选 |
|---------|---------|--------------|--------|----------|
| paper-plot-skills | nature-skills | 都是图表 | 高 | 候选 |

**结论:** paper-plot-skills和nature-skills功能相似，但nature专注Nature期刊

### 冗余建议
| Skill | 建议 | 理由 |
|-------|------|------|
| design-doc-mermaid | 降级为备选 | 专注技术文档图表，与学术图表生成功能重叠度低但深度3.5 |

---

## Category 5: 引用管理类 (3个)

### 阈值差异检测
| Skill A | Skill B | DepthScore A | DepthScore B | 差距 | 冗余候选 |
|---------|---------|--------------|--------------|------|----------|
| yy/claude-scholar (4.0) | citation-assistant (3.5) | 4.0 | 3.5 | 0.5 | 否 |

**结论:** 引用管理类无阈值差异冗余

### 功能重叠检测
| Skill A | Skill B | 重叠Coverage | 重叠度 | 冗余候选 |
|---------|---------|--------------|--------|----------|
| yy/claude-scholar | openalex-research-mcp | 都是引文相关 | 高 | 候选 |
| citation-assistant | openalex-research-mcp | 都是引文相关 | 高 | 候选 |

**结论:** openalex-research-mcp与多个引用管理skill功能重叠

### 冗余建议
| Skill | 建议 | 理由 |
|-------|------|------|
| openalex-research-mcp | 降级为备选 | 与yy/claude-scholar和citation-assistant功能高度重叠 |

---

## Category 6: 科研工具类 (4个)

### 阈值差异检测
| Skill A | Skill B | DepthScore A | DepthScore B | 差距 | 冗余候选 |
|---------|---------|--------------|--------------|------|----------|
| everything-claude-code (4.5) | research-workflow-assistant (3.0) | 4.5 | 3.0 | 1.5 | **是** |

**结论:** research-workflow-assistant深度3.0，与everything-claude-code差距1.5

### 功能重叠检测
| Skill A | Skill B | 重叠Coverage | 重叠度 | 冗余候选 |
|---------|---------|--------------|--------|----------|
| AI-Research-SKILLs | scientify | 都是OpenClaw相关 | 中 | 候选 |
| anthropics/skills | everything-claude-code | 都是工具优化 | 中 | 候选 |

**结论:** AI-Research-SKILLs和scientify功能相似（OpenClaw生态）

### 冗余建议
| Skill | 建议 | 理由 |
|-------|------|------|
| research-workflow-assistant | **排除候选** | 深度3.0，与everything-claude-code差距1.5，建议排除 |

---

## Category 7: 医学研究类 (4个)

### 阈值差异检测
| Skill A | Skill B | DepthScore A | DepthScore B | 差距 | 冗余候选 |
|---------|---------|--------------|--------------|------|----------|
| medsci-skills (4.5) | beita6969/ScienceClaw (3.5) | 4.5 | 3.5 | 1.0 | 否 |

**结论:** 医学研究类无阈值差异冗余（最大差距1.0）

### 功能重叠检测
| Skill A | Skill B | 重叠Coverage | 重叠度 | 冗余候选 |
|---------|---------|--------------|--------|----------|
| medsci-skills | beita6969/ScienceClaw | 都是医学相关 | 中 | 候选 |

**结论:** medsci-skills和beita6969/ScienceClaw功能部分重叠

### 冗余建议
| Skill | 建议 | 理由 |
|-------|------|------|
| beita6969/ScienceClaw | 降级为备选 | fork版本，与medsci-skills功能重叠，有同步风险 |

---

## 全局冗余总结

### 应排除/降级的Skill

| Skill | 当前分类 | 建议 | 原因 |
|-------|----------|------|------|
| research-workflow-assistant | CANDIDATE | **排除** | 深度3.0，与everything-claude-code差距1.5 |
| nicholash84/Claude-Scientific-Skills | CANDIDATE | **排除** | 信息有限，深度存疑 |
| scientify | AUTO-RECOMMEND | 降级为备选 | 与scientific-agent-skills功能高度重叠 |
| beita6969/ScienceClaw | CANDIDATE | 降级为备选 | fork版本，有同步风险 |
| openalex-research-mcp | AUTO-RECOMMEND | 降级为备选 | 与引用管理类skill功能高度重叠 |

### 保留的AUTO-RECOMMEND

| Skill | 保留理由 |
|-------|----------|
| deepxiv_sdk | 文献检索专项，渐进式阅读独特 |
| academic-writing-skills | 通用学术写作，多格式支持 |
| scientific-agent-skills | 通用分析最高分(4.5)，覆盖最广(20) |
| medsci-skills | 医学专项最高分(4.5)，PRISMA/STROBE合规 |
| paper-plot-skills | 论文图表专项，9种真实论文样式 |
| AI-Research-SKILLs | 科研工具库最高分(19) |
| nature-skills | Nature期刊专项，18分 |
