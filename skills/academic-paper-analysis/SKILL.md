---
name: academic-paper-analysis
description: Comprehensive analysis of academic papers across all domains. Auto-detects domain (medical/engineering/general), integrates MinerU for PDF parsing with automatic page splitting, and produces structured JSON for vault Markdown generation via Templater templates.
---

# Academic Paper Analysis

## CRITICAL RULES — READ FIRST

These rules override any conflicting instructions. Violating any = failed analysis.

| Rule | Requirement |
|------|------------|
| **R1** | `paper_id` = `Author_Year_KeyTopic`. NEVER SHA256 hash. English: `Bin_2022_SocialIsolation`. Chinese: `朱广涵_2024_结直肠癌APC模型`. |
| **R2** | **Paper content = paper language.** Chinese papers (CJK >=30%): analysis in Chinese, same length as English. **Concepts, methods, and knowledge filenames = ALWAYS English** regardless of paper language. Add Chinese translation as `aliases` entry. |
| **R3** | ALL figures/tables in `## Figures & Tables`. Scan MinerU for every `Figure/Fig/表/Table` caption. Tables = Markdown `\| col \| col \|`, figures = `![[Figures/{paper_id}/{name}.png]]`. Missing any = failed. |
| **R4** | `**PDF:** [[path/to/pdf]]` — single line after title. NO separate `## Source PDF` section. |
| **R5** | All 8 template sections non-empty. No placeholder text. No `[SKIPPED]`. Figures extracted, saved, git-committed per Step 4. |
| **R6** | >=1 concept file + >=1 knowledge file per paper. Confirmatory papers: knowledge explains WHY replication matters. |
| **R7** | `## Related` has >=1 [[wikilink]] each to concepts, methods, papers. Never empty subsections. |
| **R8** | Max 2 papers per execution. Quality degrades at 3+. Individual commits per paper. |

---

## Overview

Comprehensive academic paper analysis pipeline: MinerU PDF parsing → IMRaD segmentation → domain detection → chart extraction (PyMuPDF+Vision) → 7-dimension JSON analysis → Templater-based vault Markdown generation.

**Dependencies:** MinerU CLI (`npm i -g mineru-open-api`), PyMuPDF (`pip install PyMuPDF`), Python 3, Vision MCP (`mcp__MiniMax__understand_image`), Defuddle CLI (optional).

**Triggers:** "analyze this paper", "paper critique", "/ingest {source}", "/ingest --force {source}", "/ingest --regenerate"

---

## Pipeline

```
Source → Format Detect → MinerU/Dedupe → IMRaD → Domain → Chart Extract → 7-Dim JSON → Generation → Post-Ingest
```

### Step 1: Input Routing

| Format | Detection | Processing |
|--------|-----------|-------------|
| PDF | `.pdf` + `%PDF-` magic | MinerU pipeline |
| DOCX | `.docx`/`.doc` | Native Read tool |
| HTML/URL | `http` prefix, `.html` | WebFetch / Defuddle |
| Plain text | `.txt`/`.md` | Native Read |

**PDF pages:** ≤20 pages → single `flash-extract`. >20 → auto-split 20-page batches. All batches fail → prompt for API token.

### Step 2: Duplicate Detection

Before processing: SHA256(first 4KB)+mtime fingerprint → check `_log.md` + cache. `status: read` → skip. `status: partial` → resume. `--force` → delete existing paper file + Figures/{paper_id}/ + concept/knowledge files that only reference this paper, then re-analyze.

### Step 3: MinerU Parsing

```bash
mineru-open-api flash-extract "$PDF" -o "/tmp/cc-paper-parser/$$/" 2>&1
# Combine output, save canonical path for downstream steps
cat /tmp/cc-paper-parser/$$/*.md > /tmp/mineru_output.md
echo "MINERU_OUTPUT=/tmp/mineru_output.md"
```

