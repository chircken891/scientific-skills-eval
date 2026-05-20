---
name: academic-writing-skills
description: "Use when writing academic papers, preparing manuscripts, formatting with LaTeX/Typst/Word, or structuring research documents"
version: 2
triggers:
  keywords:
    - "write paper"
    - "draft manuscript"
    - "LaTeX"
    - "学术写作"
    - "paper formatting"
  scenarios:
    - "manuscript drafting"
    - "document formatting"
    - "multi-round revision"
  exclude_when:
    - "data analysis"
    - "literature search"
    - "figure creation"
model: claude-sonnet-4-20250514
---

# Academic Writing Skills

## Overview
Academic Writing Skills provides multi-format support (LaTeX, Typst, Word) with multi-round revision workflow for producing publication-quality academic documents.

## When to Use
- Writing research papers, theses, or proposals
- Formatting documents for specific journals
- Structuring academic manuscripts
- Preparing submission-ready documents

## Process
1. Define document structure and target format
2. Draft sections following academic conventions
3. Multi-round revision for clarity and coherence
4. Format according to target journal guidelines

## Integration
**Phase workflow:**
- **Phase:** Writing phase (after analysis)
- **Triggers:** "write paper", "draft manuscript", "format document", "LaTeX", "academic writing"

**Related skills:**
- **scientific-skills:academic-paper-analysis** - Reference similar papers
- **scientific-skills:Paper-Polish-Workflow-skill** - Polish final submission
- **scientific-skills:paper-plot-skills** - Include figures in manuscript