---
name: scientific-do
description: "Use when starting a research task, making research decisions, or needing to coordinate multiple research skills. Central coordinator for the scientific-skills bundle."
version: 2
triggers:
  keywords:
    - "research task"
    - "科研任务"
    - "coordinate skills"
    - "research workflow"
    - "scientific research"
  scenarios:
    - "multi-skill research workflow"
    - "coordinated literature-write-polish pipeline"
  exclude_when:
    - "single-skill task that directly matches a core skill"
    - "non-research general question"
model: claude-sonnet-4-20250514
---

# Scientific-Do: Central Coordinator

## Overview

Scientific-Do is the central coordinator of the scientific-skills bundle, responsible for:
- Intent parsing: Identify user research intent
- Skill routing: Select appropriate skills
- Dependency chain orchestration: Determine execution order
- Conflict handling: Resolve multi-skill conflicts

## When to Use

- When user describes a research task
- When multiple skills need to collaborate
- When encountering skill selection conflicts

## Process

### 1. Proactive Intent Parsing (D-04)

Analyze user input and active context to infer research intent proactively:

**GSD Context Detection:**
- Call `gsd-context-detect.sh --quick "$PWD"` for lightweight existence check (every invocation, per D-05)
- Lightweight check traverses up to 5 levels from cwd, checks for `.planning/` directory
- If `.planning/` found AND no single skill has confidence > 0.8 (intent ambiguous):
  1. Call `gsd-context-detect.sh "$PWD"` (no --quick flag) for full context parsing
  2. Parse the returned JSON: gsd_project_root, state, current_position, phases
  3. Export GSD env vars for subprocess visibility:
     - `GSD_PROJECT_ROOT` — from `gsd_project_root` field
     - `GSD_PHASE_DIR` — from `current_position.phase` (if present)
     - `GSD_CURRENT_PHASE` — from `current_position.phase` (if present)
     - `GSD_PHASE_STATUS` — from `current_position.status` (if present)
     - `GSD_MILESTONE` — from `state.milestone` (if present)
  4. Apply confidence boost (D-07): if current phase number maps to a skill_registry.role, add +0.2 to that skill's confidence score
  5. Do NOT lower the clarification threshold (remain at 0.6, D-07)
- If `.planning/` found but confidence >= 0.8 (single high-confidence skill): skip full parsing, zero additional overhead (D-05)
- If `.planning/` NOT found: proceed normally, no GSD context (D-04 graceful degradation)
- On parse error: set `GSD_CONTEXT_ERROR` env var with error description, continue execution (D-04)
- GSD context is a hint, not a hard rule — user may need cross-phase skills at any time (D-07)

**Context Signals:**
- File context: What files are open? (.R, .py, .md, .tex)
- Working directory: Is the user in a research project directory?
- Conversation history: Previous research stages completed?
- User's active research stage (if set in workspace context)

**Extraction:**
- Research stage: literature / analysis / writing / polishing / medical
- Task type: search / analyze / visualize / write / polish / validate
- Confidence score: 0.0-1.0 (based on keyword + context match)
- Trigger keywords: Match against all registered skill triggers

**Domain pre-filter:**
- Use ECC's domain classification as first gate (scientific vs non-scientific)
- Only route to scientific-do if confidence > 0.6
- On low confidence (< 0.6): ask user for clarification before routing

### 2. Structured Skill Routing (D-03, D-19, D-20)

Route to the best matching skill using structured trigger fields from all registered skills:

**Matching Priority (D-20: no preset priority — match by scenario):**

1. **Core skill exact match**: User input matches a skill's `triggers.keywords` or `triggers.scenarios`
   - Read `triggers` field from each core skill's SKILL.md frontmatter
   - Score: 1 point per keyword match, 3 points per scenario match
   - Select skill with highest score

2. **Extension pool check (D-19)**: If no core skill scores >= 2:
   - Check extension skills at `~/.claude/skills-extensions/` for trigger matches
   - If extension matches with score >= 2: activate on-demand
   - Activation: Add extension skill path to search scope (no symlink needed — just include in matching)

3. **Fuzzy fallback**: Partial keyword match against skill description
   - Score by word overlap ratio
   - Threshold: > 30% word overlap

4. **Smart tuning**: Context + user preference + historical usage
   - Prefer skills used more frequently in this session
   - Prefer skills matching current research stage

5. **Exclude check**: If the task matches a skill's `exclude_when` conditions, skip it even on keyword match

**Gap Detection (D-09):**

If all routing stages (1-4) fail to match any skill with score >= 1:
1. Log the gap: Record the user's request, context, and attempted matches
2. Notify user: "Current skill bundle has no skill that matches this task."
3. Offer discovery: "Would you like to search GitHub for candidate skills?"
   - If user confirms: Run `bash .planning/phases/07-持续优化/scripts/skill-discovery.sh`
   - Discovery script results provide candidate repos for Phase 2 evaluation
4. Record gap in feedback-state.json under a `gaps` array:
   ```json
   {
     "gaps": [
       {
         "timestamp": "...",
         "request": "user request summary",
         "stage": "research/analysis/writing/polishing",
         "attempted_skills": ["skill1", "skill2"]
       }
     ]
   }
   ```

### 3. Dependency Chain Orchestration

Determine execution order:
- Literature search → Analysis design → Execute analysis → Paper writing → Figure generation → Polish for submission
- HARD-GATE: research before planning, design before writing, confirm before execution

### 4. Conflict Handling (Per D-18)

When multiple skills compete:
- Context priority: Current task context
- User preference: User's settings in config
- Historical usage: Usage frequency statistics

### 5. Post-Action Verification Closure (D-05)

After each scientific-do orchestration cycle, run a lightweight verification:

**Verification Gates:**
- [ ] GATE 1: Is the literature reviewed before planning/analysis? (HARD)
- [ ] GATE 2: Is the methodology designed before writing? (HARD)
- [ ] GATE 3: Are figures derived from completed analysis? (SOFT — warn but proceed)
- [ ] GATE 4: Is the output consistent with the requested research stage? (SOFT)

**Gate Responses:**
- HARD gate failure → HALT execution, report to user, request correction
- SOFT gate failure → Log warning, continue execution, flag for user review

**Usage Tracking (D-14, D-15):**

After verification, increment the feedback counter:
- Read `~/.claude/scientific-skills/feedback-state.json` counter
- Only count substantive orchestrations (>= 2 skill calls OR >= 30s execution time)
- Increment by 1 for matching orchestrations
- Write updated counter back to file

**Counter trigger (every 10):**
If counter >= 10 after increment:
1. Reset counter to 0
2. Prompt user: "Research Workflow Feedback: Please rate the last 10 research orchestrations (1-5):"
3. Collect optional text comment
4. Run update check for all installed skills (see update-check.sh)
5. Save rating + comment + timestamp to feedback-state.json ratings array

## Integration

**Requires skills:**
- deepxiv_sdk
- academic-paper-analysis
- scientific-agent-skills
- academic-writing-skills
- paper-plot-skills
- Paper-Polish-Workflow-skill
- medsci-skills

**HARD-GATE nodes:**
- 规划前必须研究 (Research before planning)
- 写作前必须设计 (Design before writing)
- 执行前必须确认 (Confirm before execution)
- 完成后必须验证 (Verify after completion)
