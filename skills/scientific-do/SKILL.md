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

### 1. Intent Parsing

Parse user input, extract:
- Research stage (literature/analysis/writing/polishing)
- Task type (search/analysis/visualization/writing)
- Domain keywords (Medical/Statistics/Machine Learning)

### 2. Skill Routing (Per D-17)

Select skills by priority:
1. Exact match: description fully matches
2. Fuzzy fallback: partial keyword match
3. Smart tuning: context + preferences + history

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
