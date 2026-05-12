# Phase 7: 持续优化 - Research

**Researched:** 2026-05-12
**Domain:** Scientific-Do coordinator enhancement, feedback system, skill discovery, performance benchmarking
**Confidence:** HIGH

## Summary

Phase 7 is an incremental improvement phase over the existing 7-core-skill + Scientific-Do coordinator established in Phases 5-6. The primary technical task is integrating domain recognition patterns from everything-claude-code (ECC) into scientific-do without modifying ECC's codebase. Three sub-tasks are ordered: structured skill registration with trigger conditions, proactive intent detection from context, and post-action verification closure. A secondary parallel track adds feedback collection, update checking, skill discovery gap detection, extension skill on-demand activation, and performance benchmarking for P6-E01.

The architecture pattern to follow is "ECC as pre-processor" -- ECC's agent-based domain routing inspects incoming queries and adds a scientific/not-scientific label before scientific-do handles routing. The skill trigger schema extends existing SKILL.md YAML frontmatter with `triggers`, `exclude`, and `model` fields. Feedback persists as a JSON counter file at `~/.claude/scientific-skills/feedback-state.json`. Update checking uses the GitHub API to compare local HEAD with remote SHA.

**Primary recommendation:** Implement the 3 ECC-inspired improvements (D-02 order) as modifications to scientific-do/SKILL.md only, complemented by a lightweight JSON schema for skill registration. Use ECC's existing hook infrastructure (PreToolUse) for domain classification rather than building a separate classifier.

## User Constraints (from CONTEXT.md)

### Locked Decisions
- D-01: 保持中央协调器架构，不改为分布式agent
- D-02: 3个改进按顺序实施：结构化Skill注册 → 主动意图检测 → 后置验证闭环
- D-03: 结构化Skill注册：每个skill加触发条件字段（触发关键词 + 典型场景 + 排除场景）
- D-04: 主动意图检测：从上下文推断科研意图，不等用户显式说出关键词
- D-05: 后置验证闭环：每个科研阶段完成后增加轻量验证节点
- D-06: Skill声明模型偏好：每个skill的SKILL.md中声明模型偏好，调用时自动切换
- D-07: P6-E01做性能基准测试
- D-08: P6-E02不做自动化测试框架（维护成本高，ROI低）
- D-09: 自动检测缺口：Scientific-Do执行任务时自动检测能力缺口
- D-10: 发现缺口后GitHub自动搜索候选skill
- D-11: 沿用Phase 2标准筛选（安全否决 + DepthScore阈值）
- D-12: 新发现skill分级入库：DepthScore > 4.0 → 核心直接激活 / 3.0-4.0 → 扩展预下载不激活 / < 3.0 → 不入库
- D-13: 替换逻辑：新角色→新增核心 / 同角色更强→替换旧核心，旧的降级为扩展 / 同角色差不多→加入扩展池由协调器选择
- D-14: 静默自动记录：每次skill调用自动记录成功/失败状态和耗时
- D-15: 每10次Scientific-Do编排弹出1-5分评分 + 选填文字评价
- D-16: 更新检查与反馈绑定：每10次一并检查所有已安装skill的GitHub上游更新
- D-17: 发现更新→通知摘要+人工确认，不自动更新
- D-18: 更新后全量冒烟测试（7个核心skill）
- D-19: Phase 5预下载的3个扩展skill（nature-skills / claude-scholar / scientify）按需自动激活
- D-20: 不预设优先级，Scientific-Do按场景匹配选择最合适的skill

### Claude's Discretion
None explicitly scoped -- D-01 through D-20 cover all decisions.

### Deferred Ideas (OUT OF SCOPE)
None -- all discussions stayed within Phase 7 boundaries.

## Phase Requirements

The CONTEXT.md decisions (D-01 through D-20) define the scope. No explicit REQ IDs were provided, but these map to the roadmap tasks:

