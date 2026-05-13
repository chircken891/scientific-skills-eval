# Phase 8: GSD 项目上下文感知 — Research

**Researched:** 2026-05-13
**Domain:** GSD project context detection, YAML/plaintext parsing, shell scripting, Claude Code skill integration
**Confidence:** HIGH

## Summary

Phase 8 implements a standalone shell script (`gsd-context-detect.sh`) that detects GSD project context by traversing upward from the current working directory, finding `.planning/`, and parsing STATE.md, ROADMAP.md, PROJECT.md, and CLAUDE.md into structured JSON. The output flows into scientific-do Step 1 as a new context signal, enabling confidence boosts for skill types matching the current GSD phase and making GSD project state available to downstream routing logic.

All 10 locked decisions from CONTEXT.md are concrete and implementable. The primary technical challenges are (1) YAML frontmatter parsing without external dependencies, (2) ROADMAP.md phase list extraction from markdown with collapsible `<details>` sections, and (3) correct integration into scientific-do Step 1's existing confidence scoring pipeline without altering the threshold.

**Primary recommendation:** Build `gsd-context-detect.sh` as a zero-dependency bash script using `awk + node -e` for YAML frontmatter extraction and `grep + sed` for markdown section extraction. Integrate by adding a GSD context detection step before the existing Context Signals in scientific-do/SKILL.md Step 1. The script's JSON output is captured and scoped to memory (not env vars) for routing, with a subset promoted to env vars for subprocess availability.

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| GSD project directory detection | Client (agent shell) | — | Filesystem traversal from cwd; no server component |
| STATE.md frontmatter + body parsing | Client (agent shell) | — | Local file I/O via awk/node; inline parsing |
| ROADMAP.md phase list extraction | Client (agent shell) | — | Markdown structure parsing; no external API |
| PROJECT.md/CLAUDE.md extraction | Client (agent shell) | — | Section-level grep, returns raw text |
| Context exposure to routing | Client (in-memory in scientific-do) | — | JSON in memory for Step 2; env var subset for subprocess |
| Confidence boost for matching roles | Client (in-memory in scientific-do) | — | Manipulates existing confidence scores in Step 1 logic |

## Standard Stack

### Core
| Library/Tool | Version | Purpose | Why Standard |
|--------------|---------|---------|--------------|
| awk (GNU) | 5.3.2 | Frontmatter block extraction via `c==1` pattern | Zero dependency, POSIX, available in Git Bash |
| node | 24.14.0 | YAML-like key-value parsing from stdin | GSD's own pattern (`node -e` inline), always in Claude Code |
| grep (GNU) | 3.0 | Section extraction, field value lookup | Fallback when node parsing fails, field-level extract |
| sed (GNU) | — | In-file text replacement, section trimming | Lightweight text manipulation |

### Supporting
| Tool | Purpose | When to Use |
|------|---------|-------------|
| `ls` | Lightweight `.planning/` existence check | Every call (per D-05: detection timing) |
| `realpath` or `dirname` | Path normalization for `GSD_PROJECT_ROOT` | After finding `.planning/` parent |
| `cat` | Read file content into pipe for awk/node chain | File reading |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `node -e` inline | `yq` (Go YAML parser) | `yq` not guaranteed in Claude Code env; `node -e` always available |
| `awk+node` chain | Pure `node` script | Node alone cannot efficiently do file existence checks + upward traversal in one invocation; shell does this better |
| `grep` fallback | `js-yaml` npm package | Adds dependency outside Claude Code guarantee |

**Installation:**
```bash
# No installation needed — uses tools guaranteed in Claude Code environment
# awk, node, grep available on all platforms (Windows via Git Bash)
```

**Version verification:**
```bash
node --version    # Verified: v24.14.0 (2026-05-13)
bash --version   # Verified: GNU bash 5.2.37
awk --version    # Verified: GNU Awk 5.3.2
grep --version   # Verified: GNU grep 3.0
```

## Architecture Patterns

### Detection and Parsing Pipeline

