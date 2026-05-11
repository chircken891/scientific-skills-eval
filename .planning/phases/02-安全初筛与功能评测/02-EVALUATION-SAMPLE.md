# Phase 2 Evaluation Sample — 9 Repositories

**Generated:** 2026-05-11
**Purpose:** Validate evaluation criteria by scoring 9 sampled repositories (one per functional domain)

---

## 1. ARIS (Auto-claude-code-research-in-sleep)
**Domain:** 文献检索
**URL:** https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep
**Stars:** ~2.8k

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | No PII/medical records access. Skills work with files locally. No credential storage. `.env.example` only contains placeholder names. |
| 权限范围 | PASS | No special permissions requested. Plain Markdown skill files. No package.json with excessive permissions. |
| 网络请求 | PASS | No suspicious external communication. Skills read/write local files only. External model calls go through user-configured API. |
| 依赖来源 | PASS | Uses trusted sources: Anthropic API, OpenAI API, GitHub. No untrusted dependencies. |

### Functional Score: 29/40
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 核心能力 | 5/5 | Full research pipeline: idea→experiment→paper→rebuttal. Comprehensive workflow coverage. |
| 医学适配度 | 2/5 | General ML research focus. No specific epidemiology/biostatistics/oncology workflow. |
| 长文本适配 | 4/5 | Designed for long papers. Research Wiki provides persistent memory for large context. |
| 统计/数学能力 | 2/5 | Basic statistics via code execution, but no dedicated statistics skill. |
| 代码生成 | 4/5 | Strong code generation for ML experiments. Supports Python, R via execution. |
| 工具调用效率 | 4/5 | Structured skill invocation with parameters. Artifact-based communication. |
| 自主兜底 | 3/5 | Self-correction via reviewer loop. Error handling present but limited. |
| 多模态 | 2/5 | Primary focus on text/code. No explicit chart/image understanding capability. |

### Integration Score: 17/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| Claude Code集成难度 | 3/5 | Skills directory approach. CLI available. Moderate setup complexity. |
| MCP兼容性 | 3/5 | Supports MCP servers (mcp-servers directory). Partial MCP support. |
| 冲突风险 | 3/5 | Overlaps with general research skills. Some functionality duplicates other tools. |
| 维护成本 | 5/5 | Active maintenance (v0.4.4, 2026-04-20). 62 skills, regular updates. |
| 上下文依赖 | 3/5 | Long context helpful but not required. Research Wiki helps manage context. |

### Coverage Score: 16/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 领域覆盖 | 2/5 | ML research focus. Limited coverage for epidemiology/biostatistics/oncology. |
| 科研阶段覆盖 | 5/5 | Full lifecycle: idea→literature→experiments→writing→rebuttal. Excellent coverage. |
| 互补性 | 4/5 | Works well with other skills. Modular design. |
| 冗余度 | 5/5 | Unique comprehensive workflow. Low redundancy with other skills. |

### Weighted Total: 62/100
**Security Verdict:** APPROVED

### Strengths
- Full autonomous research pipeline (idea to rebuttal)
- Cross-model adversarial review (Claude + GPT-5.4)
- Research Wiki for persistent memory
- Active maintenance with frequent updates
- Zero-dependency Markdown-based skills

### Weaknesses
- Not specialized for medical/epidemiology research
- No dedicated statistics/biostatistics module
- Limited multi-modal capability

---

## 2. AI-Powered-Literature-Review-Skills
**Domain:** 文献综述
**URL:** https://github.com/stephenlzc/AI-Powered-Literature-Review-Skills
**Stars:** ~300

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Browser automation for literature search. No credential storage. API keys via environment. |
| 权限范围 | PASS | Standard browser permissions. No excessive system access. Docker containerized execution. |
| 网络请求 | PASS | Searches CNKI, WOS, ScienceDirect, PubMed. Standard academic database access. No suspicious endpoints. |
| 依赖来源 | PASS | Trusted: Docker, standard Python packages. `mcp.json` references standard MCP servers. |

### Functional Score: 26/40
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 核心能力 | 5/5 | 8-stage systematic literature review workflow. GB/T 7714-2015 citation format. Comprehensive coverage. |
| 医学适配度 | 2/5 | General academic focus. No specific medical/epidemiology adaptation. |
| 长文本适配 | 4/5 | Handles 30-50 papers per review. Structured output for long documents. |
| 统计/数学能力 | 1/5 | No statistical analysis capability. Pure literature review. |
| 代码生成 | 1/5 | No code generation. Workflow-based automation only. |
| 工具调用效率 | 4/5 | Structured browser automation. Parallel search execution. |
| 自主兜底 | 3/5 | Iterative refinement (outline→draft→review→final). Quality checks at each stage. |
| 多模态 | 2/5 | Text-focused. No chart/image analysis capability. |

