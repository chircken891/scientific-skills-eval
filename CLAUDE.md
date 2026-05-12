# Scientific Skills - Research Workflow Documentation

This bundle provides a complete scientific research workflow for Claude Code, covering literature review through publication.

## Core Skills (7 Academic Skills)

### 1. deepxiv_sdk - Literature Search
**Trigger:** "find papers", "search literature", "review related work", "search arXiv", "search PubMed"

Progressive reading and multi-database aggregation for academic literature discovery.

### 2. academic-paper-analysis - Paper Analysis
**Trigger:** "analyze this paper", "understand methodology", "extract key findings", "paper critique"

Comprehensive analysis of academic papers including methodology extraction and quality evaluation.

### 3. scientific-agent-skills - Research Methodology
**Trigger:** "analyze data", "statistical test", "research workflow", "compute results"

135 skills covering 20+ research domains with comprehensive data analysis and statistics.

### 4. academic-writing-skills - Paper Writing
**Trigger:** "write paper", "draft manuscript", "format document", "LaTeX", "academic writing"

Multi-format support (LaTeX, Typst, Word) with multi-round revision workflow.

### 5. paper-plot-skills - Figure Generation
**Trigger:** "create figure", "make plot", "generate chart", "visualize data"

9 types of publication-quality scientific figures with plot-from-image capability.

### 6. Paper-Polish-Workflow-skill - Submission Polish
**Trigger:** "polish paper", "submission ready", "check language", "prepare for journal"

16 polishing skills with de-AI-ification for submission-ready manuscripts.

### 7. medsci-skills - Medical Research
**Trigger:** "medical research", "clinical study", "PRISMA", "STROBE", "epidemiology"

PRISMA/STROBE compliance, medical statistics, and clinical research methodology.

---

## Scientific Workflow Order

The scientific workflow follows a structured sequence:

```
Research Phase → Analysis Phase → Writing Phase → Submission Phase
     ↓               ↓               ↓               ↓
  deepxiv_sdk   scientific-agent  academic-writing  Paper-Polish
                   -skills             -skills      -Workflow
       ↓               ↓               ↓               ↓
  academic-paper   paper-plot      medsci-skills   (complete)
   -analysis        -skills
```

### HARD-GATE Critical Nodes

**HARD-GATE 1: Research before Planning**
- MUST complete literature review before creating implementation plan
- Trigger: Any new research domain

**HARD-GATE 2: Design before Writing**
- MUST complete paper structure and methodology design before writing
- Trigger: Academic manuscript preparation

**HARD-GATE 3: Analysis before Visualization**
- MUST complete data analysis before creating figures
- Trigger: Figure generation requests

**HARD-GATE 4: Confirm before Execution**
- MUST confirm approach with user before executing major research steps
- Trigger: Key implementation decisions

---

## Capability Boundaries

### What This Bundle Handles
- Literature search and paper analysis
- Scientific data analysis and statistics
- Academic paper writing and formatting
- Scientific figure creation
- Paper polishing for submission
- Medical research compliance (PRISMA/STROBE)

### What This Bundle Does NOT Handle
- Direct internet access beyond literature databases
- Data collection or experiment execution
- Peer review or journal submission
- Grant application management

### External Skills (Independent Installation)
- **everything-claude-code**: Claude Code general enhancement
- **gsd**: Get Shit Done methodology
- **superpowers**: Software development methodology

---

## Skill Invocation

Skills are invoked through natural language trigger matching:

1. **Exact match**: Direct trigger phrase (e.g., "search arXiv")
2. **Fuzzy fallback**: Semantic similarity to trigger descriptions
3. **Smart routing**: Intent parsing through scientific-do coordinator

### Invocation Examples

```bash
# Literature search
User: "Find recent papers on transformer architecture"
→ Invokes: deepxiv_sdk

# Data analysis
User: "Run a regression analysis on this dataset"
→ Invokes: scientific-agent-skills

# Figure creation
User: "Create a bar chart showing the results"
→ Invokes: paper-plot-skills
```

---

## Extension Skills (On-demand)

The following skills are available as extensions but not included in the core bundle:

| Extension | Primary Use | Install Command |
|-----------|------------|-----------------|
| nature-skills | Nature journal submission | `claude skill install https://github.com/Yuan1z0825/nature-skills` |
| claude-scholar | Citation management | `claude skill install https://github.com/yy/claude-scholar` |
| scientify | OpenClaw integration | `claude skill install https://github.com/scientify/scientify` |

---

## Integration with GSD Framework

This bundle integrates with the Get Shit Done (GSD) methodology:

- **research phase**: deepxiv_sdk + academic-paper-analysis
- **planning phase**: scientific-agent-skills (methodology)
- **execution phase**: scientific-agent-skills (analysis) + paper-plot-skills
- **writing phase**: academic-writing-skills + medsci-skills
- **submission phase**: Paper-Polish-Workflow-skill

---

*Last updated: 2026-05-12*
*Bundle version: 1.0.0*