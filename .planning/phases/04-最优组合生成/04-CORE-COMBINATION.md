# 04-CORE-COMBINATION: 核心最优组合方案

**Generated:** 2026-05-12
**Source:** Phase 4 discussion decisions + Phase 3 analysis

---

## 核心方案（方案A）

基于1+N模式，核心方案是所有用户的基准推荐。

### 学术Skill × 6

| 角色 | Skill | GitHub | DepthScore | Integration | 覆盖阶段 | 推荐理由 |
|------|-------|--------|-----------|-------------|----------|----------|
| 文献检索 | deepxiv_sdk | DeepXiv/deepxiv_sdk | 4.0 | 13 | 搜索,评估,渐进式阅读 | Agent-first文献阅读，多数据库聚合 |
| 数据分析 | scientific-agent-skills | K-Dense-AI/scientific-agent-skills | 4.5 | 20 | 分析,写作 | 通用分析最高分，135个skill覆盖20+领域 |
| 论文写作 | academic-writing-skills | bahayonghang/academic-writing-skills | 4.0 | 18 | 写作 | LaTeX/Typst/Word多格式，多轮修订 |
| 图表生成 | paper-plot-skills | Boom5426/paper-plot-skills | 4.0 | 18 | 可视化 | 9种真实论文图表样式，plot-from-image |
| 投稿润色 | Paper-Polish-Workflow-skill | Lylll9436/Paper-Polish-Workflow-skill | 4.0 | 15 | 润色,去AI化 | 16个润色skill，完整去AI化流程 |
| 医学专项 | medsci-skills | MedgeClaw/medsci-skills | 4.5 | 18 | PRISMA/STROBE合规 | 流行病学/生物统计学/肿瘤学专项 |

### 工具Skill × 1

| Skill | GitHub | 用途 | 安装级别 | 推荐理由 |
|-------|--------|------|----------|----------|
| everything-claude-code | affaan-m/everything-claude-code | Claude Code增强 | ⚡ 强烈推荐 | 181个Skills、47子代理、/fork并行工作流 |

---

## 核心方案统计

| 指标 | 数值 |
|------|------|
| 学术Skill数 | 6 |
| 工具Skill数 | 1 |
| 总Skill数 | 7 |
| 平均DepthScore | 4.17 |
| 平均Integration | 17.0 |
| 覆盖科研流程 | 文献检索 → 数据分析 → 论文写作 → 图表生成 → 投稿润色 |

---

## 覆盖度分析

### 科研阶段覆盖

| 阶段 | 覆盖Skill | 覆盖度 |
|------|-----------|--------|
| 文献检索 | deepxiv_sdk | ★★★★★ |
| 研究设计 | medsci-skills | ★★★★★ |
| 数据分析 | scientific-agent-skills | ★★★★★ |
| 论文写作 | academic-writing-skills | ★★★★★ |
| 图表制作 | paper-plot-skills | ★★★★★ |
| 投稿润色 | Paper-Polish-Workflow-skill | ★★★★★ |
| 投稿合规 | medsci-skills (PRISMA/STROBE) | ★★★★★ |

### 功能领域覆盖

| 领域 | 覆盖Skill | 深度 |
|------|-----------|-------|
| 通用科研 | scientific-agent-skills | 最高(4.5) |
| 医学研究 | medsci-skills | 最高(4.5) |
| 学术写作 | academic-writing-skills | 高(4.0) |
| 文献检索 | deepxiv_sdk | 高(4.0) |
| 图表生成 | paper-plot-skills | 高(4.0) |

---

## 核心方案安装命令（参考）

```bash
# 学术Skill
claude skill install https://github.com/DeepXiv/deepxiv_sdk
claude skill install https://github.com/K-Dense-AI/scientific-agent-skills
claude skill install https://github.com/bahayonghang/academic-writing-skills
claude skill install https://github.com/Boom5426/paper-plot-skills
claude skill install https://github.com/Lylll9436/Paper-Polish-Workflow-skill
claude skill install https://github.com/MedgeClaw/medsci-skills

# 工具Skill
claude skill install https://github.com/affaan-m/everything-claude-code
```

---

## 互补性验证

核心方案6个学术Skill之间的互补性：

| Pair | 互补度 | 类型 |
|------|--------|------|
| deepxiv_sdk + scientific-agent-skills | 4 | 检索+分析 |
| scientific-agent-skills + academic-writing-skills | 4 | 分析+写作 |
| academic-writing-skills + Paper-Polish-Workflow-skill | 4 | 写作+润色 |
| scientific-agent-skills + paper-plot-skills | 4 | 分析+可视化 |
| medsci-skills + scientific-agent-skills | 4 | 医学+通用 |

**无冗余：** 所有skill功能互补，无功能重叠

---

## 与Phase 3分析的对应关系

- **文献检索：** Phase 3分析确认deepxiv_sdk为检索专项最高分
- **数据分析：** scientific-agent-skills为Phase 3分析确认的最高分(4.5)
- **学术写作：** academic-writing-skills为Phase 3分析确认的写作专项最高分
- **图表生成：** paper-plot-skills为Phase 3分析确认的图表专项最高分
- **投稿润色：** Paper-Polish-Workflow-skill为Phase 3分析确认的润色专项
- **医学专项：** medsci-skills为Phase 3分析确认的医学专项最高分(4.5)
