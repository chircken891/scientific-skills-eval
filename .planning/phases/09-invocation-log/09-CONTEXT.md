# Phase 9: 调用追踪与 GSD 合规产出 — Context

**Gathered:** 2026-05-13
**Status:** Ready for planning

<domain>
## Phase Boundary

scientific-do 每次执行生成结构化调用记录（invocation_log），在 GSD 项目内时产出合规文件（SD-SUMMARY.md / SD-SUPPLEMENT.md）写入 phase 目录。实现可审计的执行追踪，支撑 Phase 7 的反馈闭环（评分触发、更新检查触发）。

继承 Phase 7 D-14（静默自动记录），落地为具体的 invocation_log 实现。
</domain>

<decisions>
## Implementation Decisions

### D-01: invocation_log schema

每条记录包含以下字段：

| 字段 | 来源 | 说明 |
|------|------|------|
| `timestamp` | `date -Iseconds` | ISO 时间戳 |
| `intent` | Step 1 解析结果 | 用户原始意图文本 |
| `routed_skill` | Step 2 路由结果 | 路由到的 skill 名称；gap_detected 时为 null |
| `status` | Step 4/5 判定 | `success` / `failure` / `partial` / `gap_detected` |
| `error_summary` | Step 4 判定 | 仅 status ≠ success 时有值 |
| `execution_summary` | Step 5 生成 | 单行执行摘要（做了什么、产出什么） |
| `phase` | GSD_CURRENT_PHASE 环境变量 | GSD 项目内时有值，否则 null |
| `plan` | gsd-context-detect.sh JSON 的 current_plan | STATE.md Current Position 中有 plan 时才设 |
| `duration_ms` | Step 1 和 Step 5 时间差 | 毫秒级 |

`status` 取值含义：
- `success` — 路由成功，技能执行完成
- `failure` — 路由成功但技能执行报错
- `partial` — 部分完成（多步骤流程中途中断或部分失败）
- `gap_detected` — 检测到能力缺口，触发 P7 D-09~D-12 的 skill 发现流程

### D-02: 存储与并发的自洽设计

- invocation_log 数组存储在 `~/.claude/scientific-skills/feedback-state.json` 的顶层 key `invocation_log`
- 写入前用 `mkdir` 创建锁目录 `.feedback-state.lock`，写入后删除；获取不到锁时重试 3 次，间隔 200ms
- 保留最近 200 条记录；超出时旧记录归档到 `~/.claude/scientific-skills/invocation-log-archive.json`（追加写，不清空）
- 全局 `counter` 字段保留且与 `invocation_log.length` 同步（每次写入后 `counter = invocation_log.length`）

### D-03: 反馈触发机制

- 评分弹窗触发器：counter % 10 == 0，弹出 1-5 分评分（P7 D-15）
- 更新检查触发器：counter % 20 == 0，检查所有已安装 skill 的 GitHub 上游更新（修改自 P7 D-16 的 10，改为 20）
- 更新检查结果：通知摘要 + 人工确认，不自动更新（P7 D-17）
- 更新后全量冒烟测试（P7 D-18）

### D-04: GSD 产出文件（合规输出）

- **GSD 项目内**：产出写入 `$GSD_PROJECT_ROOT/.planning/phases/<phase-slug>/`
  - 有 `current_plan`：写入 `SD-SUPPLEMENT.md`（plan 级）
  - 无 `current_plan`：写入 `SD-SUMMARY.md`（phase 级）
  - 同一 phase 内后续调用追加到同一文件
- **非 GSD 项目**：不写产出文件，仅记录 invocation_log（无 phase/plan 字段）
- **产出文件 frontmatter**（简化版）：

```yaml
source: scientific-do
phase: N
plan: "08-01"       # 可选
generated_at: "ISO时间"
intent: "用户原始意图"
routed_skill: "skill名"
status: success | failure | partial | gap_detected
```

### D-05: scientific-do 集成点

- invocation_log 写入：Step 5 结束时一次性写入完整 entry（包含 duration_ms）
- 产出文件写入：Step 5 同时执行，与 invocation_log 写入在同一事务内
- 非 GSD 路径：Step 5 只写 invocation_log，跳过产出文件

