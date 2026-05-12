# 科研Skill评测 — Phase 5 Context

**Gathered:** 2026-05-12
**Phase:** 5-集成与验证
**Status:** Ready for execution

---

<domain>
## Phase Boundary

将Phase 4生成的最优组合方案（6个学术Skill + 1个工具Skill）实际安装到Claude Code环境，验证：
- 功能可用性
- 工作流连通性
- 组合效果

输出详细验证报告。

</domain>

<decisions>
## Implementation Decisions

### 验证方法
- **D-01:** 完整验证 — 功能测试 + 工作流测试 + 组合效果验证

### 验证内容
- **D-02:** 组合效果验证 — 验证skill间的数据传递和配合

### 输出格式
- **D-03:** 详细报告 — 每个skill的验证结果和组合效果

### 核心方案（需验证的Skill）

**学术Skill (6个):**
| 角色 | Skill | GitHub |
|------|-------|--------|
| 文献检索 | deepxiv_sdk | DeepXiv/deepxiv_sdk |
| 数据分析 | scientific-agent-skills | K-Dense-AI/scientific-agent-skills |
| 论文写作 | academic-writing-skills | bahayonghang/academic-writing-skills |
| 图表生成 | paper-plot-skills | Boom5426/paper-plot-skills |
| 投稿润色 | Paper-Polish-Workflow-skill | Lylll9436/Paper-Polish-Workflow-skill |
| 医学专项 | medsci-skills | MedgeClaw/medsci-skills |

**工具Skill (1个):**
| Skill | GitHub |
|-------|--------|
| everything-claude-code | affaan-m/everything-claude-code |

### 验证任务
- **D-04:** 安装验证 — 每个skill安装后检查可用性
- **D-05:** 功能测试 — 对每个skill执行核心功能测试
- **D-06:** 工作流测试 — 端到端测试科研工作流
- **D-07:** 组合效果验证 — 验证skill间配合

</decisions>

<canonical_refs>
## Canonical References

### Phase 4 最优组合
- `.planning/phases/04-最优组合生成/04-OPTIMAL-COMBINATION.md` — 最优组合方案
- `.planning/phases/04-最优组合生成/04-CORE-COMBINATION.md` — 核心方案详细

### Phase 3 分析
- `.planning/phases/03-组合分析/03-MATRIX.md` — 互补/冗余矩阵
- `.planning/phases/03-组合分析/03-COMBINATIONS.md` — 组合方案

### Phase 2 评测
- `.planning/phases/02-安全初筛与功能评测/02-MATRIX.md` — 评测矩阵

### 项目文档
- `.planning/ROADMAP.md` — Phase 5定义
- `.planning/PROJECT.md` — 项目目标

</canonical_refs>

<deferred>
## Deferred Ideas

- 自动化验证脚本（未来可集成）
- 持续集成验证（CI/CD）

</deferred>

---

*Phase: 5-集成与验证*
