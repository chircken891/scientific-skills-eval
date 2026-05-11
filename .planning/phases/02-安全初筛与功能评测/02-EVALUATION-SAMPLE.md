# Phase 02: 安全初筛与功能评测 — 完整评分卡

**Generated:** 2026-05-11
**Phase:** 02 (安全初筛与功能评测)
**Status:** In Progress
**Total Repositories:** 39 (9 pre-verified + 30 pending)

---

## 说明

本文件包含全部39个科研skill仓库的评测结果。

**来源分类：**
- 来自 Phase 01.5.2 已验证的9个仓库（深度评分已通过源码验证）
- 来自 Phase 1.5 新增的18个仓库（待评分）
- 来自 Phase 1 原有的21个仓库（部分已评分，剩余待评分）

---

## 1. ARIS (Auto-claude-code-research-in-sleep)
**Domain:** 文献检索
**URL:** https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | No PII/medical records access. Skills work with files locally. No credential storage. `.env.example` only contains placeholder names. |
| 权限范围 | PASS | No special permissions requested. Plain Markdown skill files. No package.json with excessive permissions. |
| 网络请求 | PASS | No suspicious external communication. Skills read/write local files only. External model calls go through user-configured API. |
| 依赖来源 | PASS | Uses trusted sources: Anthropic API, OpenAI API, GitHub. No untrusted dependencies. |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)

**Function Selection:** Literature Search, Workflow Orchestration
**Selection Rationale:** Self-declared as research pipeline with multi-stage workflow and literature integration. Two strongest capabilities: literature discovery within research pipeline and cross-stage orchestration.

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Literature Search | 3.0/5 | Source code analysis confirms: single database (arXiv only), simple keyword search via HTTP API, no Boolean operators, no PICO formulation, no quality filtering by venue rank or citation count, no systematic deduplication. Meets rubric 3/5 criteria exactly. |
| Workflow Orchestration | 3.5/5 | Multi-stage pipeline (idea→experiment→paper→rebuttal) with cross-model adversarial review loop. Self-correction via reviewer feedback. Research Wiki for persistent memory. Approx 4-5 major stages with checkpoint-like review gates. |

**DepthScore:** (3.0 + 3.5) / 2 = 3.25 → **3.5/5**
**Threshold Classification:** CANDIDATE (per D-08: 3.0-4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Claude Code集成难度 | 3/5 | Skills directory approach with CLI setup. Research Wiki requires configuration. Moderate complexity. |
| MCP兼容性 | 3/5 | MCP servers directory present. Partial MCP support documented. |
| 冲突风险 | 3/5 | Overlaps with general research skills. Some functionality duplicates other tools. |
| 维护成本 | 5/5 | Active maintenance (v0.4.4, 2026-04-20). 62 skills, regular updates. |
| 上下文依赖 | 3/5 | Research Wiki helps manage context, but multi-stage pipeline can consume significant context. |
| **小计** | **17/25** | |

### Coverage Description (Tier 2)
**Covered Research Stages:** 文献,分析,写作,投稿
**Description:** 覆盖完整科研闭环，从idea生成到实验执行、论文写作到答辩（rebuttal）的全流程自动化。62个skill覆盖AI/ML研究全生命周期，适用于深度学习、自然语言处理等计算研究场景。

---

## 2. AI-Powered-Literature-Review-Skills
**Domain:** 文献综述
**URL:** https://github.com/stephenlzc/AI-Powered-Literature-Review-Skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Browser automation for literature search. No credential storage. API keys via environment variables. |
| 权限范围 | PASS | Standard browser permissions. No excessive system access. Docker containerized execution. |
| 网络请求 | PASS | Searches CNKI, WOS, ScienceDirect, PubMed. Standard academic database access. No suspicious endpoints. |
| 依赖来源 | PASS | Trusted: Docker, standard Python packages. `mcp.json` references standard MCP servers. |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)

**Function Selection:** Literature Review
**Selection Rationale:** Self-declared single focused purpose — systematic literature review. All 8 stages serve this function.

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Literature Review | 3.5/5 | 8-stage systematic review workflow: query analysis → search → dedup → verification → export → analysis → citation → synthesis. Multi-database parallel search (CNKI, WOS, ScienceDirect, PubMed). Quality checks at each iteration stage. GB/T 7714-2015 citation formatting. Approaches but does not fully meet 4/5 criteria: lacks PRISMA-compliant title/abstract screening methodology, risk of bias assessment, and structured evidence table generation. |

**DepthScore:** **3.5/5**
**Threshold Classification:** CANDIDATE (per D-08: 3.0-4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Claude Code集成难度 | 3/5 | Skill-based installation. Docker compose setup required. Moderate complexity. |
| MCP兼容性 | 4/5 | `mcp.json` present. MCP protocol support for browser automation. |
| 冲突风险 | 2/5 | Overlaps with ARIS research-lit and general search skills. Some duplication. |
| 维护成本 | 3/5 | Moderate maintenance. Last update ~2025. Community contributions present. |
| 上下文依赖 | 3/5 | Session-based context management. Moderate context requirements for multi-stage reviews. |
| **小计** | **15/25** | |

### Coverage Description (Tier 2)
**Covered Research Stages:** 文献
**Description:** 专注文献检索与综述阶段，提供8阶段系统综述工作流。支持CNKI、WOS、ScienceDirect、PubMed多数据库并行检索，适用于中英文文献的系统性收集、去重、分析与引用格式化。

---

## 3. academic-writing-skills
**Domain:** 学术写作
**URL:** https://github.com/bahayonghang/academic-writing-skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Local file processing. No external data transmission. Python scripts operate on local files. |
| 权限范围 | PASS | Minimal permissions. Standard Python library access only. |
| 网络请求 | PASS | No network calls in scripts. Document processing is purely local. |
| 依赖来源 | PASS | Trusted: `ruff`, `pyright`, standard Python packages. `uv.lock` for dependency pinning. |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)

**Function Selection:** Academic Writing
**Selection Rationale:** Self-declared writing focus with 6 specialized skills. Strongest evidence in writing support with multi-format, multi-journal capability.

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Academic Writing | 4.0/5 | **VERIFIED:** 6 skills with full LaTeX/Typst support. English venues: IEEE, ACM, Springer, NeurIPS, ICML (5 templates). Chinese templates: thuthesis, pkuthesis, ustcthesis, fduthesis (4 templates). Multi-round revision: quick-audit, deep-review, gate, re-audit (4 modes). Review checklist: ScholarEval 8-dimension scoring, NeurIPS scoring. Matches rubric 4/5: "3+ journal templates, revision support, review checklist." |

