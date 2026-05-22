---
name: scientific-skill-eval
description: Systematically evaluate academic and research Claude Code skills through a two-stage assessment (security veto + professional depth scoring). Use when asked to evaluate, assess, score, or review a scientific skill — including "evaluate this skill", "assess https://github.com/...", "rate this research skill", "skill quality review", "run full evaluation". Triggers on evaluation requests for literature search, academic writing, statistical analysis, medical research, citation management, figure generation, and related research tool skills. Does NOT trigger for general code review or non-research skills.
allowed-tools: Read Write Edit Bash Grep Glob
license: MIT license
metadata:
    skill-author: scientific-skills bundle
    version: 1.0.0
---

# scientific-skill-eval

## Overview

A structured evaluation system for academic and research Claude Code skills. Applies a **two-stage assessment architecture**:

1. **Security Veto (Tier 0)** — Four hard checks run first, independently of scoring. Any failure = immediate EXCLUDE.
2. **Professional Depth Scoring (Tier 1)** — Evaluate the skill's 1-2 strongest functions on a 1-5 scale per function-type rubric.
3. **Integration Assessment (Tier 2)** — Five descriptive 1-5 scores for integration difficulty.

Final classification: EXCLUDE (<3.0) / CANDIDATE (3.0-4.0) / AUTO-RECOMMEND (>4.0).

## When to Use

Invoke this skill when the user asks to:
- "Evaluate this skill" / "评测这个 skill"
- "evaluate https://github.com/user/skill"
- "对这个 skill 打分" / "对 ... 评分"
- "Run a full evaluation" / "跑完整评测"
- "批量评测这组 skills" / "batch evaluate"
- "Assess research skill quality" / "科研 skill 质量评估"

Do **not** invoke for general code review, non-research tool evaluation, or requests clearly outside academic/research scope.

## Evaluation Modes

### Mode A — Quick Evaluation (default)
```bash
@ scientific-skill-eval --url https://github.com/user/skill-name
@ scientific-skill-eval --local ./skills/medsci-skills
@ scientific-skill-eval --name medsci-skills
```
Fully automatic: security checks → function inference → scoring → markdown report to terminal.

### Mode B — Full Evaluation
```bash
@ scientific-skill-eval --url https://github.com/user/skill-name --mode full --functions "Medical Domain" "Statistical Analysis"
```
User specifies function priorities for more precise evaluation.

### Mode C — Batch Evaluation
```bash
@ scientific-skill-eval --batch ./skills-to-evaluate.tsv --output ./eval-results/
```
Evaluates multiple skills from an input TSV, outputs summary matrix + individual reports.

## Workflow

### Step 1: Security Veto (always runs first, non-negotiable)

Run four hard checks. **Any FAIL = immediate EXCLUDE**, stop here.

| Check | What | Fail Condition |
|-------|------|----------------|
| 数据安全 | API keys, secrets, credentials | Hardcoded credentials in code/config, logs revealing sensitive data |
| 权限范围 | Filesystem/network permissions | Requests unnecessary FS access or network permissions |
| 网络请求 | Outbound connections | Accesses undeclared third-party APIs |
| 依赖来源 | Package dependencies | Non-transparent deps or known vulnerabilities |

For remote URLs: clone to temp dir, run static analysis on code/config files.
For local paths: scan directly.
For installed skills: check in-place.

### Step 2: Function Identification

**Quick mode:** Automatically infer the skill's 1-2 strongest functions from SKILL.md frontmatter, README, and code structure. Map to one of 10 function types.

**Full mode:** User explicitly specifies which functions to evaluate. Validate against available rubric types.

### Step 3: Tier 1 — Professional Depth Scoring

Load the corresponding rubric table from `references/` for each function type. Score 1-5 for each function. Average = DepthScore.

```
DepthScore = average(Function1_Score, Function2_Score)
(if 1 function only: DepthScore = Function1_Score)
```

**Scoring rules:**
- Select the 1-2 functions where the skill shows the strongest evidence (concrete code, tests, working examples, detailed docs)
- Specialization is a feature, not a bug — don't penalize for narrow focus
- Score based on observable artifacts, not marketing claims

### Step 4: Tier 2 — Integration Assessment

Five descriptive 1-5 scores (not used for threshold classification):

| Dimension | What |
|-----------|------|
| Integration难度 | How hard to integrate into scientific-skills bundle |
| MCP兼容 | Compatibility with MCP tools and protocols |
| 冲突风险 | Risk of conflicting with existing skills |
| 维护成本 | Ongoing maintenance burden |
| 上下文依赖 | Context dependency (does it need specific project state) |

### Step 5: Classification

| DepthScore | Classification | Action |
|------------|----------------|--------|
| < 3.0 | EXCLUDE | Must provide exclusion reason |
| 3.0 - 4.0 | CANDIDATE | Auto-classified |
| > 4.0 | AUTO-RECOMMEND | Auto-selected for portfolio |

**Boundary rules:** 3.0 is inclusive CANDIDATE, 4.0 is inclusive AUTO-RECOMMEND.

### Step 6: Output

Default: print Markdown report to terminal.

Optional flags:
- `--output ./report.md` — write to file
- `--format json` — JSON output (all 22 fields)
- `--format tsv` — 22-column TSV output

## Output Format (Markdown, default)

```markdown
# Skill Evaluation Report: {skill-name}

**Date:** {timestamp}
**Source:** {URL / local path / installed name}
**Mode:** {quick / full / batch}

## Security Check

| Check | Result |
|-------|--------|
| 数据安全 | PASS / FAIL |
| 权限范围 | PASS / FAIL |
| 网络请求 | PASS / FAIL |
| 依赖来源 | PASS / FAIL |

**Verdict:** {PASS / FAIL — immediate EXCLUDE if any FAIL}

## Professional Depth Score (Tier 1)

| Function | Score (1-5) | Rubric Evidence |
|----------|-------------|----------------|
| {Function1} | {score} | {brief evidence} |
| {Function2} | {score} | {brief evidence} |

**DepthScore:** {value}

## Integration Assessment (Tier 2)

| Dimension | Score (1-5) |
|-----------|-------------|
| 集成难度 | {score} |
| MCP兼容 | {score} |
| 冲突风险 | {score} |
| 维护成本 | {score} |
| 上下文依赖 | {score} |

## Coverage

**Stages covered:** {research / analysis / writing / submission / polish}
**Description:** {free text}

## Classification

**Result:** {AUTO-RECOMMEND / CANDIDATE / EXCLUDE}

**Exclusion Reason:** (only if EXCLUDE)
{check} | {evidence} | {impact}
```

## Batch Mode Input Format (TSV)

```tsv
Repo	Domain
https://github.com/user/skill1	Literature Search
https://github.com/user/skill2	Medical Research
./local/skill3	Statistical Analysis
```

## Batch Mode Output

- `summary.md` — matrix table of all evaluated skills
- `skill-name-1.md`, `skill-name-2.md`, ... — individual reports
- `summary.tsv` — aggregated 22-column data

## Script Usage

```bash
# Single skill (remote)
python scripts/evaluate.py --url https://github.com/user/skill --mode quick

# Single skill (local)
python scripts/evaluate.py --local ./skills/my-skill --mode full --functions "Literature Search" "Academic Writing"

# Batch
python scripts/batch.py --input skills-to-evaluate.tsv --output ./results/

# Security check only
python scripts/security_check.sh ./skills/my-skill
```