Extract metadata (title, authors, year, journal, doi) from combined Markdown. Cache JSON to `.claude/skills/cache/academic-paper-analysis/{sha256_first_4kb}_{mtime}.json`. TTL: 7 days.

### Step 4: Chart/Figure Extraction (PyMuPDF + Vision)

**Pipeline:** Scan MinerU captions → Extract + filter + dedup images → Match to captions → Vision interpret → Save → Verify.

#### 4a. Scan MinerU for captions FIRST

```bash
grep -n -iE '(Figure|Fig\.?|表|Table)\s*\d+' /tmp/mineru_output.md | head -60
```

#### 4b. Extract images with filtering

```bash
python -c "
import fitz, json, hashlib
doc = fitz.open('<pdf_path>')
results = []; seen_hashes = set()
for page_num in range(len(doc)):
    for img_idx, img in enumerate(doc.get_page_images(page_num)):
        xref = img[0]; img_bytes = doc.extract_image(xref)['image']; size = len(img_bytes)
        if size < 5000: continue  # REJECT junk
        h = hashlib.sha256(img_bytes).hexdigest()
        if h in seen_hashes: continue  # DEDUP
        seen_hashes.add(h)
        ext = doc.extract_image(xref)['ext']
        fname = f'/tmp/cc-paper-imgs/page{page_num+1}_img{img_idx}.{ext}'
        with open(fname, 'wb') as f: f.write(img_bytes)
        results.append({'page': page_num+1, 'file': fname, 'size': size})
print(json.dumps(results, ensure_ascii=False))
"
```

#### 4c. Match images to captions

By page proximity + size ranking. One caption → one image. Unmatched captions → page rendering fallback (4e). Unmatched images → discard.

#### 4d. Vision MCP (REQUIRED for matched figures)

```
mcp__MiniMax__understand_image(
  prompt="Identify: chart type, axis labels, legend, key values, trends. For tables: column headers + sample data.",
  image_source="<absolute_path>"
)
```

If Vision unavailable: save image anyway, use caption text, note "Vision unavailable — caption only". NEVER skip extraction.

#### 4e. Page rendering fallback

For captions without matched embedded images: render page at 200dpi via `page.get_pixmap(dpi=200)`, then Vision.

#### 4f. Save to vault

```bash
mkdir -p Figures/{paper_id}/
cp /tmp/cc-paper-imgs/{image} "Figures/{paper_id}/{FigN_Description}.{ext}"
```

**Naming:** `Fig{N}_{BriefDescription}.{ext}`. Tables from MinerU stay as Markdown — only save table images when MinerU failed to parse.

#### 4g. MANDATORY verification (BLOCKING — do NOT proceed on failure)

**Exception for zero-figure papers:** If 4a found zero captions AND 4b extracted zero images → paper has no figures. Skip Steps 4d-4g. Create empty `Figures/{paper_id}/` directory with a `.gitkeep` file to signal intentional emptiness. The paper file's `## Figures & Tables` section should note: "*(本文无图表 / No figures or tables in this paper)*".

**For papers WITH captions:**

```bash
# 1. Directory exists with files
test -d "Figures/{paper_id}/" || { echo "BLOCKED: Figures/{paper_id}/ missing — re-run Step 4"; exit 1; }
FIG_COUNT=$(ls "Figures/{paper_id}/" 2>/dev/null | wc -l)
test "$FIG_COUNT" -gt 0 || { echo "BLOCKED: Figures/{paper_id}/ empty — re-run Step 4e (page rendering)"; exit 1; }
# 2. Caption count matches figure count (from 4a)
CAPTION_COUNT=$(grep -ciE '(Figure|Fig\.?|表|Table)\s*\d+' /tmp/mineru_output.md 2>/dev/null || echo 0)
echo "Captions: $CAPTION_COUNT, Figures: $FIG_COUNT"
# 3. No junk files
JUNK=$(find "Figures/{paper_id}/" -type f -size -5k 2>/dev/null | wc -l)
test "$JUNK" -eq 0 || echo "WARN: $JUNK file(s) <5KB — possible junk"
# 4. Paper MUST embed at least one figure
grep -q '!\[\[' "Wiki/sources/{paper_id}.md" || { echo "BLOCKED: no ![[ figure embed in paper"; exit 1; }
```

