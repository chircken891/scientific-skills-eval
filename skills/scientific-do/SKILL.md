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

### 3. Dependency Chain Orchestration

Determine execution order:
- Literature search → Analysis design → Execute analysis → Paper writing → Figure generation → Polish for submission
- HARD-GATE: research before planning, design before writing, confirm before execution

### 4. Conflict Handling (Per D-18)

When multiple skills compete:
- Context priority: Current task context
- User preference: User's settings in config
- Historical usage: Usage frequency statistics

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