```
scientific-do Step 1: Proactive Intent Parsing
│
├─ [NEW] GSD Context Detection  ←── inserted BEFORE existing Context Signals
│   │
│   │   gsd-context-detect.sh <cwd>
│   │   │
│   │   ├─ Upward traversal: check ls .planning/ (max 5 levels up)
│   │   │   └─ Not found → exit JSON { gsd_project: false }
│   │   │
│   │   ├─ Lightweight check passes → intent confidence < 0.8?
│   │   │   ├─ No (single high-confidence skill) → skip parsing, exit quick
│   │   │   └─ Yes (ambiguous or low confidence) → parse files
│   │   │
│   │   ├─ Parse STATE.md:
│   │   │   ├─ awk '/^---/{c++;next} c==1{print}' → node -e (frontmatter)
│   │   │   └─ grep -A for "## Current Position" section
│   │   │
│   │   ├─ Parse ROADMAP.md:
│   │   │   ├─ grep for "Phase N:" headers + checkbox status
│   │   │   └─ Extract Progress table rows
│   │   │
│   │   ├─ Parse PROJECT.md:
│   │   │   └─ Extract "## Core Value", "## Constraints" sections
│   │   │
│   │   ├─ Parse project CLAUDE.md (if exists):
│   │   │   └─ Extract encoding rules, path conventions
│   │   │
│   │   └─ Output: JSON to stdout
│   │
│   ├─ scientific-do captures JSON, stores in-memory
│   │
│   ├─ Set env vars: GSD_PROJECT_ROOT, GSD_PHASE_DIR, GSD_CURRENT_PHASE, ...
│   │
│   ├─ Confidence boost: if GSD phase role matches skill_registry.role → +0.2
│   │
│   └─ Falls through to existing Context Signals
│
├─ File context
├─ Working directory
├─ Conversation history
└─ Research stage
```

### Recommended Project Structure

```
~/.claude/scientific-skills/
├── scripts/                          # [NEW] Shared scripts directory
│   └── gsd-context-detect.sh         # Standalone detection script (D-09)
│
└── skills/scientific-do/
    └── SKILL.md                      # Modified Step 1: call gsd-context-detect.sh
```

### Pattern 1: Frontmatter Extraction (awk + node -e)

**What:** Extract YAML frontmatter from GSD markdown files using awk delimiter detection and node inline parsing.

**When to use:** Every STATE.md/PROJECT.md read that has `---` frontmatter blocks.

**Example:**
```bash
# Source: D-06 (locked decision) + GSD frontmatter.cjs extractFrontmatter pattern
STATE_FILE=".planning/STATE.md"
FRONTMATTER=$(awk '/^---/{c++;next} c==1{print}' "$STATE_FILE" | node -e "
const stdin = require('fs').readFileSync('/dev/stdin','utf8');
const lines = stdin.split('\n');
const result = {};
let stack = [result], indents = [-1], keys = [];
for (const line of lines) {
  const t = line.trim();
  if (!t || t.startsWith('#')) continue;
  const m = line.match(/^(\s*)/);
  const indent = m ? m[1].length : 0;
  while (stack.length > 1 && indent <= indents[indents.length-1]) {
    stack.pop(); indents.pop(); keys.pop();
  }
  const kv = t.match(/^([a-zA-Z0-9_-]+):\s*(.*)/);
  if (kv) {
    const k = kv[1], v = kv[2].trim().replace(/^\"|\"$/g, '');
    if (v) { stack[stack.length-1][k] = v; }
    else { stack[stack.length-1][k] = {}; stack.push(stack[stack.length-1][k]); indents.push(indent); keys.push(k); }
  }
}
console.log(JSON.stringify(result));
")
```

### Pattern 2: Current Position Section Extraction

**What:** Extract the `## Current Position` body block from STATE.md for human-readable phase/plan/status data.

**When to use:** After frontmatter parsing, get the current position body text.

**Example:**
```bash
# Source: GSD state.cjs stateExtractField + section matching pattern
CURRENT_POSITION=$(awk '/^## Current Position/{found=1; next} /^## /{found=0} found{print}' "$STATE_FILE")
# Then parse individual fields:
PHASE=$(echo "$CURRENT_POSITION" | grep "^Phase:" | sed 's/^Phase: *//')
PLAN=$(echo "$CURRENT_POSITION" | grep "^Plan:" | sed 's/^Plan: *//')
STATUS=$(echo "$CURRENT_POSITION" | grep "^Status:" | sed 's/^Status: *//')
```

