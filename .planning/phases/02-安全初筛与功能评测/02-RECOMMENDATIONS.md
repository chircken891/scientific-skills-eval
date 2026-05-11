# 推荐组合方案

**来源:** Phase 02 安全初筛与功能评测
**日期:** 2026-05-11
**有效候选:** 25个 AUTO-RECOMMEND + 14个 CANDIDATE (安全APPROVED)

---

## 筛选标准

1. **安全第一:** 仅纳入SecurityVerdict=APPROVED的仓库（全部39个均通过）
2. **阈值分类:** AUTO-RECOMMEND > CANDIDATE
3. **集成分数:** Integration_小计更高的优先
4. **覆盖多样性:** 优先覆盖不同科研阶段
5. **医学适配:** 流行病学/生物统计学/肿瘤学优先

---

## Tier 1: 核心组合 (5-7个)

覆盖最核心科研流程，必装。

| Repo | Domain | DepthScore | Integration | Coverage_Stages | 入选理由 |
|------|--------|------------|-------------|----------------|----------|
| **scientific-agent-skills** | 数据分析 | 4.5 | 20/25 | 文献,分析,写作 | 最高综合评分，135个skill覆盖20+领域，100+数据库查询能力 |
| **medsci-skills** | 医学专用 | 4.5 | 18/25 | 文献,分析,写作,投稿 | 医学研究专项，PRISMA/STROBE合规，流行病学和生物统计学 |
| **academic-writing-skills** | 学术写作 | 4.0 | 18/25 | 写作 | LaTeX/Typst多格式，中英文模板，多轮修订，审稿清单 |
| **paper-plot-skills** | 图表生成 | 4.0 | 18/25 | 分析 | 9种真实论文图表样式，plot-from-image能力 |
| **deepxiv_sdk** | 文献检索 | 4.0 | 13/25 | 搜索,评估,渐进式阅读 | 多数据库(arXiv/bioRxiv/medRxiv/PMC)聚合，语义搜索 |

**核心组合覆盖:**
- 科研阶段: 文献检索 → 数据分析 → 论文写作 → 图表制作 → 投稿
- 功能领域: 通用科研 + 医学专项 + 学术写作 + 可视化
- 医学场景: ✅ 流行病学(medsci-skills) ✅ 生物统计学(medsci-skills) ✅ 医学研究(medsci-skills)

---

## Tier 2: 扩展组合 (8-10个)

增强特定能力的补充选择。

### 高集成分数推荐

| Repo | Domain | DepthScore | Integration | 补充价值 |
|------|--------|------------|-------------|----------|
| **AI-Research-SKILLs** | 科研工具 | 4.0 | 19/25 | 98个AI科研skill，多agent支持 |
| **nature-skills** | Nature系列 | 4.0 | 18/25 | Nature期刊全套工具，图表+润色+审稿回复 |
| **Paper-Polish-Workflow-skill** | 学术写作 | 4.0 | 15/25 | 16个润色skill，中英翻译，去AI化 |
| **scientify** | OpenClaw研究 | 4.0 | 15/25 | 5700+ OpenClaw skills，9大领域 |
| **claude-scientific-writer** | 科学写作 | 4.0 | 14/25 | Nature/Science/NeurIPS专项，基金申请书 |

### 医学研究增强

| Repo | Domain | DepthScore | Integration | 补充价值 |
|------|--------|------------|-------------|----------|
| **get-research-done** | 生物医学研究 | 4.0 | 13/25 | 生物医学全生命周期 |
| **MedgeClaw** | 生物医药AI | 4.0 | 14/25 | RNA-seq/药物发现/临床分析 |

### 文献检索增强

| Repo | Domain | DepthScore | Integration | 补充价值 |
|------|--------|------------|-------------|----------|
| **Academix** | 学术检索 | 4.0 | 13/25 | 5大数据库聚合，DBLP优先CS论文 |
| **openalex-research-mcp** | OpenAlex研究 | 4.0 | 13/25 | 240M+作品，UTD24/FT50期刊预设 |
| **research-superpower** | 文献综述 | 4.0 | 9/25 | 8步综述流程，智能筛选 |

---

## Tier 3: 按领域推荐

### 文献检索与综述

| Repo | DepthScore | Integration | 适用场景 |
|------|-----------|-------------|----------|
| **deepxiv_sdk** | 4.0 | 13/25 | 多数据库聚合，渐进式阅读 |
| **Academix** | 4.0 | 13/25 | 5大数据库，DBLP优先 |
| **openalex-research-mcp** | 4.0 | 13/25 | 240M+作品，期刊预设 |
| **research-superpower** | 4.0 | 9/25 | 8步综述，智能筛选 |
| ARIS | 3.5 | 17/25 | 全流程闭环 |
| AI-Powered-Literature-Review-Skills | 3.5 | 15/25 | 系统综述工作流 |

### 数据分析与统计

