# Rubric: Citation Management

For skills that handle bibliographic references: search, BibTeX generation, venue quality assessment, DOI/arXiv handling.

## Score Criteria

| Score | Criteria |
|-------|----------|
| 5/5 | Multi-source citation search (Crossref, DOI, arXiv, PubMed, ISBN). Automatic BibTeX/BibLaTeX generation with complete metadata. Venue quality assessment (ISSN/rank/impact factor integration). Batch citation import/export. Citation style conversion (APA, MLA, Chicago, Nature, etc.). Duplicate detection across sources. RIS/.bib/.csv export. |
| 4/5 | Citation search from 2-3 sources. BibTeX generation with mostly complete metadata. Basic venue check. Multiple style conversion. Good single-citation workflow. |
| 3/5 | Single-source citation lookup (DOI or arXiv). BibTeX generation with basic metadata. Limited style support. Functional for individual citations. |
| 2/5 | Manual citation entry only. Basic BibTeX output with missing fields. No venue assessment. No style conversion. |
| 1/5 | Cannot manage citations. May provide general text about references without structured output. |

## Score Translation

- **5** → 多源检索+完整元数据+期刊质量评估+批量导入导出+去重
- **4** → 2-3源+基本期刊检查，但去重/批量功能有缺陷
- **3** → 单源（DOI或arXiv），基础BibTeX
- **2** → 手动录入，BibTeX字段不完整
- **1** → 无引用管理能力

## Function Type ID

`citation-management`