### Pattern 3: ROADMAP.md Phase List Extraction

**What:** Extract phase headers and completion status from ROADMAP.md, handling both collapsible `<details>` sections (v1.0 shipped) and flat sections (v1.1 planning).

**When to use:** After STATE.md parsing, get the full phase view.

**Example:**
```bash
# Source: GSD roadmap.cjs cmdRoadmapAnalyze phase extraction pattern
# Extract phase headers: "## Phase N: Name"
PHASE_HEADERS=$(grep -E "^#{2,4} Phase [0-9]" "$ROADMAP_FILE" | sed -E 's/^#+ Phase ([0-9.]+):? *(.+)?/\1|\2/')
# Extract phase checkbox status: "- [x] **Phase N:" or "- [ ] **Phase N:"
PHASE_CHECKBOXES=$(grep -E "^-\s+\[[ x]\]" "$ROADMAP_FILE" | grep -i "Phase" | sed -E 's/^- \[([ x])\].*Phase ([0-9.]+).*/\2|\1/')
# Extract Progress table rows
PROGRESS_ROWS=$(awk '/^## Progress/,0' "$ROADMAP_FILE" | grep -E "^\|" | tail -n +3 | grep -v "^$")
```

### Pattern 4: Context Signals Integration in SKILL.md

**What:** Insert GSD context detection as Step 1's first context signal.

**When to use:** All scientific-do invocations (lazy: full parse only when needed).

**Example (SKILL.md addition to Step 1):**
```markdown
**GSD Context Signals:**
- Call `gsd-context-detect.sh` from cwd — detect `.planning/`, parse state/roadmap/project
- When intent confidence >= 0.8 for any single skill → skip full parsing (D-05)
- Only full-parse when max confidence < 0.8 (ambiguous intent)
- On match: current phase role matched to skill_registry.role → confidence +0.2 (D-07)
- On error: graceful degradation — no env vars, `GSD_CONTEXT_ERROR` set (D-04)
- On no `.planning/` found: exit early with `gsd_project: false` (D-04)

**Environment Variables:** (D-03)
- `GSD_PROJECT_ROOT` — `.planning/` parent directory
- `GSD_PHASE_DIR` — Current phase directory path
- `GSD_CURRENT_PHASE` — Current phase number
- `GSD_PHASE_STATUS` — Phase status (planning/executing/complete)
- `GSD_MILESTONE` — Milestone version (e.g., v1.1)
- `GSD_CONTEXT_ERROR` — Set on parse failure (D-04)
```

### Anti-Patterns to Avoid

- **Full parse every call:** D-05 explicitly says lightweight `ls` check every time, full frontmatter parse only when intent confidence < 0.8. Parsing STATE.md frontmatter on every scientific-do call for a simple search query wastes tokens.
- **Env var pollution:** D-10 says JSON goes to stdout, captured and scoped to memory. Only the subset (D-03 list) goes to env vars. Don't dump the full JSON into env vars.
- **Path traversal beyond 5 levels:** D-01 says max 5 levels up. This prevents detecting a `.planning/` in an unrelated parent directory (e.g., home directory).
- **Replacing GSD's own tools:** The script reads files only. It does NOT call `gsd-tools.cjs` or modify `.planning/` state. It is a read-only observer.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| YAML frontmatter parsing | Custom parser from scratch | `awk + node -e` inline | D-06 locked decision; GSD's own proven pattern |
| Markdown section extraction | Full markdown parser | `awk` section mode (start/stop pattern) + `grep` | The GSD markdown files follow consistent section header patterns; regex extraction is sufficient |
| File system traversal | Recursive `find` | `while` loop with `../` concatenation (max 5) | D-01: explicit depth limit; `find` has no depth limit without `-maxdepth` flag |

**Key insight:** The GSD file format (STATE.md, ROADMAP.md, PROJECT.md) is deliberately simple — YAML frontmatter + markdown sections. It does NOT need a real YAML parser. The `awk + node -e` chain handles all known frontmatter structures in GSD files (flat keys, nested `progress:` object, inline arrays). For body sections, `awk` start/stop patterns are deterministic since section headers follow strict `## Title` format.