### Integration Score: 15/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| Claude Code集成难度 | 3/5 | Skill-based installation. Docker compose setup. Moderate complexity. |
| MCP兼容性 | 4/5 | `mcp.json` present. MCP protocol support for browser automation. |
| 冲突风险 | 2/5 | Overlaps with ARIS research-lit. Some duplication with general search skills. |
| 维护成本 | 3/5 | Moderate maintenance. Last update ~2025. Community contributions present. |
| 上下文依赖 | 3/5 | Session-based context management. Moderate context requirements. |

### Coverage Score: 14/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 领域覆盖 | 2/5 | General academic literature. Not specialized for medical domains. |
| 科研阶段覆盖 | 5/5 | Excellent: query analysis → search → dedup → verification → export → analysis → citation → synthesis |
| 互补性 | 4/5 | Works well with citation management and writing skills. |
| 冗余度 | 3/5 | Some overlap with ARIS research-lit. Moderate redundancy. |

### Weighted Total: 55/100
**Security Verdict:** APPROVED

### Strengths
- Systematic 8-stage literature review workflow
- Multi-database parallel search (CNKI, WOS, ScienceDirect, PubMed)
- GB/T 7714-2015 citation formatting
- Quality assurance with review iterations

### Weaknesses
- No statistical analysis or code generation
- Not specialized for medical/epidemiology research
- Requires Docker setup

---

## 3. academic-writing-skills
**Domain:** 学术写作
**URL:** https://github.com/bahayonghang/academic-writing-skills
**Stars:** ~500

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Local file processing. No external data transmission. Python scripts operate on local files. |
| 权限范围 | PASS | Minimal permissions. Standard Python library access only. |
| 网络请求 | PASS | No network calls in scripts. Document processing is purely local. |
| 依赖来源 | PASS | Trusted: `ruff`, `pyright`, standard Python packages. `uv.lock` for dependency pinning. |

### Functional Score: 26/40
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 核心能力 | 4/5 | 5 skills: LaTeX paper, thesis, Typst, paper-audit, industrial-ai-research. Comprehensive writing support. |
| 医学适配度 | 2/5 | General academic writing. No specific medical domain adaptation. |
| 长文本适配 | 5/5 | Designed for full papers/theses. Handles long documents with section parsing. |
| 统计/数学能力 | 2/5 | LaTeX math support, but no statistical analysis capability. |
| 代码生成 | 2/5 | Parser scripts in Python. No dedicated code generation for research. |
| 工具调用效率 | 3/5 | Structured skill organization. Parser scripts handle documents efficiently. |
| 自主兜底 | 4/5 | paper-audit includes multi-perspective review with self-review capability. |
| 多模态 | 2/5 | Text-focused. No explicit chart/image understanding. |

### Integration Score: 18/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| Claude Code集成难度 | 4/5 | Simple skill installation. `just` task runner. Clear documentation. |
| MCP兼容性 | 2/5 | No MCP support documented. Standard skill approach. |
| 冲突风险 | 3/5 | Overlaps with nature-skills polishing. Some redundancy in academic prose. |
| 维护成本 | 4/5 | Active maintenance. `just` CI pipeline. Regular updates. |
| 上下文依赖 | 5/5 | Designed for long documents. Section-aware processing. Low context burden. |

### Coverage Score: 15/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 领域覆盖 | 2/5 | General academic writing. Not specialized for medical/epidemiology. |
| 科研阶段覆盖 | 4/5 | Writing and polishing stages covered. Audit and validation included. |
| 互补性 | 4/5 | Works well with citation and figure skills. Modular skill design. |
| 冗余度 | 5/5 | Unique focus on post-writing polish. Low redundancy with other skills. |

### Weighted Total: 59/100
**Security Verdict:** APPROVED

### Strengths
- Comprehensive writing skills (5 specialized skills)
- Multi-format support: LaTeX, Typst, Word
- Paper-audit with multi-reviewer system
- Strong document parsing and validation

### Weaknesses
- No statistical analysis or code generation
- Not specialized for medical research
- Limited MCP compatibility

---

