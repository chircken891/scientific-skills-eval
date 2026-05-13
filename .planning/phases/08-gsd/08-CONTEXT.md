# Phase 8: GSD 项目上下文感知 — Context

**Gathered:** 2026-05-13
**Status:** Ready for research & planning

<domain>
## Domain Boundary

scientific-do 在启动时自动检测 GSD 项目上下文：找到 `.planning/` → 读取关键状态 → 暴露给后续路由和执行逻辑。不改变 scientific-do 的调度行为和 GSD 的外层调度角色。
</domain>

<decisions>
## Implementation Decisions

### D-01: 检测策略 — cwd 向上遍历

scientific-do 从当前工作目录开始，逐级向上查找 `.planning/` 目录，直到找到或到达文件系统根。后续考虑 `GSD_PROJECT_ROOT` 环境变量作为最高优先级覆盖。

**Rationale:** 兼容 git worktree、monorepo 子目录、以及从项目任意子目录调用 scientific-do 的场景。

### D-02: 提取字段范围 — frontmatter + 关键正文

从三个文件解析：
- **STATE.md**: YAML frontmatter (`status`, `current_phase`, `current_phase_name`, `paused_at`, `progress`) + `## Current Position` 正文段
- **ROADMAP.md**: YAML frontmatter + phase 列表（编号、名称、goal、完成状态）+ Progress 表格
- **PROJECT.md**: core value、constraints（供路由决策参考，不解析全文件）

### D-03: 上下文暴露 — 环境变量

解析后的 GSD 上下文写入环境变量：
- `GSD_PROJECT_ROOT` — `.planning/` 的父目录绝对路径
- `GSD_PHASE_DIR` — 当前 phase 目录路径（如有）
- `GSD_CURRENT_PHASE` — 当前 phase 编号
- `GSD_PHASE_STATUS` — phase 状态（planning/executing/complete）
- `GSD_MILESTONE` — milestone 版本号

**Rationale:** 零 IO 开销，所有子进程和 skill 天然可用，不与企业级工具冲突。

### D-04: 错误处理 — 优雅降级

- `.planning/` 不存在 → 环境变量不设，scientific-do 正常运行（无 GSD 上下文模式）
- `.planning/` 存在但文件不完整 → 解析失败时设置 `GSD_CONTEXT_ERROR` 环境变量，继续执行
- 中途调用（waves 间、checkpoint 恢复中）→ 反映实时 state，不做缓存假设
</decisions>

<canonical_refs>
## Canonical References

Downstream agents MUST read these before planning or implementing:

- `~/.claude/scientific-skills/skills/scientific-do/SKILL.md` — 现有 coordinator 完整流程（5 steps），Step 1 已有 context signals
- `~/.claude/scientific-skills/feedback-state.json` — 现有状态文件结构，Phase 9 将扩展 invocation_log
- `~/.claude/scientific-skills/scientific-skills-config.json` — 现有配置，可能新增 gsd 相关字段
- `.planning/ROADMAP.md` — v1.1 roadmap，Phase 8-9 的完整 success criteria
- `.planning/STATE.md` — 当前项目状态，需理解其 frontmatter 和 Current Position 格式
- `.planning/PROJECT.md` — 项目上下文，core value 和 constraints
</canonical_refs>

<code_context>
## Codebase Context

### Integration Point
scientific-do/SKILL.md 的 Step 1 (Proactive Intent Parsing) 已有 "Context Signals" 子步骤，检查：
- File context, Working directory, Conversation history, Research stage

GSD 上下文检测作为新的 context signal 插入 Step 1，在现有 signals 之前执行。

### Existing Infrastructure
- `feedback-state.json` 已有结构化状态（counter, ratings, skill_states, gaps, version）
- scientific-do 已有 confidence scoring 和 domain pre-filter 逻辑
- 路由逻辑（Step 2）可从环境变量读取 GSD 上下文辅助匹配
</code_context>

<deferred>
## Deferred Ideas

- `GSD_PROJECT_ROOT` 环境变量覆盖 — Phase 8 先做自动检测，后续 phase 加显式覆盖
- 多项目上下文（嵌套 `.planning/`）— 边缘情况，暂不处理
</deferred>