## Common Pitfalls

### Pitfall 1: Frontmatter YAML Contains Nested Objects
**What goes wrong:** Flat key-value parser fails on `progress:` sub-fields (total_phases, completed_phases, etc.) or multi-line values.
**Why it happens:** GSD STATE.md frontmatter has a `progress:` object with nested keys:
```yaml
progress:
  total_phases: 1
  completed_phases: 0
```
A naive `key: value` parser assigns `progress` the value `""` and skips sub-keys.
**How to avoid:** Use the `node -e` parser with indentation-aware stack (Pattern 1 above), which tracks current parent object and nests sub-keys correctly.
**Warning signs:** `GSD_MILESTONE` is set but `progress` fields are null.

### Pitfall 2: ROADMAP.md Has Two Structural Layers (Collapsible + Flat)
**What goes wrong:** Parsing only the collapsible `<details>` summary misses the detail sections, or vice versa.
**Why it happens:** During v1.1 planning, Phase 8-9 are in a collapsible `<details open>` section with checklist format. Shipped v1.0 phases are in a collapsed `<details>` section. Each format has different markup for phase status.
**How to avoid:** Parse both: (1) grep all `## Phase N:` detail section headers for full metadata, (2) grep all `- [x/] **Phase N:` checkbox patterns for completion status. Merge by phase number.
**Warning signs:** Phase 8 shows as not found when it appears in the collapsible block.

### Pitfall 3: Detection Timing Bypasses Full Parse When Needed
**What goes wrong:** scientific-do starts with high confidence for a single skill, skips GSD parse, but the task actually needs GSD context (e.g., "what phase am I on?").
**Why it happens:** D-05 defers parsing when intent confidence >= 0.8. But some questions require GSD context irrespective of skill match confidence.
**How to avoid:** Add a trigger keyword check for GSD-related queries ("phase", "project status", "milestone", "GSD", etc.) that forces full parse even when confidence is high.
**Warning signs:** User asks "how many plans left in this phase?" and gets a non-GSD-aware response.

### Pitfall 4: Env Var Collision With Existing GSD Tools
**What goes wrong:** The `GSD_*` env vars conflict with GSD's own tooling expectations or other scripts that set these vars.
**Why it happens:** GSD's `gsd-tools.cjs` does not currently read `GSD_*` env vars, but this may change. Setting env vars for subprocess visibility could leak between invocations.
**How to avoid:** Set env vars as `export GSD_*` inside the scientific-do process scope, not in the user's shell profile. Use a subshell or temporary scope. Document the exact var names in the script header.
**Warning signs:** Stale `GSD_*` values persist across different project directories.

## Code Examples

### gsd-context-detect.sh — Core Architecture

