---
name: scientific-agent-skills
description: "Use when conducting scientific research, performing data analysis, applying statistical methods, or executing research workflows"
version: 2
triggers:
  keywords:
    - "data analysis"
    - "statistical test"
    - "research workflow"
    - "compute results"
    - "regression"
    - "数据分析"
  scenarios:
    - "quantitative data analysis"
    - "statistical methodology"
    - "research computation"
  exclude_when:
    - "literature search"
    - "paper writing"
    - "figure generation"
model: claude-sonnet-4-20250514
---

# Scientific Agent Skills - Research Methodology

## Overview
Scientific Agent Skills provides 135 skills covering 20+ research domains with comprehensive data analysis and statistical methodology support.

## When to Use
- Conducting data analysis for research
- Applying statistical methods (regression, hypothesis testing, etc.)
- Executing multi-step research workflows
- Performing scientific computation

## Process
1. Define research question and data requirements
2. Select appropriate statistical methods
3. Execute analysis pipeline
4. Interpret results and generate conclusions

## Integration
**Phase workflow:**
- **Phase:** Research and Analysis phases
- **Triggers:** "analyze data", "statistical test", "research workflow", "compute results", "run experiment analysis"

**Related skills:**
- **scientific-skills:paper-plot-skills** - Visualize analysis results
- **scientific-skills:medsci-skills** - Medical statistics
- **scientific-skills:academic-writing-skills** - Write results section