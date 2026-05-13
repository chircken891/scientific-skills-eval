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

## Round 2: Deep-dive

### 4. 检测时机与缓存
- **Question:** 每次调用都检测还是缓存？
- **Options:** 每次全量 / 首次缓存 / 按需+mtime / 按需+深度上限
- **Selected:** 按需检测 + 深度上限 5 层
- **Notes:** 轻量 ls 每次调用，仅 intent 不明确（无单一 skill >0.8）时才解析文件

### 5. YAML 解析方案
- **Question:** 用什么解析 .md frontmatter？
- **Options:** awk/sed / yq / node -e
- **Selected:** node -e（跟 GSD 一致）
- **Notes:** grep fallback

### 6. 与 Step 1 融合
- **Question:** GSD 上下文如何影响 intent parsing？
- **Options:** 加权重 / 降低门槛
- **Selected:** 加权重（role 匹配 +0.2），threshold 不变