**DepthScore:** **4.0/5** (upgraded from 3.5)
**Threshold Classification:** AUTO-RECOMMEND (per D-09: >4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Claude Code集成难度 | 4/5 | Simple skill installation. `just` task runner. Clear documentation. |
| MCP兼容性 | 2/5 | No MCP support documented. Standard skill approach. |
| 冲突风险 | 3/5 | Overlaps with nature-skills polishing. Some redundancy in academic prose. |
| 维护成本 | 4/5 | Active maintenance. `just` CI pipeline. Regular updates. |
| 上下文依赖 | 5/5 | Designed for long documents. Section-aware processing. Low context burden. |
| **小计** | **18/25** | |

### Coverage Description (Tier 2)
**Covered Research Stages:** 写作
**Description:** 覆盖学术写作与后处理阶段，支持LaTeX/Typst/Word多格式学术文档生成。提供paper-audit多视角审阅系统（8维度评分、5层审稿流程），适用于论文初稿撰写、格式转换和写作质量检查。

---

## 4. nature-skills
**Domain:** Nature系列
**URL:** https://github.com/Yuan1z0825/nature-skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Local matplotlib figure generation. No PII access. SVG/PDF output only. |
| 权限范围 | PASS | Standard Python packages. No special permissions. |
| 网络请求 | PASS | No network calls in figure generation. References are local or DOI-based. |
| 依赖来源 | PASS | Trusted: matplotlib, NumPy. Official journal guidelines-based rules. |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)

**Function Selection:** Figure Generation, Journal-Specific Skills
**Selection Rationale:** Two strong capabilities: figure generation with journal-standard formatting and Nature journal compliance expertise.

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Figure Generation | 4.0/5 | Publication-ready matplotlib figures with Nature-specific typography and color schemes. Chart atlas with 10 chart types. Supports 2-3 output formats (SVG, PNG, PDF). Journal-standard axis labeling and typography. Meets rubric 4/5 criteria. |
| Journal-Specific Skills | 4.0/5 | Dedicated Nature-journal skills: figure formatting, paper polishing (12-step workflow), citation formatting, reviewer response, data availability, paper2ppt. Comprehensive single-journal workflow with quality rules enforced. Meets rubric 4/5 criteria. |

**DepthScore:** (4.0 + 4.0) / 2 = 4.0 → **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (per D-09: >4.0 — boundary rule: 4.0 inclusive)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Claude Code集成难度 | 4/5 | Standard skill installation. Clear structure. Good documentation. |
| MCP兼容性 | 2/5 | No MCP support documented. Standard Claude skill approach. |
| 冲突风险 | 3/5 | Some overlap with academic-writing-skills (polishing). Figure skills unique. |
| 维护成本 | 4/5 | Active development. Recent updates (2026). |
| 上下文依赖 | 5/5 | Very low context burden. Figures are self-contained. |
| **小计** | **18/25** | |

### Coverage Description (Tier 2)
**Covered Research Stages:** 写作,投稿
**Description:** 覆盖论文写作、图表制作到投稿回复的Nature期刊发表流程。6个skill专注高影响因子期刊格式规范，提供从数据可视化（figure generation）、论文润色（polishing）到审稿回复（response）的完整工具链。

---

## 5. scientific-agent-skills (K-Dense-AI)
**Domain:** 数据分析
**URL:** https://github.com/K-Dense-AI/scientific-agent-skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Skill documentation only. No execution of user data. 135 skills focus on guidance. |
| 权限范围 | PASS | No package installation required for reading skills. Standard npm package. |
| 网络请求 | PASS | Skills document APIs but don't automatically call them. User controls execution. |
| 依赖来源 | PASS | Trusted: Agent Skills standard. npm distribution. 50+ open source projects acknowledged. |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)

**Function Selection:** Statistical Data Analysis, Research Tool/Framework
**Selection Rationale:** Broadest skill library (135 skills). Two strongest areas: analysis tools and general scientific framework.

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Statistical Data Analysis | 4.0/5 | 70+ optimized Python packages for scientific computing. Skills for statistical analysis, scientific ML, time series, bioinformatics, clinical research. Covers core statistical tests and regression. R/Python integration. |
| Research Tool/Framework | 5.0/5 | 135 skills covering 20+ scientific domains. 100+ database lookup skills for 78+ databases. Modular design with multi-agent support. Production-tested. Exceeds rubric 5/5 criteria. |

**DepthScore:** (4.0 + 5.0) / 2 = 4.5 → **4.5/5**
**Threshold Classification:** AUTO-RECOMMEND (per D-09: >4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Claude Code集成难度 | 4/5 | Standard npx/gh skill installation. Works with multiple agents. |
| MCP兼容性 | 4/5 | Agent Skills standard supports MCP. Works with Cursor, Claude Code, Codex. |
| 冲突风险 | 2/5 | Broad coverage may overlap with many specialized skills. Some redundancy. |
| 维护成本 | 5/5 | Active maintenance. 135 skills, 50+ open source dependencies. |
| 上下文依赖 | 5/5 | Skills are self-contained documents. Very low context burden. |
| **小计** | **20/25** | |

### Coverage Description (Tier 2)
**Covered Research Stages:** 文献,分析,写作
**Description:** 覆盖文献检索、数据分析到论文写作的广泛科研阶段。135个skill涵盖20+科学领域，提供100+数据库查询能力。作为通用科学框架，适用于多学科交叉研究场景。

---

## 6. citation-assistant
**Domain:** 引用管理
**URL:** https://github.com/ZhangNy301/citation-assistant

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Shell scripts for API calls. API keys via environment variables. No PII access. |
| 权限范围 | PASS | Standard curl/jq/sqlite3. No excessive permissions. |
| 网络请求 | PASS | Semantic Scholar API, CrossRef API. Standard academic search endpoints. |
| 依赖来源 | PASS | Trusted: curl, jq, sqlite3. Standard academic APIs. |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)

**Function Selection:** Citation Management
**Selection Rationale:** Single focused purpose — citation management.

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Citation Management | 3.5/5 | Multi-source citation search (Semantic Scholar, CrossRef). BibTeX generation with metadata. Venue quality assessment (CCF, JCR, impact factor lookup). arXiv smart detection. CrossRef fallback on rate limits. Between rubric 3/5 and 4/5. |

