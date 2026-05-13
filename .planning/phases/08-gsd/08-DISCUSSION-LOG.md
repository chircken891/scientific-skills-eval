# Phase 8: GSD 项目上下文感知 — Discussion Log

**Date:** 2026-05-13
**Mode:** discuss (default)

## Gray Areas Discussed

### 1. 检测策略
- **Question:** scientific-do 如何找到 `.planning/`？
- **Options:** cwd 向上遍历 / 只检查 cwd / GSD_PROJECT_ROOT 环境变量
- **Selected:** cwd 向上遍历
- **Notes:** 后续可加 GSD_PROJECT_ROOT 作为覆盖

### 2. 提取字段范围
- **Question:** 从 PROJECT.md / STATE.md / ROADMAP.md 各读多少？
- **Options:** 仅 frontmatter / frontmatter + 关键正文 / 全文件解析
- **Selected:** frontmatter + 关键正文段
- **Notes:** ROADMAP phase 列表 + STATE.md Current Position 段

### 3. 上下文暴露方式
- **Question:** 解析结果放在哪里？
- **Options:** 环境变量 / 临时 JSON / feedback-state.json
- **Selected:** 环境变量
- **Notes:** 键名: GSD_PROJECT_ROOT, GSD_PHASE_DIR, GSD_CURRENT_PHASE, GSD_PHASE_STATUS, GSD_MILESTONE

## Deferred Ideas
- GSD_PROJECT_ROOT 显式覆盖 → 后续 phase
- 嵌套 .planning/ 处理 → 边缘情况暂缓