## 4. nature-skills
**Domain:** Nature系列
**URL:** https://github.com/Yuan1z0825/nature-skills
**Stars:** ~400

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Local matplotlib figure generation. No PII access. SVG output only. |
| 权限范围 | PASS | Standard Python packages. No special permissions. |
| 网络请求 | PASS | No network calls in figure generation. References are local or DOI-based. |
| 依赖来源 | PASS | Trusted: matplotlib, NumPy. Official journal guidelines-based rules. |

### Functional Score: 24/40
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 核心能力 | 5/5 | 6 skills: figure, polishing, citation, data, response, paper2ppt. Nature journal focus. |
| 医学适配度 | 3/5 | Nature journal standards include medical research. Response and data skills relevant to medical papers. |
| 长文本适配 | 4/5 | Paper polishing and response handle long documents. Figure generation from data. |
| 统计/数学能力 | 2/5 | Figure generation includes statistical charts. No statistical analysis capability. |
| 代码生成 | 3/5 | matplotlib scripts for figures. Parameter-based figure generation. |
| 工具调用效率 | 4/5 | Structured skill system. Reference files for complex rules. |
| 自主兜底 | 3/5 | Quality rules enforced. 12-step polishing workflow with verification. |
| 多模态 | 4/5 | Figure generation and understanding. Chart atlas with 10 chart types. |

### Integration Score: 19/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| Claude Code集成难度 | 4/5 | Standard skill installation. Clear structure. Good documentation. |
| MCP兼容性 | 2/5 | No MCP support documented. Standard Claude skill approach. |
| 冲突风险 | 3/5 | Some overlap with academic-writing-skills (polishing). Figure skills unique. |
| 维护成本 | 4/5 | Active development. Recent updates (2026). |
| 上下文依赖 | 6/5 | Very low context burden. Figures are self-contained. Excellent for MiniMax. |

### Coverage Score: 17/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 领域覆盖 | 4/5 | Nature/Science/Cell journal focus. High-impact journal standards. |
| 科研阶段覆盖 | 4/5 | Writing, figures, citation, response, data availability. Good coverage. |
| 互补性 | 4/5 | Works well with academic-writing-skills. Unique journal-specific focus. |
| 冗余度 | 5/5 | Journal-specific skills with low redundancy. Unique Nature journal expertise. |

### Weighted Total: 60/100
**Security Verdict:** APPROVED

### Strengths
- Nature journal-specific expertise (6 specialized skills)
- Publication-ready matplotlib figures with proper typography
- Complete paper preparation pipeline (writing, figures, citation, response)
- Bilingual support (Chinese/English)

### Weaknesses
- Niche focus (Nature-family journals only)
- Limited statistical analysis capability
- No MCP support

---

## 5. scientific-agent-skills (K-Dense-AI)
**Domain:** 数据分析
**URL:** https://github.com/K-Dense-AI/scientific-agent-skills
**Stars:** ~3k

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Skill documentation only. No execution of user data. 135 skills focus on guidance. |
| 权限范围 | PASS | No package installation required for reading skills. Standard npm package. |
| 网络请求 | PASS | Skills document APIs but don't automatically call them. User controls execution. |
| 依赖来源 | PASS | Trusted: Agent Skills standard. npm distribution. 50+ open source projects acknowledged. |

### Functional Score: 33/40
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 核心能力 | 5/5 | 135 skills covering 20+ scientific domains. Comprehensive coverage. |
| 医学适配度 | 4/5 | Strong bioinformatics, clinical research, healthcare AI coverage. 100+ scientific databases. |
| 长文本适配 | 4/5 | Multi-step workflows. Literature review, scientific writing skills. |
| 统计/数学能力 | 4/5 | Statistical analysis, scientific ML, time series. 70+ optimized Python packages. |
| 代码生成 | 4/5 | Explicit skills for RDKit, Scanpy, PyTorch, etc. Production-ready examples. |
| 工具调用效率 | 4/5 | Well-documented skill structure. Database lookup skills for 78+ databases. |
| 自主兜底 | 4/5 | Troubleshooting guides, best practices. Community-driven error solutions. |
| 多模态 | 4/5 | CLIP, Whisper, LLaVA, Stable Diffusion, SAM skills. Strong multimodal coverage. |

### Integration Score: 21/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| Claude Code集成难度 | 4/5 | Standard npx/gh skill installation. Works with multiple agents. |
| MCP兼容性 | 4/5 | Agent Skills standard supports MCP. Works with Cursor, Claude Code, Codex. |
| 冲突风险 | 2/5 | Broad coverage may overlap with many specialized skills. Some redundancy. |
| 维护成本 | 5/5 | Active maintenance. 135 skills, 50+ open source dependencies. Enterprise ready. |
| 上下文依赖 | 6/5 | Skills are self-contained documents. Very low context burden. Excellent for MiniMax. |

