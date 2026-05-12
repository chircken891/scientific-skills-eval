# 03-COMBINATIONS: 角色化组合方案

**Generated:** 2026-05-11
**Updated:** 2026-05-11 (修正结构)
**Source:** 03-ROLES.md, 03-MATRIX.md

---

## 组合结构

推荐组合由两个并列类别组成：

1. **学术Skill** — 专注科研流程的核心能力
2. **工具Skill** — Claude Code优化和开发辅助（单独安装）

---

## 三种推荐组合方案

### 方案A: 核心团队

#### 学术Skill (6个)

| 角色 | Skill | DepthScore | Integration | 覆盖阶段 |
|------|-------|-----------|-------------|----------|
| 文献检索 | deepxiv_sdk | 4.0 | 13 | 搜索,评估 |
| 数据分析 | scientific-agent-skills | 4.5 | 20 | 分析,写作 |
| 论文写作 | academic-writing-skills | 4.0 | 18 | 写作 |
| 图表生成 | paper-plot-skills | 4.0 | 18 | 可视化 |
| 投稿润色 | Paper-Polish-Workflow-skill | 4.0 | 15 | 润色 |
| 医学专项 | medsci-skills | 4.5 | 18 | 医学分析 |

#### 工具Skill (1-2个)

| Skill | 用途 | 安装建议 |
|-------|------|----------|
| everything-claude-code | Claude Code增强 | ⚡ 强烈推荐安装 |

**适用场景:** 通用AI/ML研究、学术论文写作

---

### 方案B: 医学专项

#### 学术Skill (5个)

| 角色 | Skill | DepthScore | Integration | 覆盖阶段 |
|------|-------|-----------|-------------|----------|
| 文献检索 | deepxiv_sdk | 4.0 | 13 | 搜索,评估 |
| 数据分析 | medsci-skills | 4.5 | 18 | 医学分析 |
| 论文写作 | academic-writing-skills | 4.0 | 18 | 写作 |
| 图表+投稿 | nature-skills | 4.0 | 18 | Nature图表 |

#### 工具Skill (1-2个)

| Skill | 用途 | 安装建议 |
|-------|------|----------|
| everything-claude-code | Claude Code增强 | ⚡ 强烈推荐安装 |
| scientify | OpenClaw工具库 | 🔧 OpenClaw用户额外安装 |

**适用场景:** 医学研究、流行病学研究、生物统计学、肿瘤学

---

### 方案C: 精简版

#### 学术Skill (3个)

| 角色 | Skill | DepthScore | Integration | 覆盖阶段 |
|------|-------|-----------|-------------|----------|
| 数据+写作 | scientific-agent-skills | 4.5 | 20 | 分析,写作 |
| 检索 | deepxiv_sdk | 4.0 | 13 | 文献检索 |
| 图表 | paper-plot-skills | 4.0 | 18 | 可视化 |

#### 工具Skill

| Skill | 用途 | 安装建议 |
|-------|------|----------|
| everything-claude-code | Claude Code增强 | ⚡ 强烈推荐安装 |

**适用场景:** 快速测试、最小化安装、单一研究任务

---

## 方案对比

| 指标 | 方案A | 方案B | 方案C |
|------|-------|-------|-------|
| 学术Skill数 | 6 | 5 | 3 |
| 工具Skill数 | 1 | 1-2 | 1 |
| 平均DepthScore | 4.17 | 4.1 | 4.17 |
| 覆盖完整性 | ★★★★★ | ★★★★☆ | ★★★☆☆ |
| 适用场景 | 通用研究 | 医学研究 | 快速启动 |

---

## 工具Skill说明

| Skill | Domain | 用途 | 为什么需要 |
|-------|--------|------|-------------|
| everything-claude-code | Agent优化 | Claude Code增强 | 181个Skills、47子代理、/fork并行工作流等，显著提升Claude Code能力 |
| scientify | OpenClaw生态 | OpenClaw工具库 | 5700+ OpenClaw skills，仅OpenClaw用户需要 |
| anthropics/skills | Skills框架 | 开发规范参考 | Skills编写规范，建议阅读而非安装 |