**If ANY check fails:** Do NOT proceed to Step 5. Re-run extraction or page rendering. This gate is non-negotiable.

#### 4h. Cleanup temp only (keep vault figures)

```bash
rm -rf /tmp/cc-paper-imgs/
```

### Step 5: Domain Detection

Count signals in title+abstract+first 500 chars of Methods:
- **Medical:** disease, patient, clinical, OR=, HR=, 95%CI, trial, RCT, cohort, case-control, incidence, mortality, prevalence, prognosis, biomarker, systematic review, meta-analysis, longitudinal, prospective, retrospective, diagnosis, treatment, survival, hazard
- **Engineering:** algorithm, optimization, simulation, RMSE, F1-score, accuracy, ablation, convergence, iteration, benchmark, throughput, latency

≥2 signals → lock domain. <2 both → "General".

### Step 6: IMRaD Segmentation

Heading patterns (case-insensitive regex): `Abstract\|摘要`, `Introduction\|引言\|Background`, `Methods?\|方法\|Materials`, `Results?\|结果\|Findings`, `Discussion\|讨论`, `Conclusion\|总结`, `References\|参考文献`. Content fallback: dense stats → Results; OR=/HR=/p< → Results; limitations/howevers → Discussion.

Non-IMRaD detection: "Search Strategy"/"PRISMA" → Systematic Review; "Forest Plot"/"Heterogeneity" → Meta-analysis; "Case Report"/"Case Description" → Case Report. No sections → label "Unstructured".

**Language:** CJK >=30% → Chinese output, else English.

---

## Simplified Method Index

| Method | Category | Domain | Keywords |
|--------|----------|--------|----------|
| Kaplan-Meier | Survival Analysis | Medical | survival curve, log-rank, censored |
| Log-rank Test | Survival Analysis | Medical | survival comparison |
| Competing Risks | Survival Analysis | Medical | Fine-Gray, cumulative incidence |
| Cox Proportional Hazards | Regression | Medical | HR, hazard ratio |
| Linear Regression | Regression | General | OLS, beta coefficient |
| Logistic Regression | Regression | Medical | odds ratio, OR, logit |
| Poisson Regression | Regression | Medical | count data, rate ratio |
| Joinpoint Regression | Time Series | Medical | segmented, trend change, APC |
| APC & AAPC | Time Series | Medical | annual percent change |
| Cox-Stuart Trend | Time Series | Medical | monotonic trend |
| ARIMA | Time Series | Engineering | autoregressive, forecast |
| Propensity Score Matching | Causal Inference | Medical | PSM, ATT, confounding |
| Instrumental Variable | Causal Inference | Medical | IV, 2SLS, endogeneity |
| DID | Causal Inference | Medical | difference-in-differences |
| Mendelian Randomization | Causal Inference | Medical | genetic instrument, SNP |
| Fixed Effects Model | Meta-Analysis | Medical | common effect, inverse variance |
| Random Effects Model | Meta-Analysis | Medical | DerSimonian, tau-squared |
| Meta-Regression | Meta-Analysis | Medical | moderator, subgroup |
| PCA | Dimensionality Reduction | Engineering | principal component |
| Factor Analysis | Dimensionality Reduction | Engineering | latent variable, loadings |
| K-Means | Clustering | Engineering | centroid, partition |
| Bayesian Hierarchical | Bayesian | Medical | MCMC, prior, posterior |
| Multiple Imputation | Missing Data | Medical | MI, MAR |
| E-value | Sensitivity | Medical | unmeasured confounding |
| GRADE | Bias Assessment | Medical | evidence quality, certainty |
| Narrative Review | Review | Medical | qualitative synthesis |
| Systematic Review (PRISMA) | Review | Medical | PRISMA, eligibility criteria |
| Thematic Analysis | Qualitative | Medical | themes, coding, patterns |
| Three-Level Meta-Analysis | Meta-Analysis | Medical | multilevel, dependent effects |
| Egger's Regression | Publication Bias | Medical | funnel plot asymmetry |
| Trim-and-Fill | Publication Bias | Medical | Duval, imputation |
| Spearman Correlation | Statistical Tests | Medical | Spearman, rank, rho, non-parametric |
| Chi-square / Fisher Exact | Statistical Tests | Medical | chi-square, contingency, Fisher |
| Mediation Analysis | Causal Inference | Medical | indirect effect, bootstrap, PROCESS, mediation |
| Mixed-effects Models | Regression | Medical | LMM, GLMM, random intercept, repeated measures |
| APC Model | Time Series | Medical | age-period-cohort, identifiability, temporal trends |
| Subgroup Analysis | Analytical Strategy | Medical | stratified, effect modification, interaction |