| Task Area | Supporting Decisions | Technical Domain |
|-----------|---------------------|------------------|
| Scientific-Do改进 | D-01 through D-05 | SKILL.md schema design, intent parsing, verification hooks |
| 配置优化 | D-06 | Model name declaration in frontmatter, runtime model switching |
| Phase 6遗留 | D-07, D-08 | Benchmark metrics, manual testing |
| 发现Skill机制 | D-09 through D-13 | Gap detection, GitHub API search, grading/replacement logic |
| 反馈收集+更新 | D-14 through D-18 | JSON state machine, GitHub API, npm view CLI |
| 扩展Skill激活 | D-19, D-20 | On-demand symlink/copy, context-based activation |

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Skill trigger registration | scientific-do/SKILL.md | Each skill's own SKILL.md | The coordinator owns the routing schema; individual skills declare their own trigger conditions |
| Intent detection | scientific-do (intent parsing step) | ECC domain classifier (PreToolUse hook) | ECC adds scientific/not-scientific label; scientific-do resolves the sub-domain |
| Post-action verification | scientific-do (new HARD-GATE node) | Manual user check | Verification is a coordinator-level concern, not per-skill |
| Model preference switching | Runtime env (settings.json model map) | scientific-do dispatch step | The coordinator reads skill's declared model and sets ANTHROPIC_MODEL before invoking |
| Feedback collection | `~/.claude/scientific-skills/feedback-state.json` | scientific-do (increments counter) | State file is a runtime artifact; coordinator owns the counter logic |
| Update checking | GitHub API (REST calls via Bash/curl) | skills-extensions/ per-skill git remotes | Each skill has its own git remote; update checking iterates over all |
| Skill discovery / gap detection | scientific-do (task failure analysis) | GitHub API search | Coordinator detects gaps during task execution; search uses Phase 2 scoring framework |
| Extension activation | scientific-do (on-demand routing) | skills-extensions/ directory | Coordinator checks extension pool when core skills don't match |
| Performance benchmarking | Bash scripts + timing capture | scientific-do execution observer | Measure response latency, token consumption, orchestration delay at coordinator level |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| everything-claude-code | 2.0.0-rc.1 | Domain recognition pre-processor, quality gate hooks | Already installed at `~/.claude/skills/everything-claude-code/`; D-02 requires borrowing its agent routing pattern [VERIFIED: filesystem] |
| GitHub REST API | v3 (REST) | Update checking: compare local git HEAD vs remote SHA | Universal, no auth needed for public repos [VERIFIED: github.com] |
| npm view | (CLI tool) | Verify skill package versions | Already used in Phase 6 for deepxiv-sdk version check [CITED: 06-04-ISSUES.md] |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| git rev-parse HEAD | (git CLI) | Get local commit hash for update comparison | Each skill update check cycle |
| jq | (CLI) | Parse feedback-state.json | Feedback recording and reading |
| gh CLI | (GitHub CLI) | GitHub API queries for skill discovery | D-10 GitHub search |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| ECC hooks for domain classification | Build standalone intent classifier | Duplicates work; ECC already has PreToolUse hook infrastructure with observe-runner pattern |
| JSON file for feedback state | SQLite database | JSON is simpler, no new dependency; but no query capability |
| GitHub API for update check | npm view version comparison | Not all skills are npm packages; git remote is universal |

**Installation:**
```bash
# All dependencies already installed
# ECC: ~/.claude/skills/everything-claude-code/
# jq: typically pre-installed
# gh CLI: check via `gh --version`
```

**Version verification:**
```bash
# ECC version (from VERSION file)
cat ~/.claude/skills/everything-claude-code/VERSION
# Output: 2.0.0-rc.1 [VERIFIED: filesystem]
```

## Architecture Patterns

### System Architecture Diagram

