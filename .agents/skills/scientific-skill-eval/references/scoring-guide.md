# Scoring Guide for LLM Evaluators

This guide helps the LLM assign accurate 1-5 scores during skill evaluation.

## General Scoring Principles

1. **Evidence over claims** — Score based on what the code/docs actually demonstrate, not what the README promises
2. **Specialization rewarded** — A skill that does one thing brilliantly scores higher than one that does many things poorly
3. **Increments of 0.5** — Use 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0 (not arbitrary decimals)
4. **Same-type comparison** — Compare against other skills of the same function type, not across types

## Scoring Process

For each selected function:

### Step 1: Read the SKILL.md
Identify the skill's self-declared purpose, primary capabilities, and target users.

### Step 2: Read the corresponding rubric
Load `references/rubric-{function-type}.md`. Understand the 5/5 ideal and what disqualifies a skill from each score.

### Step 3: Examine evidence
Look for:
- Concrete code/implementations (not just prompts)
- Working examples or demos
- Test files with coverage
- Detailed documentation
- Actual output samples

### Step 4: Assign score
Find the best match in the rubric table. Ask: "If this rubric describes 5 levels of quality, which best matches what this skill actually demonstrates?"

### Step 5: Check edge cases
- Does the skill **actually implement** what it claims, or just describe it?
- Is the implementation **integrated** or just bolted on?
- Are there **obvious gaps** that a user would hit immediately?

## Common Scoring Pitfalls

| Pitfall | Why it's wrong | Correction |
|---------|----------------|------------|
| Scoring too high because README is well-written | Marketing ≠ implementation | Look at actual code |
| Scoring too low because niche | Specialization is a strength | Narrow focus gets full marks in its domain |
| Scoring mid-range for everything | Lack of discrimination | Force a decision: which end is this closer to? |
| Penalizing for missing features | Only penalize if claimed and missing | A 3/5 literature search doesn't need figure generation |

## DepthScore Calculation

```
if 1 function scored: DepthScore = Function1_Score
if 2 functions scored: DepthScore = round_to_nearest_0.5((F1 + F2) / 2)

Rounding: 0.25 → round up, 0.24 → round down
Examples:
  (4.0 + 4.0) / 2 = 4.0 → 4.0
  (4.0 + 3.5) / 2 = 3.75 → 4.0
  (3.5 + 3.5) / 2 = 3.5 → 3.5
  (3.0 + 3.0) / 2 = 3.0 → 3.0
```

## Security Veto Rules

**Any ONE check failing = immediate EXCLUDE, stop scoring.**

Do not:
- Proceed to scoring if security fails
- Give "partial credit" for security issues
- Assume credentials are OK because they're in a config file marked "example"

Do:
- Report exactly which check failed and why
- Provide specific file:line evidence for the failure
- Stop immediately after first failure

## Integration Assessment (Tier 2)

Tier 2 scores are **descriptive, not decision-driving**. They're for human context, not threshold classification.

For each dimension, score based on:
- Integration难度: How much work to integrate? (1=easy drop-in, 5=requires major refactor)
- MCP兼容: Does it use standard MCP protocols? (1=fully MCP compatible, 5=proprietary)
- 冲突风险: Risk of stepping on other skills' toes? (1=isolated, 5=high overlap/conflict)
- 维护成本: Ongoing maintenance burden? (1=self-contained, 5=many external dependencies)
- 上下文依赖: Needs specific project state? (1=stateless, 5=requires specific context)

## Output Generation

After scoring, generate the markdown report using the template in SKILL.md.
- Use the exact table format shown
- Fill in all fields or mark as N/A if not applicable
- For EXCLUDE, always include the three-field exclusion reason: [check] | [evidence] | [impact]