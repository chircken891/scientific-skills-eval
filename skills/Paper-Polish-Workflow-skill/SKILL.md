---
name: Paper-Polish-Workflow-skill
description: "Use when polishing papers for submission, checking language quality, preparing for journal submission, or finalizing manuscripts"
version: 2
triggers:
  keywords:
    - "polish paper"
    - "submission ready"
    - "check language"
    - "de-AI"
    - "润色"
  scenarios:
    - "pre-submission polishing"
    - "language quality check"
    - "de-AI-ification"
  exclude_when:
    - "writing new content"
    - "data analysis"
    - "literature search"
model: claude-sonnet-4-20250514
---

# Paper Polish Workflow

## Overview
Paper Polish Workflow provides 16 polishing skills with de-AI-ification process for preparing submission-ready papers that pass editorial review.

## When to Use
- Finalizing manuscript before submission
- Checking language and formatting
- Preparing response to reviewers
- Ensuring compliance with journal guidelines

## Process
1. Language quality check and correction
2. Formatting verification
3. Plagiarism and originality check
4. Journal requirement compliance

## Integration
**Phase workflow:**
- **Phase:** Submission preparation (final phase)
- **Triggers:** "polish paper", "submission ready", "check language", "prepare for journal", "finalize manuscript"

**Related skills:**
- **scientific-skills:academic-writing-skills** - Prior to polishing
- **scientific-skills:medsci-skills** - PRISMA/STROBE compliance for medical papers