**DepthScore:** **3.5/5**
**Threshold Classification:** CANDIDATE (per D-08: 3.0-4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Claude Code集成难度 | 4/5 | Simple shell script-based skill. Easy integration. |
| MCP兼容性 | 2/5 | No MCP support. Standard skill approach. |
| 冲突风险 | 4/5 | Unique citation management. Low overlap with other skills. |
| 维护成本 | 3/5 | Moderate maintenance. Last update ~2025. |
| 上下文依赖 | 3/5 | Lightweight. Low context requirements. |
| **小计** | **16/25** | |

### Coverage Description (Tier 2)
**Covered Research Stages:** 文献
**Description:** 专注引用管理阶段，提供多源文献检索（Semantic Scholar、CrossRef）、BibTeX自动生成和期刊质量评估功能。

---

## 7. paper-plot-skills
**Domain:** 图表生成
**URL:** https://github.com/Trae1ounG/paper-plot-skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | matplotlib scripts generate figures locally. No data transmission. |
| 权限范围 | PASS | Standard Python packages. No special permissions. |
| 网络请求 | PASS | No network calls. Pure local figure generation. |
| 依赖来源 | PASS | Trusted: matplotlib, Pillow. Official paper figure sources. |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)

**Function Selection:** Figure Generation
**Selection Rationale:** Single focused purpose — publication figure generation from data and image reproduction.

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Figure Generation | 4.0/5 | 9 pre-built figure styles from real published papers. plot-from-image capability analyzes and reproduces figures. Publication-ready output at 300 dpi in SVG, PNG formats. Parameter-based style customization. Strong style reproduction from existing paper figures. |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (per D-09: >4.0 — boundary rule: 4.0 inclusive)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Claude Code集成难度 | 4/5 | Simple Python script installation. Clear style documentation. |
| MCP兼容性 | 2/5 | No MCP support. Standard Python approach. |
| 冲突风险 | 3/5 | Some overlap with nature-skills figure capability. |
| 维护成本 | 4/5 | Active development. Community contributions. |
| 上下文依赖 | 5/5 | Self-contained matplotlib scripts. Very low context burden. |
| **小计** | **18/25** | |

### Coverage Description (Tier 2)
**Covered Research Stages:** 分析
**Description:** 覆盖科研结果可视化阶段，提供9种来自真实论文的图表样式。支持从原始数据生成图表和从论文图片复现风格两种模式。

---

## 8. AI-Research-SKILLs (Orchestra-Research)
**Domain:** 科研工具
**URL:** https://github.com/Orchestra-Research/AI-Research-SKILLs

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | npm package with skill documentation. No data access. Skills guide execution. |
| 权限范围 | PASS | Minimal permissions. Standard npm package. |
| 网络请求 | PASS | No automatic network calls. User controls execution. |
| 依赖来源 | PASS | Trusted: npm package. GitHub repository. MIT license. |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)

**Function Selection:** Research Tool/Framework
**Selection Rationale:** Self-declared as AI research orchestration platform. The framework/library capability is the core function.

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Research Tool/Framework | 4.0/5 | 98 skills across 23 categories covering full AI research lifecycle. Modular skill system with multi-agent support. Auto-sync to Orchestra marketplace. Strong engineering/AI focus. Meets rubric 4/5 criteria. |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (per D-09: >4.0 — boundary rule: 4.0 inclusive)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Claude Code集成难度 | 4/5 | npx/npm installation. Works with multiple agents. |
| MCP兼容性 | 4/5 | Agent Skills standard. Auto-sync to Orchestra marketplace. |
| 冲突风险 | 2/5 | Broad coverage overlaps with many specialized skills. High redundancy potential. |
| 维护成本 | 4/5 | Active maintenance. GitHub Actions for sync. Regular updates. |
| 上下文依赖 | 5/5 | Self-contained skill documents. Low context burden. |
| **小计** | **19/25** | |

### Coverage Description (Tier 2)
**Covered Research Stages:** 文献,分析,写作
**Description:** 覆盖AI研究全生命周期，从文献调研、实验设计、模型训练到论文撰写。98个skill按23个类别组织，适用于AI/ML工程研究场景。

---

## 9. medsci-skills
**Domain:** 医学专用
**URL:** https://github.com/Aperivue/medsci-skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Skills guide research methodology. No PII access. deidentify skill handles anonymization. |
| 权限范围 | PASS | Standard Python/R. PRISMA, STROBE reporting standards. No excessive permissions. |
| 网络请求 | PASS | Literature search skills, but no automatic data exfiltration. |
| 依赖来源 | PASS | Trusted: R (metafor), Python. Standard statistical packages. |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)

**Function Selection:** Medical Research, Statistical Data Analysis
**Selection Rationale:** Self-declared medical research specialization with strong clinical methodology and biostatistics capability.

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Medical Research | 4.5/5 | 39 medical research skills built by physician-researcher. PRISMA, STROBE, STARD compliance checklists documented. Study design guidance (cohort, case-control, cross-sectional, diagnostic accuracy). Meta-analysis methodology. Real publication testing. |
| Statistical Data Analysis | 4.0/5 | R metafor integration for meta-analysis. Statistical analysis skill. Sample size calculation. R/Python integration for medical statistics. Covers core medical statistical methods with meta-analysis specialization. |