Match methods by fuzzy name+keyword. Found → `[[Schema/methods/{filename}\|{name}]]`. Not found → extract from paper, create new Schema entry.

---

## JSON Intermediate Schema

Cache: `.claude/skills/cache/academic-paper-analysis/{cache_key}.json`

```json
{
  "version": "v4", "parsed_at": "ISO8601", "pdf_path": "...", "format": "pdf|html|docx|txt",
  "paper": {
    "paper_id": "Author_Year_KeyTopic", "title": "...", "authors": "...",
    "journal": "...", "publication_year": 2024, "doi_url": "...", "domain": "Medical|Engineering|General",
    "abstract": "..."
  },
  "key_findings": [{
    "finding_summary": ">=500 chars", "disease_condition": "...|N/A", "population": "...",
    "effect_size": "OR/HR/improvement%", "ci": "95%CI or N/A", "p_value": "P<x or N/A",
    "significance": ">=300 chars"
  }],
  "study_designs": [{
    "design_name": "...", "description": ">=300 chars", "indications": "...",
    "limitations": ">=200 chars", "examples": "..."
  }],
  "statistical_methods": [{
    "method_name": "...", "category": "...", "purpose": ">=150 chars", "formula": "LaTeX or N/A",
    "steps": "...", "assumptions": "...", "limitations": ">=200 chars", "software": "..."
  }],
  "concepts": [{
    "concept_name": "...",  // ALWAYS English (R2). Chinese → translate + add as alias. "definition": ">=100 chars", "category": "...",
    "related_concepts": "...", "examples": "..."
  }],
  "table_layouts": [{
    "table_name": "Fig/Table N: caption", "purpose": ">=100 chars",
    "structure": "Vision interpretation", "formatting": "...", "examples": "..."
  }],
  "general_knowledge": {
    "concept_name": "...", "key_points": ">=500 chars", "category": "...",
    "references": ["ref1", "ref2", "ref3"]
  }
}
```

**Field-to-Template Mapping:**

| JSON | Template | Vault Path |
|------|----------|------------|
| paper + key_findings + table_layouts | tpl-paper | Wiki/sources/{paper_id}.md |
| study_designs + statistical_methods | tpl-method | Schema/methods/{name}.md (dedup by name) |
| concepts | tpl-concept | Wiki/concepts/{name}.md |
| general_knowledge | tpl-knowledge | Wiki/knowledge/{name}.md |

---

## 7-Dimension Analysis Engine

Populate all 7 dimensions into JSON. Each field has mandatory length/format checks. Refine until ALL pass. Construct complete JSON with `version: "v4"` and `parsed_at` timestamp.

### Quality Verification (run after JSON assembly and after writing paper file)