### Coverage Score: 22/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 领域覆盖 | 5/5 | 20+ scientific domains. 100+ databases. Strong bioinformatics/clinical coverage. |
| 科研阶段覆盖 | 4/5 | Literature review to paper writing. Hypothesis generation to deployment. |
| 互补性 | 5/5 | Modular skill design. Works with other specialized skills. |
| 冗余度 | 4/5 | Broad coverage but each skill is distinct. Moderate redundancy in categories. |

### Weighted Total: 76/100
**Security Verdict:** APPROVED

### Strengths
- Massive skill library (135 skills, 100+ databases)
- Strong medical/bioinformatics coverage
- Works with multiple AI agents (Claude Code, Cursor, Codex)
- Production-tested with real scientific workflows

### Weaknesses
- Skill quality varies (community contributions)
- Security disclaimer acknowledges review responsibility
- Overwhelming scope may confuse selection

---

## 6. citation-assistant
**Domain:** 引用管理
**URL:** https://github.com/ZhangNy301/citation-assistant
**Stars:** ~200

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Shell scripts for API calls. API keys via environment variables. No PII access. |
| 权限范围 | PASS | Standard curl/jq/sqlite3. No excessive permissions. |
| 网络请求 | PASS | Semantic Scholar API, CrossRef API. Standard academic search endpoints. |
| 依赖来源 | PASS | Trusted: curl, jq, sqlite3. Standard academic APIs. |

### Functional Score: 19/40
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 核心能力 | 4/5 | Citation search, BibTeX generation, author/venue quality checks. Comprehensive citation management. |
| 医学适配度 | 2/5 | General academic focus. CCF lookup for CS venues. Medical citation quality assessment limited. |
| 长文本适配 | 3/5 | Handles citation context. Interface designed for insertion into documents. |
| 统计/数学能力 | 1/5 | No statistical analysis. Pure citation management. |
| 代码生成 | 1/5 | Shell scripts only. No code generation capability. |
| 工具调用效率 | 4/5 | Efficient shell-based API calls. Bulk search capability. |
| 自主兜底 | 2/5 | Fallback to CrossRef on 429. Basic error handling. |
| 多模态 | 1/5 | No multi-modal capability. Pure text/API based. |

### Integration Score: 16/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| Claude Code集成难度 | 4/5 | Simple shell script-based skill. Easy integration. |
| MCP兼容性 | 2/5 | No MCP support. Standard skill approach. |
| 冲突风险 | 4/5 | Unique citation management. Low overlap with other skills. |
| 维护成本 | 3/5 | Moderate maintenance. Last update ~2025. |
| 上下文依赖 | 3/5 | Lightweight. Low context requirements. |

### Coverage Score: 13/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 领域覆盖 | 2/5 | General academic citation. Not specialized for medical domains. |
| 科研阶段覆盖 | 3/5 | Citation stage covered. Limited coverage of other stages. |
| 互补性 | 4/5 | Works well with writing and polishing skills. Essential for academic writing. |
| 冗余度 | 4/5 | Unique citation focus. Low redundancy. |

### Weighted Total: 48/100
**Security Verdict:** APPROVED

### Strengths
- Comprehensive citation management (search, BibTeX, quality assessment)
- arXiv smart detection (recommended/caution/normal)
- CCF, JCR, impact factor lookup
- CrossRef fallback on rate limits

### Weaknesses
- No statistical analysis or code generation
- Shell script dependency (less portable)
- Limited medical/epidemiology adaptation
- Basic error handling

---

## 7. paper-plot-skills
**Domain:** 图表生成
**URL:** https://github.com/Trae1ounG/paper-plot-skills
**Stars:** ~600

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | matplotlib scripts generate figures locally. No data transmission. |
| 权限范围 | PASS | Standard Python packages. No special permissions. |
| 网络请求 | PASS | No network calls. Pure local figure generation. |
| 依赖来源 | PASS | Trusted: matplotlib, Pillow. Official paper figure sources. |

