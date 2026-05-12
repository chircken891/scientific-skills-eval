---
name: deepxiv_sdk
description: "Use when searching for academic papers, finding literature, exploring arXiv/PubMed, or needing to review related research"
version: 2
triggers:
  keywords:
    - "search literature"
    - "find papers"
    - "arXiv"
    - "PubMed"
    - "related work"
    - "文献检索"
    - "文献综述"
  scenarios:
    - "literature review stage"
    - "related work section writing"
    - "systematic review setup"
  exclude_when:
    - "writing methodology section"
    - "performing statistical analysis"
    - "generating figures"
model: claude-sonnet-4-20250514
---

# DeepXiv SDK - Literature Search

## Overview
DeepXiv provides progressive reading and multi-database aggregation for academic literature discovery. It supports arXiv, PubMed, and other academic databases.

## When to Use
- Starting a new research topic and need literature review
- Finding related work for your research
- Exploring papers on arXiv or PubMed
- Building a bibliography for your paper

## Process
1. Define search query and scope
2. Execute progressive reading across multiple databases
3. Filter and rank results by relevance
4. Generate annotated bibliography

## Integration
**Phase workflow:**
- **Phase:** Research phase (before planning)
- **Triggers:** "find papers", "search literature", "review related work", "search arXiv", "search PubMed"

**Related skills:**
- **scientific-skills:medsci-skills** - Medical literature search
- **scientific-skills:academic-paper-analysis** - Analyze retrieved papers