```
## JSON Quality
- [ ] paper: paper_id=Author_Year_KeyTopic, title non-empty, year=4-digit
- [ ] key_findings[n]: finding_summary >=500 chars, significance >=300 chars
- [ ] study_designs[n]: description >=300 chars, limitations >=200 chars
- [ ] statistical_methods[n]: purpose >=150 chars, limitations >=200 chars
- [ ] concepts[n]: [PRESENT] definition >=100 chars (R6: >=1 required)
- [ ] table_layouts[n]: purpose >=100 chars per chart/table (R3: must match paper count)
- [ ] general_knowledge: key_points >=500 chars, references >=3 (R6: >=1 required)

## Template Section Compliance (run on generated paper file)
- [ ] ## Abstract — non-empty
- [ ] ## Key Findings — >=1 Finding with all 5 fields
- [ ] ## Study Design — Type, Description (>=300), Limitations (>=200)
- [ ] ## Methods — >=1 ### method with 5 fields + wikilink
- [ ] ## Figures & Tables — ALL captions from 4a accounted for
- [ ] ## Discussion — Limitations, Conclusion Validity, New Concepts
- [ ] ## Quality Checklist — 7 rows, `- [ ]` UNCHECKED
- [ ] ## Related — Concepts + Methods + Papers links present
```

**R2 language rule:** Chinese papers — all fields in Chinese, same length requirements as English.

---

## Generation Phase

Deterministic JSON→vault mapping. NO LLM free-form generation. Runs after JSON passes quality verification.

**Flow:** Read JSON → Validate schema → Generate paper → Generate methods (deduped) → Generate concepts (deduped) → Generate knowledge → Pre-Write Validation → Write files.

**Status lifecycle:** `partial` (generation in progress) → `read` (all files verified and written).

### 1. Paper File (Wiki/sources/{paper_id}.md)

**Frontmatter:** title, type:"paper", status:"partial"/"read", authors:[], year, journal, doi, domain, tags, rating:0, relation_type:"supports", generated_by:"academic-paper-analysis", ingested:YYYY-MM-DD, aliases:[paper_id]

**Content (fill tpl-paper sections):**