### Functional Score: 22/40
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 核心能力 | 5/5 | 9 pre-built figure styles from real papers. plot-from-data and plot-from-image. |
| 医学适配度 | 2/5 | General scientific figures. No specific medical chart types. |
| 长文本适配 | 2/5 | Single figure generation. Not document-focused. |
| 统计/数学能力 | 3/5 | Statistical charts (bar, line, scatter, radar). Confidence intervals, error bars. |
| 代码生成 | 4/5 | Complete matplotlib scripts. Parameter-based figure generation. |
| 工具调用效率 | 3/5 | Style-based invocation. Image analysis for reproduction. |
| 自主兜底 | 2/5 | User provides data/image. Limited autonomous capability. |
| 多模态 | 5/5 | Excellent chart/image understanding. plot-from-image analyzes paper figures. |

### Integration Score: 17/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| Claude Code集成难度 | 4/5 | Simple Python script installation. Clear style documentation. |
| MCP兼容性 | 2/5 | No MCP support. Standard Python approach. |
| 冲突风险 | 3/5 | Overlaps with nature-figure. Some duplication in chart generation. |
| 维护成本 | 4/5 | Active development. Community contributions. |
| 上下文依赖 | 5/5 | Self-contained matplotlib scripts. Very low context burden. |

### Coverage Score: 14/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 领域覆盖 | 3/5 | Scientific figures from ML papers. General scientific coverage. |
| 科研阶段覆盖 | 2/5 | Results visualization stage only. Limited other stages. |
| 互补性 | 4/5 | Works well with writing skills. Essential for paper figures. |
| 冗余度 | 5/5 | Unique figure reproduction focus. Low redundancy. |

### Weighted Total: 53/100
**Security Verdict:** APPROVED

### Strengths
- Real paper figure styles (9 pre-built)
- plot-from-image capability (analyze and reproduce figures)
- Publication-ready output (300 dpi, SVG)
- Strong multi-modal (chart/image understanding)

### Weaknesses
- No document-level workflow
- Limited medical/epidemiology adaptation
- No statistical analysis, only visualization
- Narrow scope (figures only)

---

## 8. AI-Research-SKILLs (Orchestra-Research)
**Domain:** 科研工具
**URL:** https://github.com/Orchestra-Research/AI-Research-SKILLs
**Stars:** ~1k

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | npm package with skill documentation. No data access. Skills guide execution. |
| 权限范围 | PASS | Minimal permissions. Standard npm package. |
| 网络请求 | PASS | No automatic network calls. User controls execution. |
| 依赖来源 | PASS | Trusted: npm package. GitHub repository. MIT license. |

### Functional Score: 27/40
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 核心能力 | 5/5 | 98 skills covering full AI research lifecycle. Autonomous research orchestration. |
| 医学适配度 | 2/5 | AI research focus. Limited medical adaptation. Engineering-centric. |
| 长文本适配 | 4/5 | Paper writing, literature survey skills. Handles long documents. |
| 统计/数学能力 | 3/5 | Evaluation, MLOps skills. Some statistical benchmarking. |
| 代码生成 | 4/5 | Training pipelines, deployment skills. Strong engineering focus. |
| 工具调用效率 | 4/5 | Structured skill system. 23 categories of expertise. |
| 自主兜底 | 4/5 | Autoresearch orchestration with self-correction. Troubleshooting guides. |
| 多模态 | 3/5 | CLIP, Whisper, Stable Diffusion, LLaVA skills. Moderate multimodal coverage. |

### Integration Score: 19/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| Claude Code集成难度 | 4/5 | npx/npm installation. Works with multiple agents. |
| MCP兼容性 | 4/5 | Agent Skills standard. Auto-sync to Orchestra marketplace. |
| 冲突风险 | 2/5 | Broad coverage overlaps with many specialized skills. High redundancy potential. |
| 维护成本 | 4/5 | Active maintenance. GitHub Actions for sync. Regular updates. |
| 上下文依赖 | 5/5 | Self-contained skill documents. Low context burden. |

### Coverage Score: 20/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 领域覆盖 | 3/5 | AI research focus. Not specialized for medical domains. |
| 科研阶段覆盖 | 5/5 | Full lifecycle: ideation to deployment. Excellent coverage. |
| 互补性 | 4/5 | Modular design. Works with specialized skills. |
| 冗余度 | 4/5 | Broad but each skill is distinct. Moderate redundancy in categories. |

### Weighted Total: 66/100
**Security Verdict:** APPROVED

### Strengths
- Comprehensive 98-skill library
- Full AI research lifecycle coverage
- Autonomous research orchestration layer
- Works with multiple AI agents
- Auto-sync to Orchestra marketplace

### Weaknesses
- Engineering focus, limited medical adaptation
- Overwhelming scope (98 skills)
- Some overlap/redundancy in skill categories
- Not specialized for epidemiology/biostatistics

