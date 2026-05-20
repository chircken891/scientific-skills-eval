# 示例 GSD 科研项目

## What This Is

A test fixture project for verifying GSD context detection script behavior.

## Core Value

科学工作流的自动化编排 — 意图检测 → 技能路由 → 执行 → 反馈闭环。

## Constraints

- **安全**：数据安全、权限范围、网络请求、依赖来源
- **流程**：先评后安装，Claude 主导执行
- **质量**：所有交付物需通过自动化测试

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| 安全一票否决 | 科研数据敏感，不可妥协 | ✓ Good |
| 两阶段评估架构 | 专业深度驱动决策 | ✓ Good |
