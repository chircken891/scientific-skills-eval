# Rubric: Workflow Orchestration / Pipeline

For skills that chain multiple stages into a complete workflow, with checkpoints, data flow management, and error handling.

**Special rule:** For pipeline or orchestrator skills, score ONLY the orchestration capability — not the individual stage capabilities. Stage quality is the responsibility of the underlying skill each stage uses.

## Score Criteria

| Score | Criteria |
|-------|----------|
| 5/5 | Full multi-stage pipeline (8+ stages) covering complete research workflow. Each stage has documented inputs/outputs. Checkpoint at every stage allowing user review, modification, and resumption. Cross-stage data validation (output schema checks between stages). Error handling with recovery options (retry, skip, replace stage). Pipeline state persistence across sessions. Parallel stage execution where independent. |
| 4/5 | Multi-stage pipeline (5-7 stages). Checkpoints at major stages. Basic data validation between stages. Error handling with graceful failure. State persistence within session. |
| 3/5 | Linear pipeline (3-4 stages) with sequential execution. Single checkpoint option. Minimal error handling (fails on any error). Basic stage-to-stage data passing. |
| 2/5 | 2-stage chaining. No checkpoint support. No error handling (cascading failure). Data passed via ad-hoc methods. |
| 1/5 | No pipeline capability. All steps executed in a single block with no stage separation. No resumability. |

## Score Translation

- **5** → 8+stage+全程检查点+跨stage验证+错误恢复+持久化+并行
- **4** → 5-7stage但检查点有限或并行能力缺失
- **3** → 3-4stage线性，无检查点或无并行
- **2** → 2stage，无检查点
- **1** → 无pipeline概念

## Function Type ID

`workflow-orchestration`