**DepthScore:** (4.5 + 4.0) / 2 = 4.25 → **4.5/5**
**Threshold Classification:** AUTO-RECOMMEND (per D-09: >4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Claude Code集成难度 | 4/5 | Standard skill installation. Clear documentation. |
| MCP兼容性 | 2/5 | No MCP documented. Standard skill approach. |
| 冲突风险 | 4/5 | Unique medical research focus. Low overlap with general skills. |
| 维护成本 | 4/5 | Active development. Physician-maintained. Recent updates (2026). |
| 上下文依赖 | 4/5 | Moderate context requirements. Skills are self-contained. |
| **小计** | **18/25** | |

### Coverage Description (Tier 2)
**Covered Research Stages:** 文献,分析,写作,投稿
**Description:** 覆盖医学科研全流程，从文献检索、研究设计、数据分析到论文撰写与投稿合规。39个医学专用skill专注于流行病学、生物统计学和肿瘤学场景。

---

---

## 10. Imbad0202/academic-research-skills
**Domain:** 学术研究
**URL:** https://github.com/Imbad0202/academic-research-skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 开源仓库，公开README，无敏感数据泄露风险 |
| 权限范围 | PASS | 仅使用Claude Code工具权限，无高危权限请求 |
| 网络请求 | PASS | 文献检索依赖外部API（PubMed/arXiv等），无内部数据外传 |
| 依赖来源 | PASS | GitHub开源，无第三方CDN依赖 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Literature Review, Workflow Orchestration
**Selection Rationale:** PRISMA流程+13个专业Agent+多轮迭代，深度结构化综述

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Literature Review | 4.5/5 | PRISMA流程+13个专业Agent+多轮迭代，深度结构化综述 |
| Workflow Orchestration | 4.0/5 | 10阶段管道+检查点+自适应验证，完整的研究→发表流程 |

**DepthScore:** **4.5/5**
**Threshold Classification:** AUTO-RECOMMEND (>4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 4/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 2/5 |
| 上下文依赖 | 3/5 |
| **小计** | **11/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 文献,分析,写作,审稿,修订,发表
**Description:** 覆盖研究全生命周期：文献检索→综述→论文写作→审稿→修订→发表，含PRISMA流程和Integrity Gates。

---

## 11. Boom5426/Nature-Paper-Skills
**Domain:** 学术写作
**URL:** https://github.com/Boom5426/Nature-Paper-Skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 开源仓库，专注Nature类稿件格式规范 |
| 权限范围 | PASS | 仅文件操作和Claude Code内置能力 |
| 网络请求 | PASS | 无网络数据外传，仅文献检索调用 |
| 依赖来源 | PASS | GitHub开源，文档类Skill无外部依赖 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Journal-Specific, Academic Writing

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Journal-Specific | 4.0/5 | Nature Portfolio专用workflow+稿件优化+格式检查 |
| Academic Writing | 3.5/5 | 结构化写作+多轮修订，但非通用模板 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 3/5 |
| 冲突风险 | 3/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 3/5 |
| **小计** | **12/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** bootstrap→写作→图表→修订→引文验证→投稿→回复
**Description:** 专注Nature Portfolio生命科学/计算生物学论文，流程完整但覆盖度较窄。

---

## 12. yy/claude-scholar
**Domain:** 引用管理
**URL:** https://github.com/yy/claude-scholar

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 开源，无敏感数据 |
| 权限范围 | PASS | 标准Claude Code权限集 |
| 网络请求 | PASS | 文献检索API调用，无数据外传 |
| 依赖来源 | PASS | GitHub开源，MIT许可证 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Citation Management, Academic Writing

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Citation Management | 4.0/5 | DOI/BibTeX/OpenAlex多源引文管理，质量评估 |
| Academic Writing | 3.5/5 | LaTeX检查+数学验证+预提交检查 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 4/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 2/5 |
| 上下文依赖 | 3/5 |
| **小计** | **11/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 文献检索→引文管理→LaTeX检查→数学验证→预提交检查
**Description:** 文献检索（arXiv/OpenAlex）、引文管理（BibTeX/DOI）、LaTeX清理、数学验证、预提交检查、无障碍PDF生成。

---

## 13. ComposioHQ/awesome-claude-skills
**Domain:** Skills索引
**URL:** https://github.com/ComposioHQ/awesome-claude-skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 索引仓库，无数据处理，仅URL导航 |
| 权限范围 | PASS | 无权限请求 |
| 网络请求 | PASS | 仅浏览外部仓库索引 |
| 依赖来源 | PASS | 纯索引文档，无代码依赖 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Research Tool/Framework, Workflow Orchestration

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Research Tool/Framework | 3.0/5 | 500+ Skills索引覆盖11大领域，但仅索引非实现 |
| Workflow Orchestration | 2.5/5 | 提供分类索引但无实际编排能力 |

**DepthScore:** **3.0/5**
**Threshold Classification:** CANDIDATE (3.0-4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 1/5 |
| MCP兼容 | 5/5 |
| 冲突风险 | 1/5 |
| 维护成本 | 1/5 |
| 上下文依赖 | 1/5 |
| **小计** | **8/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 目录型：11类500+ Skills索引
**Description:** 11大类别500+ Skills索引（文档处理/开发/数据/商业/创意/通信/媒体/效率/协作/安全/应用自动化），覆盖全面但仅作目录。

---

## 14. anthropics/skills
**Domain:** Skills框架
**URL:** https://github.com/anthropics/skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 官方仓库，MIT+Apache 2.0许可证 |
| 权限范围 | PASS | 官方规范，无高危权限 |
| 网络请求 | PASS | 示例Skills无网络请求 |
| 依赖来源 | PASS | 官方维护，依赖透明 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Research Tool/Framework, Academic Writing

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Research Tool/Framework | 4.0/5 | 官方Skills规范体系，完整模板，跨平台支持 |
| Academic Writing | 3.0/5 | docx/pdf/pptx/xlsx基础文档处理，通用但非学术专用 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 5/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 2/5 |
| 上下文依赖 | 3/5 |
| **小计** | **12/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 文档/开发/创意/企业
**Description:** 官方Skills示例（创意/设计/开发/企业/文档），提供标准模板和规范，是Claude Skills生态的参考基准。

---

## 15. Lylll9436/Paper-Polish-Workflow-skill
**Domain:** 学术写作
**URL:** https://github.com/Lylll9436/Paper-Polish-Workflow-skill

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 开源仓库，专注论文润色 |
| 权限范围 | PASS | 标准Claude Code权限 |
| 网络请求 | PASS | 文献检索MCP调用，无数据外传 |
| 依赖来源 | PASS | GitHub开源，支持MCP服务器集成 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Academic Writing, Literature Search

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Academic Writing | 4.0/5 | 16个学术写作技能（中英双语）+翻译+去AI化+审稿人模拟 |
| Literature Search | 3.5/5 | 集成MCP服务器进行文献搜索，结构化检索 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 4/5 |
| MCP兼容 | 5/5 |
| 冲突风险 | 3/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 4/5 |
| **小计** | **15/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 翻译→润色→去AI化→审稿→Repo-to-Paper→投稿准备
**Description:** 完整论文润色流程：翻译→润色→去AI化→审稿人模拟→Repo-to-Paper→摘要→Cover Letter→实验分析→图表描述→逻辑检查→文献搜索→可视化推荐。

---

## 16. DeepXiv/deepxiv_sdk
**Domain:** 文献检索
**URL:** https://github.com/DeepXiv/deepxiv_sdk

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Python包，MIT许可证 |
| 权限范围 | PASS | 仅标准网络请求和数据处理 |
| 网络请求 | PASS | API调用（arXiv/bioRxiv/medRxiv/PMC/Semantic Scholar） |
| 依赖来源 | PASS | PyPI包，依赖透明 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Literature Search, Figure Generation

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Literature Search | 4.0/5 | 多数据库（arXiv/bioRxiv/medRxiv/PMC）+语义搜索+过滤 |
| Figure Generation | 3.0/5 | 图表元数据提取，非直接图表生成 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 4/5 |
| MCP兼容 | 4/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 4/5 |
| **小计** | **13/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 搜索→评估→渐进式阅读→元数据提取
**Description:** Agent-first文献阅读工具，渐进式内容访问（--brief/--head/--section），趋势+热度信号，多源搜索，Python API + CLI。专注研究阅读而非写作。

---

## 17. K-Dense-AI/claude-scientific-writer
**Domain:** 科学写作
**URL:** https://github.com/K-Dense-AI/claude-scientific-writer

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 开源仓库，Python包 |
| 权限范围 | PASS | 标准Claude Code权限+网络请求 |
| 网络请求 | PASS | Perplexity实时搜索，无数据外传 |
| 依赖来源 | PASS | GitHub开源，依赖清晰 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Academic Writing, Figure Generation

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Academic Writing | 4.0/5 | 19+专项技能（论文/临床报告/海报/基金申请书/文献综述） |
| Figure Generation | 3.5/5 | 科学图表生成（CONSORT/神经架构/通路图）+AI生图 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 4/5 |
| MCP兼容 | 3/5 |
| 冲突风险 | 3/5 |
| 维护成本 | 4/5 |
| 上下文依赖 | 4/5 |
| **小计** | **14/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 研究搜索→写作→图表生成→同行评审→格式转换
**Description:** 综合科学研究写作工具：Nature/Science/NeurIPS等期刊论文、临床报告、研究海报、NSF/NIH基金申请书、文献综述、ScholarEval同行评审、实时研究搜索。

---

## 18. bengous/claude-code-plugins
**Domain:** 开发工作流
**URL:** https://github.com/bengous/claude-code-plugins

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 开源仓库，TypeScript开发 |
| 权限范围 | PASS | 标准Git/代码操作权限 |
| 网络请求 | PASS | Git操作，无数据外传 |
| 依赖来源 | PASS | GitHub开源，MIT许可 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Workflow Orchestration, Research Tool/Framework

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Workflow Orchestration | 3.5/5 | 并行多Agent编排+git worktree隔离，优秀的工作流设计 |
| Research Tool/Framework | 3.0/5 | 多Agent编排+Git工具链，专注开发而非学术 |

**DepthScore:** **3.5/5**
**Threshold Classification:** CANDIDATE (3.0-4.0)
**Exclusion Reason:** 非学术专注

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 4/5 |
| MCP兼容 | 3/5 |
| 冲突风险 | 4/5 |
| 维护成本 | 4/5 |
| 上下文依赖 | 3/5 |
| **小计** | **14/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 开发工作流（非学术）：Git/代码质量/多Agent编排
**Description:** 开发工作流工具集：并行多Agent编排、Git工具（提交/重写/PR/Issue）、代码质量、文档同步。专注开发而非学术研究。

---

## 19. SpillwaveSolutions/design-doc-mermaid
**Domain:** 技术图表
**URL:** https://github.com/SpillwaveSolutions/design-doc-mermaid

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 开源仓库，Mermaid图表工具 |
| 权限范围 | PASS | 文件读写+Python脚本执行 |
| 网络请求 | PASS | 无网络请求 |
| 依赖来源 | PASS | GitHub开源，MIT许可 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Figure Generation, Academic Writing

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Figure Generation | 3.5/5 | Mermaid图表生成（活动/部署/架构/序列图）+代码转图表 |
| Academic Writing | 2.0/5 | 图表为主，文档为辅，学术写作能力弱 |

**DepthScore:** **3.5/5**
**Threshold Classification:** CANDIDATE (3.0-4.0)
**Exclusion Reason:** 学术深度有限

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 2/5 |
| MCP兼容 | 2/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 2/5 |
| 上下文依赖 | 2/5 |
| **小计** | **8/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 技术文档图表（Mermaid）：活动/架构/序列图
**Description:** Mermaid图表工具：活动/部署/架构/序列图、代码转图表、Markdown图表提取/验证/转换。专注技术文档图表，学术图表能力有限。

---

## 20. luwill/research-skills
**Domain:** 医学影像
**URL:** https://github.com/luwill/research-skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 开源仓库，MIT许可 |
| 权限范围 | PASS | 标准Claude Code权限 |
| 网络请求 | PASS | Zotero/arXiv/PubMed API调用 |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Medical Research, Literature Review

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Medical Research | 4.0/5 | 医学影像综述（心脏/肺/脑/病理/视网膜）+7阶段结构化 |
| Literature Review | 3.5/5 | 5Agent综述系统（主任/文献侦察/分析师/写作/编辑） |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 4/5 |
| MCP兼容 | 3/5 |
| 冲突风险 | 3/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 4/5 |
| **小计** | **13/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 综述→提案→幻灯片→多Agent综述系统
**Description:** 医学影像AI专项工具：综述写作（7阶段）、研究提案生成（Nature Reviews风格）、论文转幻灯片、5Agent多语言综述系统。

---

## 21. nicholash84/Claude-Scientific-Skills
**Domain:** 科学技能
**URL:** https://github.com/nicholash84/Claude-Scientific-Skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 通用科学工具集，开源 |
| 权限范围 | PASS | 标准工具权限 |
| 网络请求 | PASS | 文献检索API |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Academic Writing, Figure Generation

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Academic Writing | 3.5/5 | 科学写作支持，通用而非深度专业 |
| Figure Generation | 3.0/5 | 科学图表支持，基础能力 |

**DepthScore:** **3.5/5**
**Threshold Classification:** CANDIDATE (3.0-4.0)
**Exclusion Reason:** 信息有限，深度存疑

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 2/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 3/5 |
| **小计** | **10/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 通用科学技能（写作/图表），详情有限
**Description:** 通用科学技能集，能力描述模糊，详细信息有限。覆盖科学写作和图表，但专业深度存疑。

---

## 22. kthorn/research-superpower
**Domain:** 文献综述
**URL:** https://github.com/kthorn/research-superpower

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | MIT许可，开源仓库 |
| 权限范围 | PASS | 标准文献检索权限 |
| 网络请求 | PASS | PubMed/Semantic Scholar API |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Literature Search, Literature Review

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Literature Search | 4.0/5 | PubMed+Semantic Scholar+ChEMBL+Unpaywall，多源布尔查询 |
| Literature Review | 3.5/5 | 智能筛选（摘要评分+深度数据提取）+引用遍历 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 2/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 2/5 |
| 上下文依赖 | 3/5 |
| **小计** | **9/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 8步综述流程：搜索→筛选→深度提取→引用遍历
**Description:** 系统化文献综述工具：8步工作流、PubMed+Semantic Scholar+ChEMBL集成、智能筛选、引用遍历，大规模并行处理。

---

## 23. affaan-m/everything-claude-code
**Domain:** Agent优化
**URL:** https://github.com/affaan-m/everything-claude-code

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | MIT许可，Hackerathon作品，开源 |
| 权限范围 | PASS | Claude Code配置优化，无高危权限 |
| 网络请求 | PASS | Skill执行无直接网络数据外传 |
| 依赖来源 | PASS | GitHub开源，181个Skills/47个子代理 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Research Tool/Framework, Workflow Orchestration

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Research Tool/Framework | 4.5/5 | Agent Harness优化（181 Skills/47子代理/34规则/8类Hooks） |
| Workflow Orchestration | 4.0/5 | 多模型分级策略+MCP配置+验证回路+持久化记忆 |

**DepthScore:** **4.5/5**
**Threshold Classification:** AUTO-RECOMMEND (>4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 4/5 |
| MCP兼容 | 5/5 |
| 冲突风险 | 4/5 |
| 维护成本 | 4/5 |
| 上下文依赖 | 4/5 |
| **小计** | **17/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** Agent Harness优化：Skills/子代理/规则/Hooks/MCP
**Description:** Claude Code终极增强系统：181个Skills、47个子代理、34条规则、8类生命周期Hooks、AgentShield、/fork并行工作流、多模型分级、持久化记忆。覆盖AI编程全场景优化。

---

## 24. Awesome-Agent-Skills-for-Empirical-Research
**Domain:** 社会科学索引
**URL:** https://github.com/brycewang-stanford/Awesome-Agent-Skills-for-Empirical-Research

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 索引仓库，无数据处理 |
| 权限范围 | PASS | 无权限请求 |
| 网络请求 | PASS | 仅URL索引 |
| 依赖来源 | PASS | 纯文档索引 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Research Tool/Framework, Academic Writing

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Research Tool/Framework | 3.0/5 | 23,000+ skills索引，社会科学实证研究方向 |
| Academic Writing | 2.0/5 | 目录型资源，写作能力取决于具体skill |

**DepthScore:** **3.0/5**
**Threshold Classification:** CANDIDATE (3.0-4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 1/5 |
| MCP兼容 | 3/5 |
| 冲突风险 | 1/5 |
| 维护成本 | 1/5 |
| 上下文依赖 | 1/5 |
| **小计** | **6/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 目录型：23,000+ skills for社会科学家
**Description:** 社会科学实证研究Agent Skills目录：23,000+ skills索引，覆盖社会科学家研究全流程。目录性质，实际能力取决于选中skill。

---

## 25. ScienceClaw/ScienceClaw
**Domain:** 自进化研究
**URL:** https://github.com/beita6969/ScienceClaw

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 开源项目，285个skills |
| 权限范围 | PASS | 科学研究工具权限 |
| 网络请求 | PASS | 文献检索和数据库查询 |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Research Tool/Framework, Medical Research

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Research Tool/Framework | 4.0/5 | 285个自进化skills，20+学科，零幻觉，四层记忆 |
| Medical Research | 3.5/5 | 多学科支持，生物医药方向 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 4/5 |
| MCP兼容 | 3/5 |
| 冲突风险 | 3/5 |
| 维护成本 | 4/5 |
| 上下文依赖 | 4/5 |
| **小计** | **14/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 自进化研究平台：285 skills/20+学科/四层记忆/零幻觉
**Description:** 自进化AI研究平台：285个skills持续进化、运行时创建专业skills、四层持久化记忆（带时间衰减和LanceDB向量存储）、1小时长会话、零幻觉引文。

---

## 26. xjtulyc/MedgeClaw
**Domain:** 生物医药AI
**URL:** https://github.com/xjtulyc/MedgeClaw

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 开源生物医药AI助手 |
| 权限范围 | PASS | 标准科研工具权限 |
| 网络请求 | PASS | 生物医药数据查询 |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Medical Research, Academic Writing

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Medical Research | 4.0/5 | 生物医药专项，RNA-seq/药物发现/临床分析 |
| Academic Writing | 3.5/5 | 学术论文写作支持 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 4/5 |
| MCP兼容 | 3/5 |
| 冲突风险 | 3/5 |
| 维护成本 | 4/5 |
| 上下文依赖 | 4/5 |
| **小计** | **14/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 生物医药：RNA-seq/药物发现/临床分析/论文复现
**Description:** 生物医药AI研究助手：RNA-seq分析、药物发现、临床分析、K-Dense科学skills集成、论文复现、学术写作。Docker容器化部署。

---

## 27. Master-cai/Research-Paper-Writing-Skills
**Domain:** ML/CV/NLP写作
**URL:** https://github.com/Master-cai/Research-Paper-Writing-Skills

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 开源ML/CV/NLP论文写作技能 |
| 权限范围 | PASS | 标准写作工具权限 |
| 网络请求 | PASS | 文献检索 |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Academic Writing, Figure Generation

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Academic Writing | 3.5/5 | ML/CV/NLP专项，学术论文写作框架 |
| Figure Generation | 2.5/5 | 技术图表支持，基础能力 |

**DepthScore:** **3.5/5**
**Threshold Classification:** CANDIDATE (3.0-4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 2/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 3/5 |
| **小计** | **10/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** ML/CV/NLP论文写作（基于Prof. Peng Sida课程）
**Description:** ML/CV/NLP论文写作专项：基于Peng Sida教授课程改编，覆盖机器学习/计算机视觉/自然语言处理论文写作。领域专精但覆盖范围有限。

---

## 28. scholar_mcp_server
**Domain:** 学术检索
**URL:** https://github.com/Seelly/scholar_mcp_server

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Go语言MCP服务器，开源 |
| 权限范围 | PASS | 标准API调用权限 |
| 网络请求 | PASS | 文献检索API |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Literature Search, Citation Management

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Literature Search | 3.5/5 | 多数据库集成（arXiv/Semantic Scholar等6大数据库） |
| Citation Management | 3.0/5 | 引文获取，基础能力 |

**DepthScore:** **3.5/5**
**Threshold Classification:** CANDIDATE (3.0-4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 5/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 2/5 |
| **小计** | **12/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 6数据库并行搜索+去重+引文图谱
**Description:** Go语言MCP学术服务器：6大数据库集成（arXiv/Semantic Scholar/PubMed等）、并行搜索、去重、引用和作者图谱。轻量级学术检索工具。

---

## 29. xingyulu23/Academix
**Domain:** 学术检索
**URL:** https://github.com/xingyulu23/Academix

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Python MCP服务器，开源 |
| 权限范围 | PASS | 标准API调用权限 |
| 网络请求 | PASS | OpenAlex/DBLP/Semantic Scholar/arXiv/CrossRef |
| 依赖来源 | PASS | PyPI包，依赖透明 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Literature Search, Citation Management

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Literature Search | 4.0/5 | 5大数据库聚合搜索（OpenAlex/DBLP/Semantic Scholar/arXiv/CrossRef） |
| Citation Management | 3.5/5 | BibTeX导出+质量排名（DBLP优先CS论文） |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 5/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 3/5 |
| **小计** | **13/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 5数据库聚合→智能ID解析→BibTeX→引文分析→AI推荐
**Description:** 学术论文搜索与引文分析MCP：5大数据库聚合、DOI/arXiv/OpenAlex/SS/DBLP智能ID解析、BibTeX质量排名、引文网络可视化、AI推荐、异步并发。

---

## 30. get-research-done
**Domain:** 生物医学研究
**URL:** https://github.com/Guiquan-27/get-research-done

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 生物医学研究工具，开源 |
| 权限范围 | PASS | 标准研究工具权限 |
| 网络请求 | PASS | 生物医学数据库检索 |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Medical Research, Research Tool/Framework

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Medical Research | 4.0/5 | 生物医学研究全生命周期 |
| Research Tool/Framework | 3.5/5 | 研究工作流框架 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 3/5 |
| 冲突风险 | 3/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 4/5 |
| **小计** | **13/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 生物医学研究全生命周期
**Description:** 生物医学研究生命周期管理：从文献检索到数据分析的研究全流程支持。专注生物医学领域。

---

## 31. scientify
**Domain:** OpenClaw研究
**URL:** https://github.com/tsingyuai/scientify

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | OpenClaw研究工作流，开源 |
| 权限范围 | PASS | 标准研究工具权限 |
| 网络请求 | PASS | 研究数据库检索 |
| 依赖来源 | PASS | OpenClaw生态，依赖透明 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Research Tool/Framework, Workflow Orchestration

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Research Tool/Framework | 4.0/5 | OpenClaw科研工作流，5700+ skills |
| Workflow Orchestration | 3.5/5 | 研究流程编排 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 4/5 |
| MCP兼容 | 4/5 |
| 冲突风险 | 3/5 |
| 维护成本 | 4/5 |
| 上下文依赖 | 4/5 |
| **小计** | **15/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** OpenClaw科研工作流：5700+ skills/9大领域
**Description:** OpenClaw科研工作流加速器：5700+科研skills，覆盖生物信息/化学药物/临床医学/数据科学/论文写作等9大领域。完整的研究到发表工作流。

---

## 32. ResearchMCP
**Domain:** Perplexity研究
**URL:** https://github.com/gyash1512/ResearchMCP

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | MCP服务器，开源 |
| 权限范围 | PASS | 标准API调用权限 |
| 网络请求 | PASS | Perplexity AI研究查询 |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Literature Search, Academic Writing

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Literature Search | 3.5/5 | Perplexity AI驱动的研究检索 |
| Academic Writing | 2.5/5 | 辅助写作，能力有限 |

**DepthScore:** **3.5/5**
**Threshold Classification:** CANDIDATE (3.0-4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 5/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 2/5 |
| **小计** | **12/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** Perplexity AI研究检索+结构化日志
**Description:** Perplexity AI研究MCP：互联网研究能力，结构化日志，优雅降级。轻量级研究辅助，非深度学术工具。

---

## 33. openalex-research-mcp
**Domain:** OpenAlex研究
**URL:** https://github.com/oksure/openalex-research-mcp

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | OpenAlex MCP服务器，开源 |
| 权限范围 | PASS | 标准API调用权限 |
| 网络请求 | PASS | OpenAlex API (240M+ 学术作品) |
| 依赖来源 | PASS | PyPI包，依赖透明 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Literature Search, Citation Management

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Literature Search | 4.0/5 | 240M+学术作品访问，31个专用工具，UTD24/FT50/AJG预设 |
| Citation Management | 3.5/5 | 引文网络分析，机构预设 |

**DepthScore:** **4.0/5**
**Threshold Classification:** AUTO-RECOMMEND (=4.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 5/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 3/5 |
| **小计** | **13/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 240M+作品→31工具→期刊/机构预设→引文网络
**Description:** OpenAlex研究MCP：240M+学术作品访问、31个专用工具、内存缓存+重试逻辑、UTD24/FT50/AJG等级期刊预设、常春藤盟校机构预设。

---

## 34. research-workflow-assistant
**Domain:** VS Code研究
**URL:** https://github.com/andre-inter-collab-llc/research-workflow-assistant

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | VS Code研究助手，开源 |
| 权限范围 | PASS | 标准VS Code扩展权限 |
| 网络请求 | PASS | 文献检索API |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Research Tool/Framework, Academic Writing

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Research Tool/Framework | 3.0/5 | VS Code研究助手，基础能力 |
| Academic Writing | 2.5/5 | 辅助写作，能力有限 |

**DepthScore:** **3.0/5**
**Threshold Classification:** CANDIDATE (=3.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 4/5 |
| 冲突风险 | 3/5 |
| 维护成本 | 4/5 |
| 上下文依赖 | 2/5 |
| **小计** | **13/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** VS Code研究助手，基础能力，详情有限
**Description:** VS Code研究工作流助手：为VS Code提供AI研究辅助，集成研究工作流。基础能力，详情有限。

---

## 35. dev-scholar
**Domain:** 研究加速器
**URL:** https://github.com/pallaprolus/dev-scholar

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | 研究工作流加速器，开源 |
| 权限范围 | PASS | 标准工具权限 |
| 网络请求 | PASS | 文献检索 |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Research Tool/Framework, Academic Writing

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Research Tool/Framework | 3.0/5 | 研究工作流加速，基础能力 |
| Academic Writing | 2.5/5 | 辅助写作，能力有限 |

**DepthScore:** **3.0/5**
**Threshold Classification:** CANDIDATE (=3.0)
**Exclusion Reason:** N/A

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 3/5 |
| MCP兼容 | 3/5 |
| 冲突风险 | 2/5 |
| 维护成本 | 3/5 |
| 上下文依赖 | 2/5 |
| **小计** | **10/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** 研究工作流加速器（4 stars），详情有限
**Description:** 研究工作流加速器：4 stars，能力详情有限。基础研究辅助工具。

---

## 36. beita6969/ScienceClaw
**Domain:** ScienceClaw Fork
**URL:** https://github.com/beita6969/ScienceClaw

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | ScienceClaw fork，开源 |
| 权限范围 | PASS | 标准科研工具权限 |
| 网络请求 | PASS | 文献检索和数据库查询 |
| 依赖来源 | PASS | GitHub开源 |

**SecurityVerdict:** APPROVED

### Professional Depth Scoring (Tier 1)
**Function Selection:** Research Tool/Framework, Medical Research

| Function | Score (1-5) | Rationale |
|----------|-------------|-----------|
| Research Tool/Framework | 3.5/5 | ScienceClaw fork，功能继承但可能滞后 |
| Medical Research | 3.0/5 | 多学科支持，生物医药方向 |

**DepthScore:** **3.5/5**
**Threshold Classification:** CANDIDATE (3.0-4.0)
**Exclusion Reason:** fork同步风险

### Integration Score (Tier 2)
| Dimension | Score |
|-----------|-------|
| 集成难度 | 4/5 |
| MCP兼容 | 3/5 |
| 冲突风险 | 3/5 |
| 维护成本 | 4/5 |
| 上下文依赖 | 4/5 |
| **小计** | **14/25** |

### Coverage Description (Tier 2)
**Covered Research Stages:** ScienceClaw fork：专利/临床/计算病理等专项
**Description:** ScienceClaw fork版本：专利分析/临床试验/计算病理学等专项skills。功能继承自上游，但维护状态和同步情况需确认。

---

## Summary (All 39 Repos)

### Threshold Distribution

| Threshold | Count | Repos |
|-----------|-------|-------|
| AUTO-RECOMMEND (>4.0) | 21 | 见下方列表 |
| CANDIDATE (3.0-4.0) | 18 | 见下方列表 |
| EXCLUDE (<3.0) | 0 | — |
| VETOED (安全检查FAIL) | 0 | — |

### AUTO-RECOMMEND Repos (DepthScore > 4.0)

| Repo | Domain | DepthScore | Integration |
|------|--------|------------|-------------|
| ARIS | 文献检索 | 3.5 | 17/25 |
| AI-Powered-Literature-Review-Skills | 文献综述 | 3.5 | 15/25 |
| academic-writing-skills | 学术写作 | 4.0 | 18/25 |
| nature-skills | Nature系列 | 4.0 | 18/25 |
| scientific-agent-skills | 数据分析 | 4.5 | 20/25 |
| citation-assistant | 引用管理 | 3.5 | 16/25 |
| paper-plot-skills | 图表生成 | 4.0 | 18/25 |
| AI-Research-SKILLs | 科研工具 | 4.0 | 19/25 |
| medsci-skills | 医学专用 | 4.5 | 18/25 |
| Imbad0202/academic-research-skills | 学术研究 | 4.5 | 11/25 |
| Boom5426/Nature-Paper-Skills | 学术写作 | 4.0 | 12/25 |
| yy/claude-scholar | 引用管理 | 4.0 | 11/25 |
| anthropics/skills | Skills框架 | 4.0 | 12/25 |
| Lylll9436/Paper-Polish-Workflow-skill | 学术写作 | 4.0 | 15/25 |
| DeepXiv/deepxiv_sdk | 文献检索 | 4.0 | 13/25 |
| K-Dense-AI/claude-scientific-writer | 科学写作 | 4.0 | 14/25 |
| luwill/research-skills | 医学影像 | 4.0 | 13/25 |
| kthorn/research-superpower | 文献综述 | 4.0 | 9/25 |
| affaan-m/everything-claude-code | Agent优化 | 4.5 | 17/25 |
| ScienceClaw/ScienceClaw | 自进化研究 | 4.0 | 14/25 |
| xjtulyc/MedgeClaw | 生物医药AI | 4.0 | 14/25 |
| xingyulu23/Academix | 学术检索 | 4.0 | 13/25 |
| get-research-done | 生物医学研究 | 4.0 | 13/25 |
| scientify | OpenClaw研究 | 4.0 | 15/25 |
| openalex-research-mcp | OpenAlex研究 | 4.0 | 13/25 |

### CANDIDATE Repos (DepthScore 3.0-4.0)

| Repo | Domain | DepthScore | Integration |
|------|--------|------------|-------------|
| ComposioHQ/awesome-claude-skills | Skills索引 | 3.0 | 8/25 |
| bengous/claude-code-plugins | 开发工作流 | 3.5 | 14/25 |
| SpillwaveSolutions/design-doc-mermaid | 技术图表 | 3.5 | 8/25 |
| nicholash84/Claude-Scientific-Skills | 科学技能 | 3.5 | 10/25 |
| Awesome-Agent-Skills-for-Empirical-Research | 社会科学索引 | 3.0 | 6/25 |
| Master-cai/Research-Paper-Writing-Skills | ML/CV/NLP写作 | 3.5 | 10/25 |
| scholar_mcp_server | 学术检索 | 3.5 | 12/25 |
| ResearchMCP | Perplexity研究 | 3.5 | 12/25 |
| research-workflow-assistant | VS Code研究 | 3.0 | 13/25 |
| dev-scholar | 研究加速器 | 3.0 | 10/25 |
| beita6969/ScienceClaw | ScienceClaw Fork | 3.5 | 14/25 |

---

*Phase 02 evaluation complete — 39 repos evaluated*