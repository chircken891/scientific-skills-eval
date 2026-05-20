# Scientific Skills Bundle

A complete scientific research workflow for Claude Code, covering literature review through publication.

## Installation

### Core Bundle Installation

This bundle is designed to be placed in your Claude skills directory:

```bash
# Copy to your Claude skills directory
cp -r /path/to/scientific-skills ~/.claude/scientific-skills/
```

### Individual Skill Installation (Alternative)

If you prefer individual installation:

```bash
claude skill install https://github.com/DeepXiv/deepxiv_sdk
claude skill install https://github.com/K-Dense-AI/scientific-agent-skills
claude skill install https://github.com/bahayonghang/academic-writing-skills
claude skill install https://github.com/Boom5426/paper-plot-skills
claude skill install https://github.com/Lylll9436/Paper-Polish-Workflow-skill
claude skill install https://github.com/MedgeClaw/medsci-skills
```

## Skills Overview

| Skill | Purpose | Trigger Keywords |
|-------|---------|------------------|
| deepxiv_sdk | Literature search | "find papers", "search arXiv", "search PubMed" |
| academic-paper-analysis | Paper analysis | "analyze paper", "understand methodology" |
| scientific-agent-skills | Research methodology | "analyze data", "statistical test" |
| academic-writing-skills | Paper writing | "write paper", "LaTeX", "format document" |
| paper-plot-skills | Figure generation | "create figure", "make plot", "chart" |
| Paper-Polish-Workflow-skill | Submission polish | "polish paper", "submission ready" |
| medsci-skills | Medical research | "PRISMA", "STROBE", "clinical study" |

## Usage Examples

### Literature Review

```
User: Find recent papers on machine learning for medical imaging
→ deepxiv_sdk activates, searches arXiv/PubMed, returns annotated bibliography
```

### Paper Analysis

```
User: Analyze this paper and extract the methodology
→ academic-paper-analysis activates, parses paper, identifies key contributions
```

### Data Analysis

```
User: Run a t-test on these two groups
→ scientific-agent-skills activates, executes statistical analysis, reports results
```

### Figure Creation

```
User: Create a publication-quality bar chart from this data
→ paper-plot-skills activates, generates figure in journal-compatible format
```

### Paper Writing

```
User: Write the methods section for my clinical study
→ academic-writing-skills activates, drafts section with PRISMA compliance
```

### Submission Polish

```
User: Prepare my paper for journal submission
→ Paper-Polish-Workflow-skill activates, performs language check and formatting
```

## Scientific Workflow

The bundle follows a structured research workflow:

```
1. Research
   └─ deepxiv_sdk (literature search)
   └─ academic-paper-analysis (paper analysis)

2. Analysis
   └─ scientific-agent-skills (data analysis)
   └─ medsci-skills (medical statistics)

3. Writing
   └─ academic-writing-skills (manuscript preparation)
   └─ paper-plot-skills (figure creation)

4. Submission
   └─ Paper-Polish-Workflow-skill (polishing and formatting)
```

## Extension Skills

Additional skills available on-demand:

| Skill | Purpose | Install |
|-------|---------|---------|
| nature-skills | Nature journal specific formatting | `claude skill install https://github.com/Yuan1z0825/nature-skills` |
| claude-scholar | Citation management | `claude skill install https://github.com/yy/claude-scholar` |
| scientify | OpenClaw ecosystem integration | `claude skill install https://github.com/scientify/scientify` |

## Directory Structure

```
scientific-skills/
├── .claude-plugin/
│   ├── plugin.json          # Plugin metadata
│   └── marketplace.json     # Marketplace config
├── skills/
│   ├── deepxiv_sdk/         # Literature search
│   ├── academic-paper-analysis/  # Paper analysis
│   ├── scientific-agent-skills/  # Data analysis
│   ├── academic-writing-skills/  # Paper writing
│   ├── paper-plot-skills/   # Figure generation
│   ├── Paper-Polish-Workflow-skill/  # Submission polish
│   └── medsci-skills/       # Medical research
├── hooks/
│   └── session-start        # Startup injection
├── CLAUDE.md                # Scientific workflow documentation
└── README.md               # This file
```

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-05-12 | Initial release with 7 core academic skills |

## License

Research Team - For academic and scientific use.