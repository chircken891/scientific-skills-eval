# Phase 5: 集成与验证 - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-12
**Phase:** 5-集成与验证
**Areas discussed:** 05-02集合包结构, 05-03功能测试指南, 05-04工作流测试, 05-05验证报告

---

## Phase 5-02: 集合包结构（已在前一轮讨论）

见上一份DISCUSSION-LOG.md

---

## Phase 5-03: 功能测试指南

| Option | Description | Selected |
|--------|-------------|----------|
| 每个skill一个冒烟测试 | 每个skill一个测试用例，验证核心功能 | |
| 按workflow分阶段测试 | 按工作流顺序，每个阶段一个测试 | |
| 完整测试套件 | 冒烟测试 + 边界情况 + 异常处理 | ✓ |

**User's choice:** 完整测试套件

---

| Option | Description | Selected |
|--------|-------------|----------|
| 手动测试 | Markdown格式的测试步骤文档 | |
| 自动化脚本 | 自动化脚本，自动运行测试用例 | |
| 混合模式 | 手动测试 + 自动化验证脚本 | ✓ |

**User's choice:** 混合模式

---

| Option | Description | Selected |
|--------|-------------|----------|
| 100%通过 | 所有测试通过才算成功 | ✓ |
| 80%阈值 | 80%以上通过即可（有记录） | |
| 核心必须通过 | 核心功能必须通过，可选功能允许失败 | |

**User's choice:** 100%通过

---

## Phase 5-04: 工作流测试

| Option | Description | Selected |
|--------|-------------|----------|
| 完整场景测试 | 从用户输入到最终输出的完整路径测试 | |
| 科研流程测试 | 文献→分析→写作→投稿的线性流程 | |
| 完整+科研流程 | 两种都用 | ✓ |

**User's choice:** 完整+科研流程

---

| Option | Description | Selected |
|--------|-------------|----------|
| scientific-do协调 | 测试scientific-do能否正确协调7个skill | |
| 数据传递 | 测试skill间数据传递是否正常 | |
| 冲突处理 | 测试多个skill同时调用是否冲突 | |
| 全部测试 | 三个都测试 | ✓ |

**User's choice:** 全部测试

---

## Phase 5-05: 验证报告

| Option | Description | Selected |
|--------|-------------|----------|
| Markdown报告 | Markdown格式，可读性好 | ✓ |
| 自动化报告 | 自动化汇总脚本，生成摘要 | |
| 混合报告 | 核心摘要 + 详细数据附件 | |

**User's choice:** Markdown报告

---

| Option | Description | Selected |
|--------|-------------|----------|
| 执行摘要 | 5个sub-plan的执行情况 | ✓ |
| 测试结果汇总 | 每个skill的测试结果 | ✓ |
| 问题与解决 | 遇到的问题及解决方案 | ✓ |
| 验收确认 | 验收标准达成情况 | ✓ |

**User's choice:** 执行摘要 + 测试结果汇总 + 问题与解决 + 验收确认

---

## Deferred Ideas

- 扩展skill优先级：当核心skill和扩展skill都匹配时，如何决定？
- 跨领域触发：医学+统计场景，多个domain skill如何协调？