```
User Input
    │
    ▼
┌─────────────────────────────────────┐
│  ECC PreToolUse Hook                │
│  (observe-runner)                   │
│  → Classify: scientific/not-sci?   │
└──────────────┬──────────────────────┘
               │ (with domain label)
               ▼
┌─────────────────────────────────────┐
│  Scientific-Do Coordinator          │
│  ┌───────────────────────────────┐  │
│  │ 1. Intent Parsing            │  │
│  │   - D-04 Active intent detect│  │
│  │   (context analysis)         │  │
│  │                              │  │
│  │ 2. Skill Routing (D-03)     │  │
│  │   - Exact trigger match      │  │
│  │   - Fuzzy fallback           │  │
│  │   - Smart tuning             │  │
│  │   - Extension pool check     │  │
│  │                              │  │
│  │ 3. Model Select (D-06)      │  │
│  │   - Read skill model pref    │  │
│  │   - Set ANTHROPIC_MODEL      │  │
│  │                              │  │
│  │ 4. Execution + Feedback      │  │
│  │   (D-14 auto-record)         │  │
│  │                              │  │
│  │ 5. Verify (D-05)            │  │
│  │   (post-action gate)         │  │
│  └───────────────────────────────┘  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Skill Execution                    │
│  (one of 7 core / 3 extension)      │
└─────────────────────────────────────┘
               │
               ▼ (every 10 calls)
┌─────────────────────────────────────┐
│  Feedback State (D-15/D-16)         │
│  feedback-state.json: counter +     │
│  last-check + update status         │
│  → Prompt user: 1-5 rating          │
│  → GitHub update check per skill    │
└─────────────────────────────────────┘
               │
               ▼ (if update found, D-17)
┌─────────────────────────────────────┐
│  Update approval → Smoke test (D-18)│
└─────────────────────────────────────┘
```

### Recommended Project Structure (files to create/modify)

```
~/.claude/scientific-skills/
├── CLAUDE.md                       # MODIFY: Add D-03 trigger fields to skill descriptions
├── skills/
│   ├── scientific-do/
│   │   └── SKILL.md                # MODIFY: Add structured registration schema, intent detection logic, verification closure
│   ├── deepxiv_sdk/
│   │   └── SKILL.md                # MODIFY: Add triggers/exclude/model frontmatter fields
│   ├── academic-paper-analysis/
│   │   └── SKILL.md                # MODIFY: Same
│   ├── scientific-agent-skills/
│   │   └── SKILL.md                # MODIFY: Same
│   ├── academic-writing-skills/
│   │   └── SKILL.md                # MODIFY: Same
│   ├── paper-plot-skills/
│   │   └── SKILL.md                # MODIFY: Same
│   ├── Paper-Polish-Workflow-skill/
│   │   └── SKILL.md                # MODIFY: Same
│   └── medsci-skills/
│       └── SKILL.md                # MODIFY: Same
├── feedback-state.json             # CREATE: D-14 feedback counter file
└── scientific-skills-config.json   # CREATE: Unified config with model map, skill registry, thresholds

~/.claude/skills-extensions/
├── .downloaded-only                # EXISTING: marker file
├── nature-skills/                  # EXISTING: D-19 on-demand activate
├── claude-scholar/                 # EXISTING: D-19
└── scientify/                      # EXISTING: D-19
```

### Pattern 1: Structured Skill Registration (D-03)

**What:** Extend each skill's SKILL.md frontmatter with explicit trigger conditions, typical scenarios, and exclusion scenarios.

**Where to use:** Every SKILL.md in `~/.claude/scientific-skills/skills/*/`

**Current frontmatter format:**
```yaml
---
name: deepxiv_sdk
description: "Use when searching for academic papers, finding literature, exploring arXiv/PubMed, or needing to review related research"
---
```

**Target frontmatter format:**
```yaml
---
name: deepxiv_sdk
description: "Use when searching for academic papers, finding literature, exploring arXiv/PubMed, or needing to review related research"
triggers:
  keywords: ["search literature", "find papers", "arXiv", "PubMed", "related work", "文献检索"]
  scenarios: ["literature review", "related work section", "systematic review"]
  exclude_when: ["writing manuscript", "data analysis", "figure generation"]
model: claude-sonnet-4-20250514
---
```

[ASSUMED] -- This schema extension is not yet on any skill's SKILL.md. The exact field names (`triggers`, `keywords`, `scenarios`, `exclude_when`, `model`) are design proposals. Their format needs to match how scientific-do parses them in the routing step.

