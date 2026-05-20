---
name: academic-paper-analysis
description: "Comprehensive academic paper analysis across all domains. Auto-detects domain (medical/engineering/general), MinerU PDF parsing with Vision chart extraction, 7-dimension JSON intermediate output, Obsidian vault knowledge graph generation."
version: 4
triggers:
  keywords:
    - "analyze paper"
    - "paper methodology"
    - "extract findings"
    - "paper critique"
    - "论文分析"
    - "analyze this paper"
    - "/ingest"
    - "detailed analysis"
  scenarios:
    - "paper reading and deep analysis"
    - "methodology extraction and evaluation"
    - "structured knowledge base building"
    - "systematic literature review"
  exclude_when:
    - "searching for papers (use deepxiv_sdk)"
    - "writing new content (use academic-writing-skills)"
    - "generating figures from data (use paper-plot-skills)"
model: claude-opus-4-7
---

# Academic Paper Analysis

## Overview

Comprehensive academic paper analysis pipeline: MinerU PDF parsing → IMRaD segmentation → domain detection (medical/engineering/general) → PyMuPDF+Vision chart extraction → 7-dimension JSON intermediate → Markdown report. In Obsidian vaults, additionally generates knowledge graph files (paper/concept/method/knowledge) with wikilinks.

**Key improvements (v4):** JSON intermediate output (no SQLite), Author_Year_KeyTopic paper IDs, 35-method inline index with self-growing, mandatory chart extraction gate, dedup via SHA256 fingerprint, vault auto-detection.

## When to Use
- Deep analysis of a research paper (all domains)
- Extracting methodology with hard quality constraints
- Building structured paper knowledge base
- Comparing approaches across papers
- PDF parsing with charts/figures extraction

## Process

1. **Input routing:** Format detect → MinerU/Dedup (≤20pp single, >20 auto-split)
2. **Chart extraction:** PyMuPDF filter+dedup (size≥5KB) → Vision MCP interpretation → Figures/{paper_id}/
3. **Domain detection:** Medical/Engineering/General via keyword signal counting
4. **IMRaD segmentation:** Heading regex + content fallback, non-IMRaD detection
5. **7-dimension JSON:** paper, key_findings, study_designs, statistical_methods, concepts, table_layouts, general_knowledge — all with hard length constraints
6. **Report generation:** Structured Markdown + vault files (if `.obsidian/` detected)
7. **Post-ingest:** git commit per paper, _log.md update

## Integration

**Triggers:** "analyze this paper", "paper critique", "/ingest {source}", "detailed analysis", "quick analysis"

**Output modes:** Full (pipeline + report), Quick (metadata + findings only), Extract only (JSON cache), Figures only (re-extract), Regenerate (from cache), Re-analyze (--force)

**Related skills:**
- **scientific-skills:deepxiv_sdk** — Source papers for analysis
- **scientific-skills:scientific-agent-skills** — Apply methods found in papers