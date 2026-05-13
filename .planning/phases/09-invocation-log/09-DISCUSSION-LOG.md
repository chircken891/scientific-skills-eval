# Phase 9 Discussion Log

**Phase:** 09-invocation-log
**Date:** 2026-05-13
**Areas discussed:** 4 main + 5 supplementary

## Main Areas

### Area 1: Invocation Log Schema

**Q1: Fields beyond required?**
- Options: Minimal / Standard (add status + error_summary) / Comprehensive (add model + tokens)
- Selected: Standard — timestamp, intent, routed_skill, status, error_summary, execution_summary, phase, plan, duration_ms

**Q2: Status values?**
- Selected: success / failure / partial / gap_detected
- gap_detected covers P7 D-09~D-12 skill discovery pipeline

**Q3: Phase/plan association?**
- Selected: phase always (from GSD_CURRENT_PHASE), plan optional when available from gsd-context-detect.sh

### Area 2: Log Storage & Growth

**Q1: Storage location?**
- Options: feedback-state.json / independent file
- Selected: feedback-state.json (single file, mkdir lock for concurrency)

**Q2: Growth management?**
- Selected: retain last 200 entries, archive old to invocation-log-archive.json

**Q3: Update check trigger?**
- Changed from 10 to 20 (user directive)

### Area 3: Output Routing

**Q1: Write destination in GSD mode?**
- Options: phase directory / smart routing by caller
- Selected: phase directory only (from GSD_CURRENT_PHASE), recommended by Claude

**Q2: File naming?**
- Options: SD- prefix / reuse GSD naming
- Selected: SD-SUMMARY.md / SD-SUPPLEMENT.md prefix

**Q3: File type distinction?**
- Options: by plan presence / new file per call
- Selected: current_plan present → SD-SUPPLEMENT.md; absent → SD-SUMMARY.md

### Area 4: Integration Point

**Q1: Log write timing?**
- Options: Step 1 start + Step 5 end / Step 5 only
- Selected: Step 5 only (single complete write)

**Q2: Output file write timing?**
- Selected: Step 5 alongside log write

## Supplementary Areas

### S1: Non-GSD default output path
- Selected: No output file in non-GSD mode (invocation_log only)

### S2: Concurrent write safety
- Initially discussed file-per-project split → user noted same concern
- Final: Single feedback-state.json + mkdir lock with 3 retries × 200ms

### S3: counter field redundancy
- With split approach counter was potentially redundant
- After reverting to single file: counter = invocation_log.length, drives rating (every 10) and update check (every 20)

### S4: Output file frontmatter format
- Selected: Simplified — source, phase, plan(optional), generated_at, intent, routed_skill, status

### S5: Phase 8 follow-up (current_plan in gsd-context-detect.sh)
- Selected: Add during Phase 9 execution, not as a separate pre-fix

## Cross-Phase Consistency Review

Ran full Phase 0-7 → Phase 8-9 audit against git history:
- P7 D-14 overlaps with P9 GSD-02 — Phase 9 inherits and implements
- P8 D-07 confidence boost aligns with P7 D-20 (no preset priority)
- P8 SKILL.md Step 1 modification compatible with P7-03 coordinator enhancement
- No blocking conflicts found

## Deferred Ideas
- Rating popup UI interaction (belongs to scientific-do iteration)
- Update check GitHub API implementation (Phase 7 already has skill-discovery.sh)
- Cross-milestone analytics dashboard (future phase)