---

## 9. medsci-skills
**Domain:** 医学专用
**URL:** https://github.com/Aperivue/medsci-skills
**Stars:** ~78

### Security Check
| Check | Result | Evidence |
|-------|--------|----------|
| 数据安全 | PASS | Skills guide research methodology. No PII access. deidentify skill handles anonymization. |
| 权限范围 | PASS | Standard Python/R. PRISMA, STROBE reporting standards. No excessive permissions. |
| 网络请求 | PASS | Literature search skills, but no automatic data exfiltration. |
| 依赖来源 | PASS | Trusted: R (metafor), Python. Standard statistical packages. |

### Functional Score: 31/40
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 核心能力 | 5/5 | 39 medical research skills. PRISMA, STROBE, meta-analysis, study design. Excellent medical focus. |
| 医学适配度 | 5/5 | Built by physician-researcher. STARD, PRISMA, STROBE compliance. Real publication tested. |
| 长文本适配 | 3/5 | Manuscript writing skills. Moderate document handling. |
| 统计/数学能力 | 5/5 | R metafor for meta-analysis. Statistical analysis (analyze-stats). Sample size calculation. |
| 代码生成 | 4/5 | R/Python for statistics. Figure generation. |
| 工具调用效率 | 3/5 | Structured skill system. end-to-end pipeline with orchestrate. |
| 自主兜底 | 3/5 | Self-review capability. Reporting compliance checks. |
| 多模态 | 2/5 | Figure generation (make-figures). Limited multi-modal. |

### Integration Score: 18/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| Claude Code集成难度 | 4/5 | Standard skill installation. Clear documentation. |
| MCP兼容性 | 2/5 | No MCP documented. Standard skill approach. |
| 冲突风险 | 4/5 | Unique medical research focus. Low overlap with general skills. |
| 维护成本 | 4/5 | Active development. Recent updates (2026). Physician-maintained. |
| 上下文依赖 | 4/5 | Moderate context requirements. Skills are self-contained. |

### Coverage Score: 22/30
| Dimension | Score | Rationale |
|-----------|-------|----------|
| 领域覆盖 | 5/5 | Epidemiology, biostatistics, oncology workflows. STARD, PRISMA, STROBE. Excellent coverage. |
| 科研阶段覆盖 | 5/5 | Full pipeline: lit search → study design → data collection → analysis → writing → compliance |
| 互补性 | 4/5 | Works with general academic skills. Unique medical focus. |
| 冗余度 | 4/5 | Unique medical research specialization. Low redundancy. |

### Weighted Total: 71/100
**Security Verdict:** APPROVED

### Strengths
- 39 medical research skills (PRISMA, STROBE, STARD)
- Built by physician-researcher, tested on real publications
- Complete E2E pipeline with `orchestrate --e2e`
- Statistical analysis with R metafor
- deidentify skill for privacy protection

### Weaknesses
- Small community (78 stars)
- Limited multimodal capability
- Narrow focus (medical research only)
- No MCP support documented

---

## Summary Table

| Repo | Security | Functional | Integration | Coverage | Weighted Total |
|------|----------|-----------|------------|----------|---------------|
| ARIS | APPROVED | 29/40 | 17/30 | 16/30 | 62/100 |
| AI-Powered-Literature-Review-Skills | APPROVED | 26/40 | 15/30 | 14/30 | 55/100 |
| academic-writing-skills | APPROVED | 26/40 | 18/30 | 15/30 | 59/100 |
| nature-skills | APPROVED | 24/40 | 19/30 | 17/30 | 60/100 |
| scientific-agent-skills | APPROVED | 33/40 | 21/30 | 22/30 | 76/100 |
| citation-assistant | APPROVED | 19/40 | 16/30 | 13/30 | 48/100 |
| paper-plot-skills | APPROVED | 22/40 | 17/30 | 14/30 | 53/100 |
| AI-Research-SKILLs | APPROVED | 27/40 | 19/30 | 20/30 | 66/100 |
| medsci-skills | APPROVED | 31/40 | 18/30 | 22/30 | 71/100 |

**Average Weighted Score:** 61.3/100

**Key Findings:**
1. All 9 repositories PASSED security review
2. medical/epidemiology specialized repos (medsci-skills, scientific-agent-skills) score highest for medical adaptation
3. General research workflow repos (ARIS, AI-Research-SKILLs) score highest for coverage breadth
4. Specialized tools (citation-assistant, paper-plot-skills) score lower but have unique value in their domain