`# {title}` → `**PDF:** [[path]]` → `## Abstract` → `## Key Findings` (### Finding N with Summary/Effect Size/CI/p-value/Significance) → `## Study Design` (Type/Description/Limitations) → `## Methods` (### {name} with Category/Purpose/Formula/Assumptions/Limitations/Software + wikilink) → `## Figures & Tables` (Tables as Markdown from MinerU, Figures with ![[embed]]) → `## Discussion` (Limitations/Conclusion Validity/New Concepts) → `## Quality Checklist` (7 rows, `- [ ]` UNCHECKED) → `## Related` (### Concepts, ### Methods, ### Papers with wikilinks)

### 2-4. Method/Concept/Knowledge Files

**Deduplication:** Check if file exists → EXISTS: skip, append paper to source_papers. NEW: create from tpl-{method\|concept\|knowledge}.

### Wikilink Rules

Paper→Methods: `[[Schema/methods/{file}.md\|{name}]]`, Paper→Concepts: `[[Wiki/concepts/{file}.md\|{name}]]`, Paper→Knowledge: `[[Wiki/knowledge/{file}.md\|{name}]]`, All→Paper: `[[Wiki/sources/{paper_id}.md\|{title}]]`

---

## Pre-Write Validation

Every .md file MUST pass 3 checks before write. Fail → retry (max 3) → if still fails, `status: partial`.

### Check 1: YAML Parseable
`---` delimiters present, valid key:value pairs, no unquoted colons, arrays use `["a","b"]` syntax, special chars quoted.

### Check 2: [[Wikilink]] Valid
All `[[` have matching `]]`. Pattern: `[[path/to/file.ext|Display]]`. No nested brackets. Allowed: Wiki/sources/, Wiki/concepts/, Wiki/knowledge/, Schema/methods/.

### Check 3: Required Fields Non-Empty
| Template | Required |
|----------|----------|
| tpl-paper | title, type, authors, year, journal, doi, domain, ingested, aliases |
| tpl-method | title, type, category, domain, source_papers, created |
| tpl-concept | title, type, domain, definition, source_papers |
| tpl-knowledge | title, type, category, key_points, references |

---

## Post-Ingest Actions

### Git Commit (MANDATORY — per paper, never batch)

```bash
# Verify Figures/ exists and has content BEFORE git add
test -d "Figures/{paper_id}/" || { echo "BLOCKED: Figures/{paper_id}/ missing"; exit 1; }
test $(ls "Figures/{paper_id}/" | wc -l) -gt 0 || { echo "BLOCKED: Figures/{paper_id}/ empty"; exit 1; }

# Commit all files for this paper
git add "Wiki/sources/{paper_id}.md" "Wiki/concepts/{c}.md" "Wiki/knowledge/{k}.md" \
  "Schema/methods/{m}.md" "Figures/{paper_id}/" "Wiki/_log.md"
git commit -m "ingest: {paper_id}"

# Verify figures are tracked
git ls-files "Figures/{paper_id}/" | wc -l  # MUST be > 0
```

### Update _log.md
Append: `| {YYYY-MM-DD HH:mm} | ingest | Wiki/sources/{paper_id}.md | {title} — {n} methods, {n} concepts |`

### Summary Output
```
=== Ingest Complete ===
Paper: {paper_id} ({title})
Files: 1 paper, {n} methods, {n} concepts, 1 knowledge
Quality: ALL 7 DIMENSIONS PASS
Figures: {n} extracted, git-tracked
```

---

## Output Modes

| Mode | Trigger | What runs |
|------|---------|-----------|
| Full | "analyze this paper" | Pipeline steps 1-9 |
| Quick | "quick analysis" | Metadata + key findings only |
| Extract only | "just extract the data" | IMRaD + charts → JSON cached, skip generation |
| **Figures only** | "extract figures only" | Step 4 only — re-extract figures for an existing paper. Preserves existing .md files. |
| Regenerate | "regenerate from cache" | Read cache JSON → re-run Generation Phase |
| Re-analyze | --force | Ignore cache, full pipeline from scratch |

---

## Error Recovery

**Partial File Preservation:** Files written before failure point remain with `status: partial`. Last checkpoint logged. JSON preserved in cache.

**Resume protocol:** Compute fingerprint → check _log.md for checkpoints → resume after last checkpoint:

| Last Checkpoint | Resume From |
|----------------|-------------|
| (none) | Step 1: full pipeline |
| Generation-Methods | Concepts step |
| Generation-Concepts | Knowledge step |
| Generation-Knowledge | Post-Ingest |

**Error reference:**

| Scenario | Action |
|----------|--------|
| MinerU not installed | Warn + fallback native Read |
| flash-extract fails | Retry 1×, then prompt API token |
| PDF corrupted | Notify, stop |
| Vision unavailable | Save image, use caption, note "Vision unavailable" |
| All Vision fails | Populate from captions, mark in structure |
| No embedded images | Page rendering fallback |
| File write fails | Retry 1×, mark partial |
| Template missing | Abort — required template not found |
| Pre-write validation fails | Retry ≤3×, mark partial |
| Hard constraint fails | Iterate until pass |

---

## Process

1. Accept input (file/URL/text) with optional `--force`, `--regenerate`
2. Duplicate check (_log.md + cache)
3. Format detect → parser route (MinerU/Defuddle/Read)
4. PDF: MinerU with page detection, extract metadata, cache JSON
5. Chart extraction: PyMuPDF filter+dedup → Vision → save to Figures/
6. IMRaD segmentation → domain detect → method index match
7. 7-dimension analysis with quality constraints → JSON cache
8. Generation: JSON → tpl-* templates → pre-write validation → write .md
9. Post-Ingest: git commit (including Figures/) → _log.md → summary

## References
- `Schema/methods/` — Method library (30+ files)
- `Templates/tpl-{paper,concept,method,knowledge}.md` — Output templates
- `scientific-skills:deepxiv_sdk` — Paper sourcing
- `scientific-skills:scientific-agent-skills` — Method application
