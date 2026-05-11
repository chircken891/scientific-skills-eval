# Phase 02: 横向对比矩阵

**Generated:** 2026-05-11
**Phase:** 02 (安全初筛与功能评测)
**Total Repositories:** 39

---

## 评测统计摘要

| Metric | Count |
|--------|-------|
| 总仓库数 | 39 |
| 安全否决(VETOED) | 0 |
| 推荐(AUTO-RECOMMEND) | 25 |
| 候选(CANDIDATE) | 14 |
| 排除(EXCLUDE) | 0 |

---

## AUTO-RECOMMEND 仓库（DepthScore > 4.0）

按 DepthScore 降序排列，DepthScore相同时按Integration_小计降序排列：

| Repo | Domain | DepthScore | Integration_小计 | Coverage_Stages |
|------|--------|------------|-----------------|---------------|
| scientific-agent-skills | 数据分析 | 4.5 | 20 | 文献,分析,写作 |
| medsci-skills | 医学专用 | 4.5 | 18 | 文献,分析,写作,投稿 |
| Imbad0202/academic-research-skills | 学术研究 | 4.5 | 11 | 文献,分析,写作,审稿,修订,发表 |
| affaan-m/everything-claude-code | Agent优化 | 4.5 | 17 | Agent Harness优化 |
| academic-writing-skills | 学术写作 | 4.0 | 18 | 写作 |
| nature-skills | Nature系列 | 4.0 | 18 | 写作,投稿 |
| paper-plot-skills | 图表生成 | 4.0 | 18 | 分析 |
| AI-Research-SKILLs | 科研工具 | 4.0 | 19 | 文献,分析,写作 |
| Boom5426/Nature-Paper-Skills | 学术写作 | 4.0 | 12 | 写作,图表,修订,投稿 |
| yy/claude-scholar | 引用管理 | 4.0 | 11 | 文献检索,引文管理,LaTeX检查 |
| anthropics/skills | Skills框架 | 4.0 | 12 | 文档,开发,创意,企业 |
| Lylll9436/Paper-Polish-Workflow-skill | 学术写作 | 4.0 | 15 | 翻译,润色,去AI化,审稿 |
| DeepXiv/deepxiv_sdk | 文献检索 | 4.0 | 13 | 搜索,评估,渐进式阅读 |
| K-Dense-AI/claude-scientific-writer | 科学写作 | 4.0 | 14 | 研究搜索,写作,图表 |
| luwill/research-skills | 医学影像 | 4.0 | 13 | 综述,提案,幻灯片 |
| kthorn/research-superpower | 文献综述 | 4.0 | 9 | 8步综述流程 |
| ScienceClaw/ScienceClaw | 自进化研究 | 4.0 | 14 | 20+学科 |
| xjtulyc/MedgeClaw | 生物医药AI | 4.0 | 14 | 生物医药 |
| xingyulu23/Academix | 学术检索 | 4.0 | 13 | 学术检索,引文分析 |
| get-research-done | 生物医学研究 | 4.0 | 13 | 生物医学研究全生命周期 |
| scientify | OpenClaw研究 | 4.0 | 15 | OpenClaw科研工作流 |
| openalex-research-mcp | OpenAlex研究 | 4.0 | 13 | 学术检索,引文分析 |

---

## CANDIDATE 仓库（DepthScore 3.0-4.0）

| Repo | Domain | DepthScore | Integration_小计 | Coverage_Stages |
|------|--------|------------|-----------------|----------------|
| ARIS | 文献检索 | 3.5 | 17 | 文献,分析,写作,投稿 |
| AI-Powered-Literature-Review-Skills | 文献综述 | 3.5 | 15 | 文献 |
| citation-assistant | 引用管理 | 3.5 | 16 | 文献 |
| bengous/claude-code-plugins | 开发工作流 | 3.5 | 14 | 开发工作流 |
| SpillwaveSolutions/design-doc-mermaid | 技术图表 | 3.5 | 8 | 技术文档图表 |
| nicholash84/Claude-Scientific-Skills | 科学技能 | 3.5 | 10 | 通用科学技能 |
| Master-cai/Research-Paper-Writing-Skills | ML/CV/NLP写作 | 3.5 | 10 | ML/CV/NLP论文写作 |
| scholar_mcp_server | 学术检索 | 3.5 | 12 | 学术检索 |
| ResearchMCP | Perplexity研究 | 3.5 | 12 | Perplexity研究 |
| beita6969/ScienceClaw | ScienceClaw Fork | 3.5 | 14 | ScienceClaw fork |
| ComposioHQ/awesome-claude-skills | Skills索引 | 3.0 | 8 | 目录型：500+ Skills |
| Awesome-Agent-Skills-for-Empirical-Research | 社会科学索引 | 3.0 | 6 | 目录型：23,000+ skills |
| research-workflow-assistant | VS Code研究 | 3.0 | 13 | VS Code研究 |
| dev-scholar | 研究加速器 | 3.0 | 10 | 研究工作流加速 |

---

## 阈值分布统计

### AUTO-RECOMMEND 仓库特征
- DepthScore 4.5: 4个（scientific-agent-skills, medsci-skills, academic-research-skills, everything-claude-code）
- DepthScore 4.0: 21个
- 平均Integration: 13.7/25
- 最高Integration: 20（scientific-agent-skills）

### CANDIDATE 仓库特征
- DepthScore 3.5: 10个
- DepthScore 3.0: 4个
- 平均Integration: 11.3/25
- 目录型仓库占4个（ComposioHQ, Awesome-Agent-Skills, research-workflow-assistant, dev-scholar）

---

## 领域覆盖分析

| 领域 | AUTO-RECOMMEND | CANDIDATE |
|------|----------------|-----------|
| 数据分析 | scientific-agent-skills (4.5) | — |
| 医学专用 | medsci-skills (4.5), get-research-done (4.0), MedgeClaw (4.0) | beita6969/ScienceClaw (3.5) |
| 学术研究 | academic-research-skills (4.5) | — |
| Agent优化 | everything-claude-code (4.5) | — |
| 学术写作 | academic-writing-skills (4.0), Paper-Polish (4.0), Nature-Paper (4.0), claude-scientific-writer (4.0) | Master-cai (3.5) |
| 文献检索 | deepxiv_sdk (4.0), research-superpower (4.0), Academix (4.0), openalex-mcp (4.0) | scholar_mcp_server (3.5), ARIS (3.5) |
| 图表生成 | nature-skills (4.0), paper-plot-skills (4.0) | design-doc-mermaid (3.5) |
| 引用管理 | yy/claude-scholar (4.0) | citation-assistant (3.5) |
| 科研工具 | AI-Research-SKILLs (4.0), scientify (4.0), anthropics (4.0) | nicholash84 (3.5) |
| 自进化研究 | ScienceClaw (4.0) | — |
| 医学影像 | luwill/research-skills (4.0) | — |
| Skills索引 | — | awesome-claude-skills (3.0), Awesome-Agent (3.0) |
| 开发工作流 | — | claude-code-plugins (3.5), research-workflow-assistant (3.0), dev-scholar (3.0) |

---

*Matrix generated: 2026-05-11*