```bash
#!/usr/bin/env bash
# gsd-context-detect.sh — GSD project context detection
# Output: JSON to stdout
# D-01: cwd upward traversal, max 5 levels
# D-09: standalone helper script
# D-10: JSON stdout output

set -euo pipefail

# ---- D-01: Upward traversal (max 5 levels) ----
CWD="${1:-$(pwd)}"
PLANNING_DIR=""
SEARCH_DIR="$CWD"
for _ in $(seq 1 5); do
  if [ -d "$SEARCH_DIR/.planning" ]; then
    PLANNING_DIR="$SEARCH_DIR/.planning"
    GSD_PROJECT_ROOT="$SEARCH_DIR"
    break
  fi
  SEARCH_DIR="$(dirname "$SEARCH_DIR")"
done

if [ -z "$PLANNING_DIR" ]; then
  echo '{"gsd_project":false,"error":"no .planning/ found within 5 levels"}'
  exit 0
fi

# ---- D-05: Lightweight check ----
# Caller decides whether to invoke full parse.
# This script always parses when called. Calling logic gates the invocation.

# ---- Parse STATE.md frontmatter ----
STATE_FILE="$PLANNING_DIR/STATE.md"
STATE_FRONTMATTER="{}"
CURRENT_POSITION=""
if [ -f "$STATE_FILE" ]; then
  STATE_FRONTMATTER=$(awk '/^---/{c++;next} c==1{print}' "$STATE_FILE" | node -e "
const stdin = require('fs').readFileSync('/dev/stdin','utf8');
const lines = stdin.split('\n');
const result = {};
let stack = [result], indents = [-1];
for (const line of lines) {
  const t = line.trim();
  if (!t || t.startsWith('#')) continue;
  const m = line.match(/^(\s*)/);
  const indent = m ? m[1].length : 0;
  while (stack.length > 1 && indent <= indents[indents.length-1]) {
    stack.pop(); indents.pop();
  }
  const kv = t.match(/^([a-zA-Z0-9_-]+):\s*(.*)/);
  if (kv) {
    const k = kv[1], v = kv[2].trim().replace(/^\"|\"$/g, '');
    if (v) { stack[stack.length-1][k] = /^\\d+$/.test(v) ? parseInt(v,10) : v; }
    else { stack[stack.length-1][k] = {}; stack.push(stack[stack.length-1][k]); indents.push(indent); }
  }
}
console.log(JSON.stringify(result));
")
  CURRENT_POSITION=$(awk '/^## Current Position/{found=1; next} /^## /{found=0} found{print}' "$STATE_FILE")
fi

# ---- Parse ROADMAP.md phase list ----
ROADMAP_FILE="$PLANNING_DIR/ROADMAP.md"
PHASES="[]"
if [ -f "$ROADMAP_FILE" ]; then
  PHASE_HEADERS=$(grep -E "^#{2,4} Phase [0-9]" "$ROADMAP_FILE" | sed -E 's/^#+ Phase ([0-9.]+):? *(.+)?/\1|\2/')
  PHASE_CHECKBOXES=$(grep -E "^-\s+\[[ x]\]" "$ROADMAP_FILE" | grep -i "Phase" | sed -E 's/^- \[([ x])\].*Phase ([0-9.]+).*/\2|\1/')
  # Build phases JSON array
  PHASES=$(echo "$PHASE_HEADERS" | while IFS='|' read -r num name; do
    status=$(echo "$PHASE_CHECKBOXES" | grep "^$num|" | cut -d'|' -f2)
    [ "$status" = "x" ] && complete="true" || complete="false"
    echo "{\"number\":\"$num\",\"name\":\"$name\",\"complete\":$complete}"
  done | node -e "
const stdin = require('fs').readFileSync('/dev/stdin','utf8');
const lines = stdin.trim().split('\n').filter(Boolean);
console.log(JSON.stringify(lines.length ? lines.map(l => JSON.parse(l)) : []));
")
fi

# ---- Parse PROJECT.md ----
PROJECT_FILE="$PLANNING_DIR/PROJECT.md"
PROJECT_CORE=""
PROJECT_CONSTRAINTS=""
if [ -f "$PROJECT_FILE" ]; then
  PROJECT_CORE=$(awk '/^## (Core Value|What This Is)/{found=1; next} /^## /{found=0} found{print}' "$PROJECT_FILE" | head -5)
  PROJECT_CONSTRAINTS=$(awk '/^## Constraints/{found=1; next} /^## /{found=0} found{print}' "$PROJECT_FILE" | head -10)
fi

# ---- Parse CLAUDE.md ----
CLAUDE_FILE="$GSD_PROJECT_ROOT/CLAUDE.md"
CLAUDE_CONTENT=""
if [ -f "$CLAUDE_FILE" ]; then
  CLAUDE_CONTENT=$(head -100 "$CLAUDE_FILE")
fi

# ---- Build output JSON ----
node -e "
const output = {
  gsd_project: true,
  gsd_project_root: '$GSD_PROJECT_ROOT',
  planning_dir: '$PLANNING_DIR',
  state: $STATE_FRONTMATTER,
  current_position: $(echo "$CURRENT_POSITION" | node -e "
const stdin = require('fs').readFileSync('/dev/stdin','utf8');
const lines = stdin.split('\n').filter(l => l.includes(':'));
const obj = {};
for (const line of lines) {
  const m = line.match(/^\*{0,2}([^*:]+):\*{0,2}\s*(.*)/);
  if (m) obj[m[1].trim().toLowerCase().replace(/ /g,'_')] = m[2].trim();
}
console.log(JSON.stringify(obj));
" || echo '{}'),
  phases: $PHASES,
  project_core: $(echo "$PROJECT_CORE" | node -e "const s=require('fs').readFileSync('/dev/stdin','utf8').trim(); console.log(JSON.stringify(s));" 2>/dev/null || echo '""'),
  project_constraints: $(echo "$PROJECT_CONSTRAINTS" | node -e "const s=require('fs').readFileSync('/dev/stdin','utf8').trim(); console.log(JSON.stringify(s));" 2>/dev/null || echo '""'),
  claude_md: $(echo "$CLAUDE_CONTENT" | node -e "const s=require('fs').readFileSync('/dev/stdin','utf8').trim(); console.log(JSON.stringify(s));" 2>/dev/null || echo '""'),
};
console.log(JSON.stringify(output, null, 2));
"
```

