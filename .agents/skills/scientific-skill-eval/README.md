# scientific-skill-eval

Systematically evaluate academic and research Claude Code skills through a two-stage assessment architecture.

## What It Does

- **Security Veto (Tier 0)** — Four hard checks run first. Any failure = immediate EXCLUDE.
- **Professional Depth Scoring (Tier 1)** — Score the skill's 1-2 strongest functions 1-5 using function-specific rubrics.
- **Integration Assessment (Tier 2)** — Five descriptive 1-5 scores (not used for classification).
- **Classification** — EXCLUDE (<3.0) / CANDIDATE (3.0-4.0) / AUTO-RECOMMEND (>4.0)

## Quick Start

### Evaluate a skill (any of these ways)

```bash
# From GitHub URL
@ scientific-skill-eval --url https://github.com/user/skill-name

# From local path
@ scientific-skill-eval --local ./skills/my-skill

# By installed skill name
@ scientific-skill-eval --name medsci-skills
```

### Output formats

```bash
# Default: markdown to terminal
@ scientific-skill-eval --name medsci-skills

# Write to file
@ scientific-skill-eval --name medsci-skills --output ./report.md

# JSON format (all 22 fields)
@ scientific-skill-eval --name medsci-skills --format json

# TSV format (spreadsheet-ready)
@ scientific-skill-eval --name medsci-skills --format tsv
```

### Full evaluation mode (user specifies functions)

```bash
@ scientific-skill-eval --url https://github.com/user/skill --mode full --functions "Medical Domain" "Statistical Analysis"
```

### Batch evaluation

```bash
@ scientific-skill-eval --batch ./skills-to-evaluate.tsv --output ./eval-results/
```

See `examples/batch-input-example.tsv` for the input format.

## Security Checks

Four non-negotiable checks run before any scoring:

| Check | Fails if |
|-------|----------|
| 数据安全 | Hardcoded API keys, credentials, or secrets in code |
| 权限范围 | Unnecessary filesystem/network permissions |
| 网络请求 | Undeclared third-party API calls |
| 依赖来源 | Non-transparent or vulnerable dependencies |

Any FAIL = immediate EXCLUDE, no scoring performed.

## Function Types (10 rubrics)

| Rubric | What it evaluates |
|--------|-------------------|
| literature-search | Multi-database search, Boolean queries, deduplication |
| literature-review | PRISMA-compliant screening, synthesis, evidence tables |
| academic-writing | LaTeX/Typst, journal-adaptive style, multi-round revision |
| figure-generation | Publication-ready figures, multi-format export |
| statistical-analysis | Hypothesis testing, regression, R/Python integration |
| citation-management | BibTeX generation, multi-source, style conversion |
| medical-domain | Epidemiology, PRISMA/STROBE/CONSORT compliance |
| research-tool | Modular library, multi-agent orchestration |
| workflow-orchestration | Multi-stage pipeline, checkpoints, error recovery |
| journal-specific | Nature/Science/Cell formatting, reviewer response |

## Scripts

```bash
# Security check only
python scripts/security_check.py ./skills/my-skill

# Single skill evaluation
python scripts/evaluate.py --local ./skills/my-skill --mode quick

# Batch evaluation
python scripts/batch.py --input skills.tsv --output ./results/
```

## Classification Thresholds

| DepthScore | Classification | Meaning |
|------------|----------------|---------|
| < 3.0 | EXCLUDE | Does not meet minimum quality bar |
| 3.0 - 4.0 | CANDIDATE | Suitable but not exceptional |
| > 4.0 | AUTO-RECOMMEND | Strong candidate for scientific-skills bundle |

## Files

```
scientific-skill-eval/
├── SKILL.md                    # Core workflow (read by LLM)
├── references/
│   ├── scoring-guide.md        # How to assign scores (read by LLM)
│   └── rubric-*.md             # 10 function-type scoring tables
├── scripts/
│   ├── security_check.py       # Security veto checks
│   ├── evaluate.py             # Single skill evaluator
│   └── batch.py                # Batch evaluator
├── evals/evals.json            # Test cases
└── examples/
    └── batch-input-example.tsv # Batch input template
```

## Notes

- Scoring is done by the LLM using the rubric files — scripts handle data gathering and security checks
- Specialization is rewarded; a narrow-but-deep skill scores higher than a broad-but-shallow one
- Security veto runs independently of scoring; any security failure stops the evaluation immediately