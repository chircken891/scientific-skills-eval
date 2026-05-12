---
name: academic-paper-analysis
description: "Use when analyzing existing academic papers, extracting methodology, evaluating paper quality, or understanding research approaches"
version: 2
triggers:
  keywords:
    - "analyze paper"
    - "paper methodology"
    - "extract findings"
    - "paper critique"
    - "论文分析"
  scenarios:
    - "paper reading and understanding"
    - "methodology evaluation"
    - "literature comparison"
  exclude_when:
    - "searching for papers"
    - "writing new content"
    - "generating figures"
model: claude-sonnet-4-20250514
---

# Academic Paper Analysis

## Overview
This skill provides comprehensive analysis of academic papers including methodology extraction, quality evaluation, and structure understanding.

## When to Use
- Reading and understanding a research paper
- Extracting methodology from papers
- Evaluating paper quality and novelty
- Comparing approaches in literature

## Process
1. Parse paper structure (abstract, methods, results, discussion)
2. Extract key contributions and methodology
3. Evaluate strengths and limitations
4. Identify gaps and future directions

## Integration
**Phase workflow:**
- **Phase:** Research phase
- **Triggers:** "analyze this paper", "understand methodology", "extract key findings", "paper critique"

**Related skills:**
- **scientific-skills:deepxiv_sdk** - Source papers for analysis
- **scientific-skills:scientific-agent-skills** - Apply statistical methods found in papers