### Confidence Boost Integration Pattern (D-07)

```bash
# Inside scientific-do Step 1, after parsing GSD context:
# GSD phase role maps to skill_registry.role for confidence boost
# Map: GSD phase context → skill_registry role → matched skills

BOOST_MAP='{
  "literature_search": ["deepxiv_sdk"],
  "paper_analysis": ["academic-paper-analysis"],
  "data_analysis": ["scientific-agent-skills"],
  "paper_writing": ["academic-writing-skills"],
  "figure_generation": ["paper-plot-skills"],
  "submission_polish": ["Paper-Polish-Workflow-skill"],
  "medical_research": ["medsci-skills"]
}'

# When GSD context has a current phase, and a skill's role matches,
# boost that skill's confidence by +0.2 (does not change clarification threshold)
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| scientific-do had zero GSD awareness | Full GSD context detection with lazy parsing | Phase 8 | Route decisions can now factor in project phase |
| Context signals were file/workdir only | Added GSD project state signal | Phase 8 | Intent parsing has richer situational awareness |
| No confidence boost for phase-aligned skills | +0.2 boost for matching skill_registry roles | Phase 8 | Phase-appropriate skills rank higher in ambiguous intents |

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | `node -e` inline parsing handles all GSD frontmatter structures (nested objects, array fields) | YAML Parsing | Malformed output for complex frontmatter; fall back to grep field-level extraction |
| A2 | ROADMAP.md detail sections always follow `## Phase N: Name` pattern | Common Pitfalls | If future ROADMAP uses `###` instead of `##`, grep pattern fails; add regex flexibility |

## Open Questions (RESOLVED)

1. **Where should `gsd-context-detect.sh` live?** (RESOLVED)
   - What we know: D-09 says standalone script in scientific-skills. Current `.sh` files live in phase-specific directories (e.g., `.planning/phases/07/scripts/`). But this is a shared infrastructure script, not phase-specific.
   - Resolution: Create `~/.claude/scientific-skills/scripts/` directory, co-located with the existing `skills/` and config/state files. This keeps it separate from skill-specific code and makes it discoverable for Phase 9 reuse.

2. **ROADMAP.md section boundary detection for v1.0 shipped phases with no detail header** (RESOLVED)
   - What we know: v1.0 phases are in a collapsed `<details>` block with only checklist items, no `## Phase N:` detail sections. Phase 8-9 (v1.1) have detail sections.
   - Resolution: Parse detail sections (via `## Phase N:`) when present, fall back to checkbox status. The Progress table provides authoritative completion data for all phases.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| node | YAML parsing (D-06) | Yes | 24.14.0 | `grep` field-level extraction |
| bash | Script runner | Yes | 5.2.37 | — |
| awk | Frontmatter block extraction | Yes | 5.3.2 | `sed '/^---/,/^---/!d;/^---/d'` |
| grep | Section/field extraction | Yes | 3.0 | — |

