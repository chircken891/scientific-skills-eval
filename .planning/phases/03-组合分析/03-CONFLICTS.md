# 03-CONFLICTS: 互斥检测报告

**Generated:** 2026-05-11
**Source:** 03-MATRIX.md, 02-MATRIX.md

---

## 互斥检测方法

1. **功能完全重叠互斥:** 同名Function1或Coverage_Stages完全相同
2. **依赖冲突互斥:** Integration_冲突风险≥4的pair
3. **阈值差异互斥:** DepthScore差距≥1.5

---

## 检测结果

### 1. 功能完全重叠互斥

| Skill A | Skill B | 重叠类型 | 冲突原因 |
|---------|---------|----------|----------|
| scientify | scientific-agent-skills | 通用分析 | 都是通用数据分析，Coverage_Stages高度重叠 |
| openalex-research-mcp | citation-assistant | 引用管理 | 都是引文分析，功能高度重叠 |
| academic-writing-skills | Nature-Paper-Skills | 学术写作 | 都是学术写作，功能相似 |

### 2. 依赖冲突互斥

| Skill A | Skill B | 冲突风险 | 冲突原因 |
|---------|---------|----------|----------|
| ARIS | deepxiv_sdk | 高 | ARIS包含完整文献检索流程，与deepxiv功能部分重叠 |
| nature-skills | paper-plot-skills | 中 | 都做图表生成，但专注领域不同 |

### 3. 阈值差异互斥

| Skill A | Skill B | DepthScore差距 | 建议 |
|---------|---------|----------------|------|
| everything-claude-code | research-workflow-assistant | 1.5 | research-workflow-assistant应排除，保留everything-claude-code |
| scientific-agent-skills | scientify | 0.5 | 无需互斥，两者互补 |

---

## 互斥Pair总结

### 硬互斥（不可同时安装）

| Skill A | Skill B | 类型 | 原因 | 建议 |
|---------|---------|------|------|------|
| research-workflow-assistant | everything-claude-code | 阈值差异 | DepthScore差距1.5 | 排除research-workflow-assistant |
| nicholash84/Claude-Scientific-Skills | academic-writing-skills | 功能重叠 | 都是写作，信息有限 | 排除nicholash84 |

### 软互斥（可二选一）

| Skill A | Skill B | 类型 | 建议选择 |
|---------|---------|------|----------|
| scientify | scientific-agent-skills | 功能重叠 | scientify（若专注OpenClaw生态） |
| openalex-research-mcp | citation-assistant | 功能重叠 | citation-assistant（专注引用管理） |
| deepxiv_sdk | ARIS | 功能重叠 | deepxiv_sdk（专注阅读体验） |

### 无互斥（可同时安装）

| Skill A | Skill B | 互补类型 |
|---------|---------|----------|
| deepxiv_sdk | scientific-agent-skills | 检索+分析互补 |
| academic-writing-skills | Paper-Polish-Workflow-skill | 写作+润色分工 |
| scientific-agent-skills | paper-plot-skills | 分析+可视化互补 |
| AI-Research-SKILLs | medsci-skills | 工具+医学专项互补 |

---

## 冲突回避建议

### 冲突1: scientify vs scientific-agent-skills

**冲突:** 都是通用分析工具，功能高度重叠

**回避方案:**
- 方案A: 安装scientific-agent-skills（深度4.5 vs 4.0）
- 方案B: 安装scientify（若专注OpenClaw生态）
- 不可同时安装

### 冲突2: deepxiv_sdk vs ARIS

**冲突:** 都是文献检索工具

**回避方案:**
- 方案A: 安装deepxiv_sdk（专注渐进式阅读体验）
- 方案B: 安装ARIS（覆盖全流程：文献→分析→写作→投稿）
- 可考虑同时安装（专注不同阶段）

### 冲突3: paper-plot-skills vs nature-skills

**冲突:** 都做图表生成

**回避方案:**
- 方案A: 安装paper-plot-skills（专注论文图表）
- 方案B: 安装nature-skills（专注Nature期刊图表+投稿）
- 不可同时安装（功能高度相似）

---

## 推荐的互斥规则

1. **排除列表:** research-workflow-assistant, nicholash84/Claude-Scientific-Skills
2. **二选一:** scientify OR scientific-agent-skills, deepxiv_sdk OR ARIS, paper-plot-skills OR nature-skills
3. **可同时安装:** academic-writing-skills + Paper-Polish-Workflow-skill, scientific-agent-skills + medsci-skills
