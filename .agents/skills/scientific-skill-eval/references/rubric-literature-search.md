# Rubric: Literature Search

For skills that search academic databases, formulate systematic queries, filter by quality, and deduplicate results.

## Score Criteria

| Score | Criteria |
|-------|----------|
| 5/5 | Multi-database search (PubMed, arXiv, Semantic Scholar, Crossref, etc.) with systematic query formulation (PICO, Boolean operators, MeSH terms). Automated quality filtering by venue rank/citation count. Built-in deduplication across sources. Results export with full metadata (BibTeX, RIS). Search strategy documented in machine-readable format. |
| 4/5 | Supports 3+ databases with Boolean query support. Basic quality filtering (venue rank only). Deduplication available but may miss edge cases. Results export in 1-2 formats. Search strategy partially documented. |
| 3/5 | Supports 1-2 databases with keyword search only. No systematic query tools. Manual filtering required. Basic deduplication (identical duplicate removal only). Results export in single format. |
| 2/5 | Single-database search with limited query syntax. No quality filtering. No deduplication. Output is raw JSON/text without structured metadata. |
| 1/5 | Minimal or no literature search capability. May provide general web search with no academic focus. No structured output. |

## Score Translation

- **5** → 完整系统级检索能力，多库+布尔+过滤+去重+结构化导出
- **4** → 多库支持但某项有缺陷（去重漏检/策略不完整）
- **3** → 单/双库关键词搜索，无系统查询工具，需要人工介入
- **2** → 原始单库查询，输出无结构
- **1** → 几乎没有文献检索能力

## Function Type ID

`literature-search`