**Missing dependencies with no fallback:** None — all dependencies are standard in Claude Code environment (bash, node, awk, grep).

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | bash script smoke tests + `node -e` inline assertions |
| Config file | none — test as `scripts/test-gsd-context-detect.sh` |
| Quick run command | `bash scripts/test-gsd-context-detect.sh --smoke` |
| Full suite command | `bash scripts/test-gsd-context-detect.sh --all` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| GSD-01 | Detects `.planning/` via upward traversal (5 levels) | smoke | `test-gsd-context-detect.sh --smoke` | Wave 0 |
| GSD-01 | Parses STATE.md frontmatter + Current Position | unit | `test --test-state-parsing` | Wave 0 |
| GSD-01 | Parses ROADMAP.md phase list | unit | `test --test-roadmap-parsing` | Wave 0 |
| GSD-01 | Graceful degradation when no `.planning/` | smoke | `test --test-no-gsd` | Wave 0 |
| GSD-01 | Env vars set correctly from parsed output | integration | `test --test-env-vars` | Wave 0 |
| GSD-01 | Confidence boost for matching skill roles | integration | `test --test-confidence-boost` | Wave 0 |

### Sampling Rate
- **Per task commit:** `bash scripts/test-gsd-context-detect.sh --smoke`
- **Per wave merge:** `bash scripts/test-gsd-context-detect.sh --all`
- **Phase gate:** All tests green before `/gsd-verify-work`

### Wave 0 Gaps
- [ ] `scripts/test-gsd-context-detect.sh` — test harness for gsd-context-detect.sh
- [ ] Test fixture files: sample STATE.md, ROADMAP.md, PROJECT.md, CLAUDE.md in a temp `.planning/` dir
- [ ] Test fixture: a directory tree without `.planning/` for the graceful degradation test

## Security Domain

> Security enforcement: minimal for this phase. The script is read-only (no writes to `.planning/`). No network access. No user data processing. The primary security concern is path traversal guards.

### Applicable ASVS Categories
| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | — |
| V3 Session Management | no | — |
| V4 Access Control | no | — |
| V5 Input Validation | yes | Reject null bytes, reject absolute paths outside allowed traversal range |
| V6 Cryptography | no | — |

### Known Threat Patterns for Shell Scripting
| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Path traversal via `$1` | Tampering | Bound traversal to max 5 levels, use `dirname` (not string manipulation), reject paths with null bytes |
| Command injection via file content | Tampering | Use `node -e` with JSON stringification for file content output; never eval or source file content |
| Accidental `.planning/` in home dir | Information Disclosure | Depth limit prevents walking into unrelated dirs; 5 levels is intentional constraint (D-01) |

## Sources

### Primary (HIGH confidence)
- [CONTEXT.md] — 10 locked decisions (D-01 through D-10), codebase context, canonical refs
- [REQUIREMENTS.md] — GSD-01 requirement definition
- [ROADMAP.md] — Phase 8 success criteria, phase structure patterns
- [STATE.md] — Actual frontmatter structure: nested `progress:` object, `gsd_state_version`
- [PROJECT.md] — Core value, constraints, key decisions format
- [scientific-do/SKILL.md] — Current Step 1 Context Signals structure, integration point
- [intent-parser.ts] — Confidence scoring implementation: 0.0-1.0 scale, keyword-based
- [skill-router.ts] — Skill mapping table, routing priority logic
- [scientific-skills-config.json] — skill_registry.role field (used for D-07 matching)
- [GSD frontmatter.cjs] — extractFrontmatter function: `^---\r?\n([\s\S]+?)\r?\n---` pattern
- [GSD state.cjs] — stateExtractField: `**Field:**` and `Field: value` format support
- [GSD roadmap.cjs] — Phase extraction: `#{2,4}\s*Phase\s+N:` pattern
- Environment probe: node v24.14.0, bash 5.2.37, awk 5.3.2, grep 3.0

### Secondary (MEDIUM confidence)
- [DISCUSSION-LOG.md] — 9 gray area decisions, rationale for each locked decision

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — All tools verified in environment, GSD patterns confirmed in source
- Architecture: HIGH — All locked decisions (D-01 through D-10) map to concrete implementation patterns verified in GSD codebase
- Pitfalls: MEDIUM — Some edge cases (ROADMAP.md collapsible vs. flat structure) inferred from this project's ROADMAP.md patterns; may vary in other GSD projects

**Research date:** 2026-05-13
**Valid until:** 2026-06-13 (stable tooling — awk, bash, node versions change slowly)
