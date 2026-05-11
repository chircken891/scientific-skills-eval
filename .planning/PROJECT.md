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