### Pattern 2: Feedback State Machine (D-14, D-15)

**What:** A JSON counter file at `~/.claude/scientific-skills/feedback-state.json` tracks call count and feedback status.

```json
{
  "counter": 7,
  "last_feedback_at": null,
  "last_update_check_at": null,
  "ratings": [],
  "skill_updates": {
    "deepxiv_sdk": { "local_sha": "abc123", "remote_sha": "def456", "updated_at": null },
    "academic-paper-analysis": { "local_sha": "abc123", "remote_sha": "abc123" }
  }
}
```

[ASSUMED] -- The exact JSON schema is a design proposal. The location and counter logic (every 10) are specified in D-15.

### Pattern 3: Post-Action Verification Closure (D-05)

**What:** After each scientific-do orchestration cycle, insert a lightweight verification HARD-GATE node.

**Modeled after:** ECC's `post:quality-gate` hook pattern (`~/.claude/skills/everything-claude-code/hooks.json`, hook id `post:quality-gate`). It runs asynchronously after tool use, checks output quality, and logs warnings.

**Implementation approach:** Add a new HARD-GATE node in scientific-do/SKILL.md after the conflict handling step:

```
### 5. Post-Action Verification (D-05)
- Verify output matches expected research stage
- Check: Is the literature reviewed before planning?
- Check: Is the methodology designed before writing?
- Check: Are figures derived from completed analysis?
- If any gate fails: HALT, report to user, request correction
```

[ASSUMED] -- The exact gate checklist is a design proposal, but the concept is verified from the existing scientific-do HARD-GATE pattern (3 nodes already exist in the SKILL.md).

### Pattern 4: Update Checking via GitHub API (D-16, D-17)

**What:** For each installed skill (7 core + 3 extension), compare local git HEAD with remote default branch SHA.

```bash
# Get local SHA
cd ~/.claude/scientific-skills/skills/deepxiv_sdk && git rev-parse HEAD

# Get remote SHA (no auth needed for public repos)
gh api repos/DeepXiv/deepxiv_sdk/commits/HEAD --jq '.sha'
# or
curl -s https://api.github.com/repos/DeepXiv/deepxiv_sdk/commits/HEAD | jq -r '.sha'

# Compare: different = upstream update available
```

**Skill repo origins (from Phase 4 optimal combination):**
- DeepXiv/deepxiv_sdk
- K-Dense-AI/scientific-agent-skills
- bahayonghang/academic-writing-skills
- Boom5426/paper-plot-skills
- Lylll9436/Paper-Polish-Workflow-skill
- MedgeClaw/medsci-skills
- Yuan1z0825/nature-skills (extension)
- yy/claude-scholar (extension)
- scientify/scientify (extension - org unknown)

[VERIFIED: 04-OPTIMAL-COMBINATION.md] for core skill repos.
[ASSUMED] for exact extension repo org names (yy/claude-scholar, scientify) -- need to verify from git remote in `~/.claude/skills-extensions/`.

### Anti-Patterns to Avoid
- **Modifying ECC code:** D-02 says borrow patterns, not modify ECC. ECC is an external tool.
- **Building a separate intent classifier:** ECC's observe-runner already captures tool context -- use the domain label it produces rather than building NLP.
- **Auto-update without user consent:** D-17 explicitly requires human confirmation.
- **Full skill re-evaluation on discovery:** D-12 says use Phase 2 thresholds, not re-run Phase 2.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| GitHub remote SHA comparison | Custom git polling | `gh api repos/{owner}/{repo}/commits/HEAD` | Standardized, no auth setup for public repos |
| Skill version tracking | Custom package registry | `npm view {package} version` | deepxiv_sdk verified npm-installable; others may be too |
| Rate limiting for update checks | Custom throttle | GitHub API rate limits (60/hr unauthenticated, 5000/hr authenticated) | Sufficient for 10 skills every 10 sessions |
| Domain classification | Custom ML/NLP model | ECC's existing agent routing with "When to Activate" pattern | ECC already classifies queries by domain in its skill matching [VERIFIED: ECC SKILL.md files] |