### D-06: Phase 8 follow-up

- gsd-context-detect.sh 补充 `current_plan` 输出字段：解析 STATE.md `## Current Position` 段的 `Plan:` 行
- "—" 或空值映射为 JSON `null`
- Phase 9 planning 时包含此修改任务

### Claude's Discretion

- 日志归档的触发时机（条数达到 200 时即时归档，还是 phase 结束时批量归档）
- invocation_log json 缩进风格（compact vs pretty-print — 建议 compact 控制文件体积）
- 锁重试的等待策略细节
- SD-SUMMARY.md / SD-SUPPLEMENT.md body 正文格式

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase 8 交付物（运行时依赖）
- `~/.claude/scientific-skills/scripts/gsd-context-detect.sh` — GSD 上下文检测脚本，Phase 9 依赖其 JSON 输出中的 current_plan 字段
- `~/.claude/scientific-skills/skills/scientific-do/SKILL.md` — scientific-do 协调器当前定义（5 steps），Phase 9 修改 Step 5
- `~/.claude/scientific-skills/feedback-state.json` — 现有状态文件结构（counter、ratings、skill_states、gaps、version），Phase 9 扩展 invocation_log

### Phase 7 设计基础（继承关系）
- P7 D-14：静默自动记录每次 skill 调用 → Phase 9 落地为 invocation_log
- P7 D-15：每 10 次弹出评分 → counter 驱动
- P7 D-16~D-18：更新检查与反馈绑定 → counter 驱动，检查间隔改为 20
- P7 D-09~D-12：缺口检测→搜索→入库 → invocation_log 的 gap_detected status 覆盖

### 项目级文档
- `.planning/REQUIREMENTS.md` — GSD-02（invocation_log）、GSD-03（合规输出）
- `.planning/ROADMAP.md` — Phase 9 success criteria
- `.planning/PROJECT.md` — 项目 core value 和 constraints
- `.planning/phases/08-gsd/08-CONTEXT.md` — Phase 8 决策（env var 约定、D-03/D-04/D-05/D-07）

</canonical_refs>

<code_context>
## Existing Code Insights

### 运行时基础设施（Phase 8 产物）
- `gsd-context-detect.sh`：输出 JSON 含 `gsd_project_root`、`current_position.phase`、`state.milestone` 等字段；需补充 `current_position.plan`
- `GSD_PROJECT_ROOT`、`GSD_CURRENT_PHASE`、`GSD_PHASE_STATUS`、`GSD_MILESTONE` 环境变量已在 scientific-do Step 1 设置

### 存储基础设施
- `feedback-state.json`：当前结构 `{counter, last_feedback_at, ratings, skill_states, gaps, version}` → Phase 9 新增 `invocation_log` 顶层 key
- `scientific-skills-config.json`：skill_registry.role 映射，供 status=gap_detected 时参考

### scientific-do 5-step 结构
- Step 1：意图解析 + GSD 上下文检测（Phase 8 已修改）
- Step 2：skill 路由
- Step 3：执行
- Step 4：验证
- Step 5：**反馈（Phase 9 集成点）** — 当前可能为空或轻量实现
</code_context>

<specifics>
## Specific Ideas

- 产出文件命名遵循 SD- 前缀约定，与 GSD 自产的 NN-SUMMARY.md 明确区分
- 文件追加模式避免同 phase 内多次调用产生大量碎片文件
- mkdir 锁模式与 GSD 自身 git 锁保持一致性
</specifics>

<deferred>
## Deferred Ideas

- P7 D-15 评分弹窗的具体 UI 交互 — 归 scientific-do 自身迭代，非 Phase 9 范围
- P7 D-16 更新检查的具体实现（GitHub API compare） — Phase 7 已有 skill-discovery.sh，Phase 9 只负责触发
- 跨 milestone 的调用统计面板 — 后续独立 phase
</deferred>

---

*Phase: 09-invocation-log*
*Context gathered: 2026-05-13*
