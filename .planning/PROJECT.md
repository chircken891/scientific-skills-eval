# 科研Skill/Plugin 评测与集成

## What This Is

一个系统化的评测与整合流程，从海量科研相关 skill/plugin 中筛选出最优组合，集成到 Claude Code 环境，形成完整的医学科研工作流。覆盖流行病学、生物统计学、肿瘤学等领域。

## Core Value

安全且功能强大的科研 skill 组合，覆盖核心医学研究场景，无冗余。

## Requirements

### Active

- [ ] 建立评测体系（含安全、功能、集成度评分维度）
- [ ] 收集科研方向已有 skill/plugin
- [ ] 主动搜索补充相关 skill/plugin
- [ ] 对每个 skill/plugin 进行独立评测
- [ ] 生成最优组合方案
- [ ] 完成集成

### Out of Scope

- 不做 skill/plugin 开发（除非现有方案都不满足）
- 不评价学术论文内容本身

## Context

- Claude Code 使用场景
- 领域方向：流行病学、生物统计学、肿瘤学
- 输入形式：名称或网页链接
- 安全是一票否决项

## Constraints

- **安全**：数据安全、权限范围、网络请求、依赖来源 — 任一项不合格直接否决
- **流程**：先评后安装，Claude 主导执行
- **命名**：暂不自主命名，最后提醒用户

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| 安全一票否决 | 科研数据敏感，不可妥协 | — Pending |
| 主动搜索补充 | 不限于用户发来的 | — Pending |
| 功能优先于冗余 | 强大功能 > 最小组合 | — Pending |
| 最后集成 | 先评后装 | — Pending |

## 两阶段评估架构（新）

从Phase 01.5.1开始，评测体系从旧版加权求和模型（功能40% + 集成度30% + 覆盖度30%）重构为两阶段评估：

```
[4 security checks: pass/fail]                   → 独立否决（不变）
[Functional depth: score only                    → TIER 1 (1-5 rating) = 决策驱动因子
 the 1-2 best functions]                                    |
                                                  ┌─────────┴──────────┐
                                                  ▼                    ▼
                                             < 3: EXCLUDE    3-4: CANDIDATE   >4: AUTO-RECOMMEND
                                                  │                    │              │
                                                  ▼                    ▼              ▼
                                            [reason required]   [auto-classify]  [auto-classify]

[Coverage: descriptive] ──────→ TIER 2（组合输入，不再评分）
[Integration: scored]   ──────→          用于判断哪些skill可以组合
                                         人工确认最终组合方案
```

### 安全（一票否决，不变）

| 检查项 | 说明 |
|--------|------|
| 数据安全 | 是否访问/存储敏感数据 |
| 权限范围 | 是否申请过度权限 |
| 网络请求 | 是否有可疑外网通信 |
| 依赖来源 | 第三方依赖是否可信 |

**规则：** 任一项不合格 → 标记「否决 + 原因」，不进入组合候选

### 专业深度评价（Tier 1: 1-5评分，功能维度的替换）

**核心变化：** 从8个子维度各5分（全能评价）→ 选择该skill最擅长的1-2个功能，按1-5专业深度评分

| 属性 | 说明 |
|------|------|
| 评分对象 | skill最擅长的1-2个功能（见SCORING-RUBRIC.md的Function Selection Priority Rule） |
| 评分范围 | 1.0 - 5.0，0.5递增（共9级：1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0） |
| 深度分计算 | DepthScore = average(Function1_Score, Function2_Score)，四舍五入到最近0.5 |
| 核心原则 | 专业化skill不因不全能而被惩罚（D-06）—— 问的是"做得好不好"而非"多全能" |

**阈值规则（D-07/D-08/D-09）：**
- < 3.0 → EXCLUDE（必须附排除理由）
- 3.0 - 4.0 → CANDIDATE（自动分类待选）
- > 4.0 → AUTO-RECOMMEND（直接进入组合推荐）

### 集成度（30%）

| 维度 | 说明 |
|------|------|
| Claude Code 集成难度 | 安装复杂度、配置成本 |
| MCP 兼容性 | 是否支持 MCP 协议 |
| 冲突风险 | 与其他 skill 的功能重叠/冲突 |
| 维护成本 | 更新频率、社区支持 |
| 上下文依赖 | 是否依赖长上下文（MiniMax 400万 token，上下文消耗不再是瓶颈） |

### 覆盖度（描述性 — Tier 2，不再评分）

**核心变化：** 从4个子维度各5分（评分项）→ 描述性信息，用于组合推荐时的参考

| 维度 | 说明 | 记录方式 |
|------|------|----------|
| 科研阶段覆盖 | 覆盖哪个阶段：文献→分析→写作→投稿 | 多选：文献/分析/写作/投稿 |

备注：覆盖度不再计入评分。Coverage_Stages记录覆盖哪些阶段，Coverage_Description用1-2句话描述其领域范围。Tier 2信息在组合推荐时由人工判断互补性。

### 输出格式（新两阶段架构）

```
## [Skill名称]
**来源：** [用户发来/图片提取/主动搜索]
**链接：** [URL或文件路径]

### 安全
- 数据安全：✓/✗
- 权限范围：✓/✗
- 网络请求：✓/✗
- 依赖来源：✓/✗
**结论：** 通过 / 否决（原因）

### 专业深度评价（Tier 1）

**Selected Function 1:** [名称] — 分数：X.X/5
**Selected Function 2:** [名称 — 可选] — 分数：X.X/5
**DepthScore:** X.X/5
**Threshold Classification:** [EXCLUDE / CANDIDATE / AUTO-RECOMMEND]

**评分依据：** [简要引用rubric标准，说明为什么给出该分数]
**排除理由（若EXCLUDE）：** [检查项] | [证据引用] | [为何重要]

### 集成度评分：X/5
- Claude Code 集成难度：X/5
- MCP 兼容性：X/5
- 冲突风险：X/5
- 维护成本：X/5
- 上下文依赖：X/5

### 覆盖度（Tier 2 — 描述性）
- 科研阶段覆盖：文献 / 分析 / 写作 / 投稿
- 描述：1-2句话描述领域范围和覆盖阶段

### 特点
- 优势：
- 劣势：

### 适用场景
### 排除原因（若否决）
```

---
*Last updated: 2026-05-11 after new two-tier scoring architecture defined*