| Repo | DepthScore | Integration | 适用场景 |
|------|-----------|-------------|----------|
| **scientific-agent-skills** | 4.5 | 20/25 | 通用统计分析，20+领域 |
| **medsci-skills** | 4.5 | 18/25 | 医学统计，meta分析 |
| get-research-done | 4.0 | 13/25 | 生物医学数据分析 |

### 学术写作与润色

| Repo | DepthScore | Integration | 适用场景 |
|------|-----------|-------------|----------|
| **academic-writing-skills** | 4.0 | 18/25 | 多格式模板，多轮修订 |
| **nature-skills** | 4.0 | 18/25 | Nature期刊全套 |
| **Paper-Polish-Workflow-skill** | 4.0 | 15/25 | 翻译+去AI化 |
| **claude-scientific-writer** | 4.0 | 14/25 | 多期刊+基金申请书 |

### 图表生成

| Repo | DepthScore | Integration | 适用场景 |
|------|-----------|-------------|----------|
| **paper-plot-skills** | 4.0 | 18/25 | 论文图表，plot-from-image |
| **nature-skills** | 4.0 | 18/25 | Nature图表，发表级别 |

### 医学研究专用

| Repo | DepthScore | Integration | 适用场景 |
|------|-----------|-------------|----------|
| **medsci-skills** | 4.5 | 18/25 | PRISMA/STROBE，流行病学 |
| **get-research-done** | 4.0 | 13/25 | 生物医学全流程 |
| **MedgeClaw** | 4.0 | 14/25 | RNA-seq，药物发现 |
| luwill/research-skills | 4.0 | 13/25 | 医学影像综述 |

---

## 安装优先级

### P0 — 立即安装（核心必备）

1. **scientific-agent-skills** — 数据分析基础，20+领域覆盖
2. **medsci-skills** — 医学研究必备，PRISMA/STROBE合规
3. **academic-writing-skills** — 学术写作核心，多格式支持
4. **paper-plot-skills** — 图表生成必备
5. **deepxiv_sdk** — 文献检索基础

### P1 — 尽快安装（强烈推荐）

1. **AI-Research-SKILLs** — 科研工具库，多agent支持
2. **nature-skills** — Nature期刊投稿必备
3. **Academix** — 学术检索增强
4. **Paper-Polish-Workflow-skill** — 写作润色增强
5. **openalex-research-mcp** — 引文分析增强

### P2 — 按需安装（增强能力）

1. scientify — OpenClaw科研工作流
2. claude-scientific-writer — 多期刊专项
3. get-research-done — 生物医学增强
4. MedgeClaw — 生物医药增强
5. research-superpower — 系统综述增强
6. anthropics/skills — Skills规范参考

---

## 不推荐仓库记录

以下仓库暂不推荐（可按需评估）：

| Repo | 原因 |
|------|------|
| ComposioHQ/awesome-claude-skills | 目录型，仅索引无实现 |
| Awesome-Agent-Skills-for-Empirical-Research | 目录型，23,000+ skills需人工筛选 |
| research-workflow-assistant | 基础能力，详情有限 |
| dev-scholar | 4 stars，维护状态不明 |
| bengous/claude-code-plugins | 非学术专注，开发工作流为主 |
| SpillwaveSolutions/design-doc-mermaid | 技术图表，学术深度有限 |
| nicholash84/Claude-Scientific-Skills | 信息有限，深度存疑 |
| Master-cai/Research-Paper-Writing-Skills | 领域专精，ML/CV/NLP有限 |
| scholar_mcp_server | 学术检索，与Academix重叠 |
| ResearchMCP | Perplexity研究，非深度学术 |
| beita6969/ScienceClaw | fork，同步风险 |

---

## 推荐组合总结

### 医学流行病学研究推荐组合

| 优先级 | Repo | 功能 |
|--------|------|------|
| 必装 | scientific-agent-skills | 数据分析 |
| 必装 | medsci-skills | 医学研究+PRISMA |
| 必装 | academic-writing-skills | 学术写作 |
| 必装 | paper-plot-skills | 图表生成 |
| 必装 | deepxiv_sdk | 文献检索 |
| 推荐 | AI-Research-SKILLs | 科研工具库 |
| 推荐 | Academix | 学术检索增强 |
| 推荐 | nature-skills | 投稿增强 |

### 通用AI/ML研究推荐组合

| 优先级 | Repo | 功能 |
|--------|------|------|
| 必装 | scientific-agent-skills | 数据分析 |
| 必装 | academic-writing-skills | 学术写作 |
| 必装 | paper-plot-skills | 图表生成 |
| 必装 | deepxiv_sdk | 文献检索 |
| 必装 | AI-Research-SKILLs | 科研工具库 |
| 推荐 | everything-claude-code | Agent优化 |
| 推荐 | Paper-Polish-Workflow-skill | 润色增强 |
| 推荐 | scientify | OpenClaw工作流 |

---

*Recommendations generated: 2026-05-11*
*Source: Phase 02 evaluation of 39 repositories*