**Key insight:** This phase is about wiring existing infrastructure together, not building new systems. Every component (ECC hooks, GitHub API, JSON state, SKILL.md frontmatter) already exists in some form.

## Common Pitfalls

### Pitfall 1: Feedback Counter Drift
**What goes wrong:** The feedback counter increments on every scientific-do call, including quick lookups that don't warrant feedback. Users get rating fatigue at every 10 calls.
**Why it happens:** D-15 says "每10次Scientific-Do编排" without defining what counts as an "orchestration."
**How to avoid:** Only count substantive orchestrations (>=2 skill calls or >=30s execution time). Document the counter increment rule in scientific-do/SKILL.md.
**Warning signs:** User reports of too-frequent or too-infrequent feedback prompts.

### Pitfall 2: Extension Activation Conflicts
**What goes wrong:** On-demand activating nature-skills (extension) conflicts with paper-plot-skills (core) for figure generation tasks.
**Why it happens:** D-20 says no preset priority -- but some tasks are equally matchable by both core and extension.
**How to avoid:** In the skill registration (D-03), add `exclude_when` conditions. For paper-plot-skills: `exclude_when: ["Nature journal formatting"]`. For nature-skills: `exclude_when: ["general figure generation"]`.
**Warning signs:** Scientific-do routes to nature-skills for figure tasks that paper-plot-skills handles better.

### Pitfall 3: Update Check Overload
**What goes wrong:** Every 10 feedback cycles triggers 10 GitHub API calls. With 60 req/hr limit, exceeding triggers rate blocking.
**Why it happens:** Default GitHub API is 60 unauthenticated req/hr. 10 skills x 1 check/round = 10 calls. At fast session pace, could hit limit.
**How to avoid:** Use authenticated `gh api` (5000 req/hr). Run checks sequentially, not in parallel. Cache results in feedback-state.json so only changed skills are reported.
**Warning signs:** GitHub API returns 403 or 429.

