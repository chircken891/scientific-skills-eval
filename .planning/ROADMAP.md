# 科研Skill评测项目 — 路线图

## 目标
系统化评测与整合最优科研skill组合，集成到Claude Code，形成完整的医学科研工作流。

---

## 阶段规划（7个phase）

### Phase 0: 讨论与初始化
**目标：** 明确需求、建立评测体系
**输出：** PROJECT.md, REQUIREMENTS.md, config.json

| 任务 | 状态 |
|------|------|
| 需求澄清与确认 | 完成 |
| 评测体系设计 | 完成 |
| 项目初始化 | 完成 |

---

### Phase 1: 搜索与发现
**目标：** 收集所有可用科研skill仓库
**输出：** SKILLS-INVENTORY.md（39个仓库）
**状态：** 已完成（含Phase 1.5跨平台搜索的18个新增仓库）

| 任务 | 状态 |
|------|------|
| 用户提供的14个skill溯源 | 完成 |
| 图片提取skill溯源（~93个） | 完成 |
| GitHub主动搜索补充 | 完成 |

---

### Phase 1.5: 自主搜索仓库补充
**目标：** 补充发现更多科研skill仓库
**输出：** 更新SKILLS-INVENTORY.md

| 任务 | 状态 |
|------|------|
| 自主搜索GitHub补充仓库 | 下一步 |
| 验证新发现仓库有效性 | 待开始 |
| 更新仓库清单 | 待开始 |

---

### Phase 01.5.1: 评测方法预测试 (INSERTED)

**Goal:** Validate and iterate the evaluation methodology by pre-testing on 10 representative samples, discover and fix scoring system issues, set decision thresholds and approval workflow nodes. Does NOT include full evaluation or skill installation.

**Depends on:** Phase 1.5
**Plans:** 3/3 plans complete

Plans:
- [x] 01.5.1-01-PLAN.md — Scoring methodology design: rubric (10 function types), TSV template (22 columns), exclusion reason template
- [x] 01.5.1-02-PLAN.md — Re-score 10 samples, produce new format evaluations + delta analysis with D-06 validation
- [x] 01.5.1-03-PLAN.md — Phase 2 methodology specification + final summary with go/no-go recommendation

### Phase 01.5.2: 评测调整 (INSERTED)

**Goal:** Address Phase 01.5.1 pre-test findings: verify ARIS/academic-writing borderline cases, identify weak repos for EXCLUDE threshold testing, identify security concern repos for veto workflow testing, update 9-sample scores with verified implementation data. All corrections done before Phase 2.

**Depends on:** Phase 01.5.1
**Plans:** 1/1 plans complete

Plans:
- [x] 01.5.2-01-PLAN.md — Verify borderline cases (ARIS, academic-writing) + identify weak/security repos + update 9-sample scores

### Phase 2: 安全初筛与功能评测
**目标：** 使用Phase 01.5.1验证的两阶段体系，对39个科研skill进行安全否决筛选和功能评分
**输出：** 安全否决清单 + 评分卡 + 横向矩阵 + 推荐组合
**评测范围：** 39个仓库
**前置条件：** Phase 01.5.2完成（ARIS/academic-writing验证 + 弱能力仓库识别 + 安全问题仓库识别）

**Plans:** 2 plans

Plans:
- [ ] 02-01-PLAN.md — 合并预评分仓库(Phase 01.5.1/01.5.2) + 评测剩余仓库，使用两阶段体系(DepthScore 1-5)
- [ ] 02-02-PLAN.md — 横向矩阵 + 分层推荐组合（按阈值分类排序）

| 任务 | 状态 |
|------|------|
| Phase 01.5.1/01.5.2预评分合并 | 待开始 |
| 剩余仓库安全否决检查 | 待开始 |
| 剩余仓库功能深度评分(Tier 1) | 待开始 |
| 剩余仓库集成度评分(Tier 2) | 待开始 |
| 矩阵输出 | 待开始 |
| 推荐组合生成 | 待开始 |

**两阶段评测体系（Phase 01.5.1验证）：**
- Tier 1: 专业深度评分(1-5)驱动决策 (<3.0 EXCLUDE / 3.0-4.0 CANDIDATE / >4.0 AUTO-RECOMMEND)
- Tier 2: 集成度评分(5项各1-5) + 覆盖度描述
- 安全否决独立于评分运行

---

### Phase 3: 组合分析
**目标：** 分析skill间的互补性和冗余度
**输出：** 互补/冗余矩阵

| 任务 | 状态 |
|------|------|
| 功能互补分析 | 待开始 |
| 冗余度评估 | 待开始 |
| 冲突风险识别 | 待开始 |

---

### Phase 4: 最优组合生成
**目标：** 生成最优组合方案
**输出：** 组合方案 + 推荐理由

| 任务 | 状态 |
|------|------|
| 核心组合确定 | 待开始 |
| 扩展组合方案 | 待开始 |
| 手动封装候选标注 | 待开始 |

---

### Phase 5: 集成与验证
**目标：** 实际集成到Claude Code环境
**输出：** 可用skill配置 + 验证报告

| 任务 | 状态 |
|------|------|
| 安装验证 | 待开始 |
| 集成测试 | 待开始 |
| 工作流验证 | 待开始 |
| 最终报告 | 待开始 |

---

### Phase 6: 持续优化
**目标：** 跟踪已安装skill的实际效果
**输出：** 优化建议 + 新增skill推荐

| 任务 | 状态 |
|------|------|
| 使用反馈收集 | 待开始 |
| 新增skill补充 | 待开始 |
| 配置优化 | 待开始 |

---

## 成功标准

- 所有核心科研场景（流病/生统/肿瘤）有skill覆盖
- 无安全否决项
- 功能强大且不冗余
- 可实际集成运行