### Pitfall 4: Intent Detection Noise
**What goes wrong:** D-04 proactive intent detection triggers false positives -- infers "scientific intent" from non-research queries.
**Why it happens:** Natural language queries about science-adjacent topics (e.g., asking about a paper's formatting) may trigger scientific-do when a general answer suffices.
**How to avoid:** Keep the ECC domain classifier as a pre-filter. Only route to scientific-do when confidence > threshold (e.g., keyword match score > 0.6).
**Warning signs:** User says "I didn't want to start a research workflow" or "why is scientific-do activating on this?"

## Code Examples

### Example 1: New SKILL.md frontmatter (deepxiv_sdk)

```yaml
---
name: deepxiv_sdk
description: "Use when searching for academic papers, finding literature, exploring arXiv/PubMed, or needing to review related research"
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
```

[ASSUMED] -- Schema field names and model identifier are design proposals.

### Example 2: Feedback counter increment and check logic

```bash
# Read current counter
COUNTER=$(jq '.counter // 0' ~/.claude/scientific-skills/feedback-state.json)
COUNTER=$((COUNTER + 1))

# If counter hits 10, trigger feedback + update check
if [ "$COUNTER" -ge 10 ]; then
  echo "=== Research Workflow Feedback ==="
  echo "You've used 10 research workflows. Please rate (1-5):"
  read -r RATING
  echo "Optional comment:"
  read -r COMMENT

  # Reset counter and save
  jq --arg r "$RATING" --arg c "$COMMENT" \
    '.counter = 0 | .ratings += [{"rating": $r, "comment": $c, "at": now}]' \
    ~/.claude/scientific-skills/feedback-state.json > tmp && mv tmp ~/.claude/scientific-skills/feedback-state.json
else
  jq --argjson c "$COUNTER" '.counter = $c' \
    ~/.claude/scientific-skills/feedback-state.json > tmp && mv tmp ~/.claude/scientific-skills/feedback-state.json
fi
```

[ASSUMED] -- Exact shell logic. Logic inspired by D-14/D-15 spec.

### Example 3: Update check for a single skill

```bash
SKILL_DIR="$1"
SKILL_REPO="$2"  # e.g., "DeepXiv/deepxiv_sdk"

cd "$SKILL_DIR" || exit 1
LOCAL_SHA=$(git rev-parse HEAD 2>/dev/null)
REMOTE_SHA=$(curl -s "https://api.github.com/repos/$SKILL_REPO/commits/HEAD" | jq -r '.sha' 2>/dev/null)

if [ "$LOCAL_SHA" != "$REMOTE_SHA" ] && [ -n "$REMOTE_SHA" ] && [ "$REMOTE_SHA" != "null" ]; then
  echo "UPDATE_AVAILABLE: $SKILL_REPO"
  echo "  Local:  $LOCAL_SHA"
  echo "  Remote: $REMOTE_SHA"
else
  echo "UP_TO_DATE: $SKILL_REPO"
fi
```

[ASSUMED] -- Logic design. Uses GitHub REST API v3.

### Example 4: Model preference switching at runtime

```yaml
# In scientific-do/SKILL.md routing step, per D-06:
# 1. Read model field from target skill's SKILL.md frontmatter
# 2. If model field exists and differs from current ANTHROPIC_MODEL:
#    - Cache current model
#    - Set ANTHROPIC_MODEL to skill's preferred model
#    - Execute skill
#    - Restore cached model
```

[ASSUMED] -- Implementation approach. Environment variable switching is a verified Claude Code pattern (see settings.json `env.ANTHROPIC_MODEL`).

## Runtime State Inventory

This section covers rename/refactor/migration concerns. Phase 7 is not a rename phase but involves modifying files in place, creating new files, and checking git-tracked state.

| Category | Items Found | Action Required |
|----------|-------------|------------------|
| Stored data | `~/.claude/scientific-skills/` directory with 8 skill subdirectories + CLAUDE.md | Modify SKILL.md frontmatter (7 core + 1 coordinator); create feedback-state.json |
| Live service config | ECC's hooks.json at `~/.claude/skills/everything-claude-code/hooks.json` | Read-only reference -- do not modify ECC files |
| OS-registered state | None | N/A |
| Secrets/env vars | ANTHROPIC_MODEL in settings.json (D-06 model switching affects this at runtime) | No env var rename needed; model switching is runtime set/unset |
| Build artifacts | Git repositories inside each skill directory under `~/.claude/` | D-16 update check reads git HEAD; no build artifacts |

**Nothing found:** No OS-registered state, no build artifacts beyond git repos.

## Common Pitfalls

### Pitfall 1: Feedback Counter Drift
See detailed entry above in main section.

### Pitfall 2: Extension Activation Conflicts
See detailed entry above in main section.

### Pitfall 3: Update Check Overload
See detailed entry above in main section.

### Pitfall 4: Intent Detection Noise
See detailed entry above in main section.

### Pitfall 5: Version Skew in SKILL.md Schema
**What goes wrong:** Some skills get the new frontmatter fields (triggers, model), others don't. Scientific-do fails on missing fields.
**Why it happens:** Manual editing of 8 SKILL.md files is error-prone.
**How to avoid:** Create a validation check script that reads all SKILL.md files and reports missing new fields. Add a `version: 2` field to track schema version.
**Warning signs:** scientific-do routing errors referencing undefined frontmatter keys.

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Intent parsing by keyword match only | Intent detection by context + keyword (D-04) | Phase 7 | Reduced false positives, better task routing |
| No structured skill registration | SKILL.md frontmatter with triggers/exclude/model (D-03/D-06) | Phase 7 | Enables automated routing decisions without reading skill body |
| No feedback collection | Counter file + periodic rating prompt (D-14/D-15) | Phase 7 | Data-driven improvement decisions |
| Manual update checking | GitHub API automated diff (D-16/D-17) | Phase 7 | Proactive update awareness |

**Deprecated/outdated:**
- Unstructured skill routing (relying only on `description` field): Replaced by structured trigger schema.

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | The proposed frontmatter schema (`triggers.keywords`, `triggers.scenarios`, `triggers.exclude_when`, `model`) is the right format for structured skill registration | Standard Stack / Code Examples | Wrong schema structure would need amending all 8 SKILL.md files |
| A2 | ECC's existing hooks infrastructure (specifically the observe-runner) can be used as the domain pre-classifier without modification | Architecture Patterns | Would need to build standalone intent classifier |
| A3 | GitHub API unauthenticated rate limit (60 req/hr) is sufficient for 10 skill checks | Don't Hand-Roll | Need authenticated gh CLI setup if exceeded |
| A4 | Model preference switching via ANTHROPIC_MODEL env var at runtime works correctly within a single Claude Code session | Code Examples | Environment variable changes may not take effect mid-session for the invoking model |
| A5 | Extension skills at `~/.claude/skills-extensions/` can be activated on-demand by symlinking into `~/.claude/skills/` | Standard Stack | On-demand activation mechanism not yet defined; may need directory-level config change |
| A6 | The skill GitHub repos are correctly identified for update checking | Common Pitfalls | Wrong repo URL = failed update check; some may not have `origin` remote set up |
| A7 | `jq` is available in the runtime environment | Standard Stack | jq is commonly pre-installed but not guaranteed on Windows |

## Validation Architecture

`workflow.nyquist_validation` is `true` in config.json -- include this section.

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Manual verification + Bash assertions |
| Config file | None (manual tests per Phase 5-04 pattern) |
| Quick run command | `bash .planning/phases/07-持续优化/07-VERIFY.sh` |

### Phase Requirements to Test Map

| D-ID | Behavior | Test Type | How to Verify |
|------|----------|-----------|---------------|
| D-03 | Structured registration | Manual | Read each SKILL.md frontmatter -- check `triggers` and `exclude_when` fields exist |
| D-04 | Intent detection | Manual | Test 5 scientific queries + 5 non-scientific queries; verify correct routing |
| D-05 | Verification closure | Manual | Execute a research workflow; confirm post-step verification is triggered |
| D-06 | Model preference | Manual | Invoke a skill with `model: sonnet`; verify ANTHROPIC_MODEL changes during execution |
| D-07 | Performance basebench | Automated | Run timing script: measure response speed, token consumption, orchestration delay |
| D-14 | Silent auto-record | File check | Execute skill; verify feedback-state.json counter increments |
| D-15 | Feedback prompt | Manual | Call scientific-do 10 times; verify rating prompt appears on 10th |
| D-16 | Update check | Manual | Run update check script; verify it returns current SHA for each skill |
| D-17 | Update notification | Manual | Force a SHA mismatch; verify notification displays without auto-update |
| D-18 | Smoke test after update | Manual | After update, run 7 skills; verify each responds correctly |
| D-19 | Extension activation | Manual | Invoke scenario requiring nature-skills; verify it activates from extension pool |

### Sampling Rate
- **Per task commit:** Execute modified skill's basic functionality (e.g., if editing deepxiv_sdk SKILL.md, run `deepxiv search "test" --limit 1`)
- **Per wave merge:** Run D-03 verification on all 8 SKILL.md files + D-07 benchmark script
- **Phase gate:** All D-xx verification items above pass before `/gsd-verify-work`

### Wave 0 Gaps
- [ ] `07-VERIFY.sh` -- verification script for all D-xx items (CREATE)
- [ ] Benchmark capture script for P6-E01 (CREATE)

## Security Domain

`security_enforcement` is absent from config.json -- treat as enabled.

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | Phase 7 does not add auth |
| V3 Session Management | no | Phase 7 does not add sessions |
| V4 Access Control | yes | D-19 activation of pre-downloaded skills: verify no new network permissions |
| V5 Input Validation | yes | D-04 intent detection reads user input -- validate before parsing |
| V6 Cryptography | no | Phase 7 does not add encryption |

### Known Threat Patterns for Phase 7

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| GitHub API call returning malicious repo URL | Spoofing | Validate repo owner/name against whitelist before cloning |
| Feedback JSON injection via user comment | Tampering | Sanitize user comment input before writing to JSON |
| Extension activation granting unintended permissions | Elevation of Privilege | D-19 check: only activate skills already pre-downloaded and vetted in Phase 2 |

## Sources

### Primary (HIGH confidence)
- [CONTEXT.md] D-01 through D-20 decisions, research scope
- [Phase 4 OPTIMAL COMBINATION] Skill repo origins, DepthScore data
- [Phase 6 FINAL REPORT] 16/16 PASS, P6-E01/P6-E02 status
- [Filesystem: ~/.claude/skills/everything-claude-code/] ECC hooks.json, Ag
- [Filesystem: ~/.claude/skills/everything-claude-code/] ECC hooks.json, Agents, SKILL.md schema (`agents/planner.md`, `skills/api-design/SKILL.md`)
- [Filesystem: ~/.claude/scientific-skills/] Current scientific-do SKILL.md, each skill's current frontmatter

### Secondary (MEDIUM confidence)
- [Filesystem: settings.json] Current env vars, ANTHROPIC_MODEL configuration pattern
- [Filesystem: ~/.claude/skills-extensions/] Extension skill directory structure
- [DISCUSSION-LOG.md] Design rationale for architecture choices

### Tertiary (LOW confidence)
- [ASSUMED] Exact frontmatter schema field names and format

## RESEARCH COMPLETE

**Phase:** 7 - 持续优化
**Confidence:** HIGH (for architecture/stack); MEDIUM (for exact implementation details)

### Key Findings
1. ECC is at `~/.claude/skills/everything-claude-code/` v2.0.0-rc.1 with a complete hook infrastructure (PreToolUse/PostToolUse/Stop) and agent-based routing pattern that scientific-do can borrow without modifying ECC
2. Scientific-do's current SKILL.md has a 4-step process (Intent Parsing -> Skill Routing -> Dependency Chain -> Conflict Handling) that needs extension to 5 steps with post-action verification
3. All 7 core skills use minimal YAML frontmatter (name + description only) -- all need structured trigger fields added
4. Extension skills exist at `~/.claude/skills-extensions/` with complete git repos -- activation requires copying or symlinking into `~/.claude/skills/`
5. Feedback collection needs a JSON counter file at `~/.claude/scientific-skills/feedback-state.json` and increment logic in scientific-do
6. Update checking uses `git rev-parse HEAD` locally vs GitHub API remote SHA -- no new dependencies needed
7. Performance benchmarking (P6-E01) requires capturing response timing and token consumption at the scientific-do orchestration level

### File Created
`D:\cc\项目\科研skill\.planning\phases\07-持续优化\07-RESEARCH.md`

### Confidence Assessment
| Area | Level | Reason |
|------|-------|--------|
| Standard Stack | HIGH | All existing tools verified on filesystem; no new dependencies needed |
| Architecture | HIGH | ECC pattern verified, scientific-do structure verified, CONTEXT.md locked decisions clear |
| Pitfalls | MEDIUM | Four major pitfalls identified; intent detection and feedback drift need real-world calibration |
| Frontmatter Schema | LOW | Assumed field names only -- needs user confirmation before implementation |

### Open Questions (RESOLVED)
1. **RESOLVED:** Use `claude-sonnet-4-20250514` as default model identifier. The model field in SKILL.md frontmatter stores a model ID string that scientific-do reads at dispatch time. If the runtime endpoint doesn't support the exact string, scientific-do falls back to the current `ANTHROPIC_MODEL` env var. (Assumption A1)
2. **RESOLVED:** Check git remote at execution time. For skills without `.git/` or without a valid `origin` remote, store the repo URL in `scientific-skills-config.json` under `skill_repos` key. Update-check.sh reads config.json as fallback when `git rev-parse HEAD` fails. (Assumption A6)
3. **RESOLVED:** Assume `tsingyuai/scientify` as default GitHub org. Verify by reading `git remote get-url origin` in `~/.claude/skills-extensions/scientify/` at execution time. If incorrect, the org is determined from the actual git remote at runtime. (Assumption A3)

### Ready for Planning
Research complete. Planner can now create PLAN.md files for the 5 roadmap tasks.
