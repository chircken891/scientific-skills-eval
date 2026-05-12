# 04-EXTENSION-SCHEMES: 扩展方案（角色替换）

**Generated:** 2026-05-12
**Source:** Phase 3 analysis + Phase 4 discussion decisions

---

## 扩展模式说明

**模式：** 角色替换
**原则：** 在核心方案基础上，按需替换特定角色

扩展规则：
- 替换基于Phase 3的互补/冗余分析结果
- 替换后保持组合互补性
- 核心方案保持不变，用户按需扩展

---

## 扩展方案1: Nature期刊专项

**适用场景：** Nature/Science/Cell等高影响因子期刊投稿

### 扩展规则

| 角色 | 核心方案 | 替换方案 | 替换理由 |
|------|----------|----------|----------|
| 图表生成 | paper-plot-skills | **nature-skills** | Nature期刊图表专项 |
| 投稿润色 | Paper-Polish-Workflow-skill | **nature-skills** | Nature投稿合规检查 |
| 文献检索 | deepxiv_sdk | deepxiv_sdk | 保留不变 |

### 扩展后组合

| 角色 | Skill | DepthScore | 覆盖特点 |
|------|-------|-----------|----------|
| 文献检索 | deepxiv_sdk | 4.0 | 渐进式阅读 |
| 数据分析 | scientific-agent-skills | 4.5 | 通用分析 |
| 论文写作 | academic-writing-skills | 4.0 | 多格式写作 |
| **图表生成** | **nature-skills** | 4.0 | **Nature图表** |
| **投稿润色** | **nature-skills** | 4.0 | **Nature投稿** |
| 医学专项 | medsci-skills | 4.5 | PRISMA/STROBE |

### 统计变化

| 指标 | 核心方案 | 扩展方案1 |
|------|----------|-----------|
| 学术Skill数 | 6 | 6 |
| 平均DepthScore | 4.17 | 4.08 |
| 覆盖特点 | 通用 | Nature期刊专项 |

---

## 扩展方案2: 引用管理增强

**适用场景：** 引用密集型研究（综述、meta分析）

### 扩展规则

| 角色 | 核心方案 | 扩展方案 | 替换理由 |
|------|----------|----------|----------|
| 文献检索 | deepxiv_sdk | deepxiv_sdk + **yy/claude-scholar** | 检索+引文管理 |
| 数据分析 | scientific-agent-skills | scientific-agent-skills | 保留不变 |
| 引用管理 | - | **yy/claude-scholar** | BibTeX+引文分析 |

### 扩展后组合

| 角色 | Skill | DepthScore | 覆盖特点 |
|------|-------|-----------|----------|
| 文献检索 | deepxiv_sdk | 4.0 | 渐进式阅读 |
| **引用管理** | **yy/claude-scholar** | **4.0** | **BibTeX+LaTeX检查** |
| 数据分析 | scientific-agent-skills | 4.5 | 通用分析 |
| 论文写作 | academic-writing-skills | 4.0 | 多格式写作 |
| 图表生成 | paper-plot-skills | 4.0 | 论文图表 |
| 投稿润色 | Paper-Polish-Workflow-skill | 4.0 | 去AI化 |
| 医学专项 | medsci-skills | 4.5 | PRISMA/STROBE |

### 统计变化

| 指标 | 核心方案 | 扩展方案2 |
|------|----------|-----------|
| 学术Skill数 | 6 | 7 |
| 平均DepthScore | 4.17 | 4.21 |
| 覆盖特点 | 通用 | +引用管理增强 |

---

## 扩展方案3: OpenClaw生态

**适用场景：** OpenClaw用户，扩展工具库

### 扩展规则

| 角色 | 核心方案 | 扩展方案 | 替换理由 |
|------|----------|----------|----------|
| 工具Skill | everything-claude-code | everything-claude-code + **scientify** | Claude增强+OpenClaw |

### 扩展后工具Skill

| Skill | 用途 | 适用用户 |
|-------|------|----------|
| everything-claude-code | Claude Code增强 | 所有人 |
| **scientify** | OpenClaw工具库 | **OpenClaw用户** |

### 统计变化

| 指标 | 核心方案 | 扩展方案3 |
|------|----------|-----------|
| 工具Skill数 | 1 | 2 |
| OpenClaw覆盖 | - | 5700+ skills |

---

## 扩展方案4: 快速启动（精简版）

**适用场景：** 快速测试、最小化安装

### 扩展规则

| 角色 | 核心方案 | 精简方案 | 精简理由 |
|------|----------|----------|----------|
| 数据+写作 | scientific-agent-skills | scientific-agent-skills | 自含分析+写作 |
| 检索 | deepxiv_sdk | deepxiv_sdk | 保留 |
| 图表 | paper-plot-skills | paper-plot-skills | 保留 |
| 论文写作 | academic-writing-skills | - | scientific-agent已含 |
| 投稿润色 | Paper-Polish-Workflow-skill | - | 简化 |
| 医学专项 | medsci-skills | - | 简化 |

### 精简后组合

| 角色 | Skill | DepthScore | 覆盖阶段 |
|------|-------|-----------|----------|
| 数据+写作 | scientific-agent-skills | 4.5 | 分析,写作 |
| 检索 | deepxiv_sdk | 4.0 | 文献检索 |
| 图表 | paper-plot-skills | 4.0 | 可视化 |

### 统计变化

| 指标 | 核心方案 | 扩展方案4 |
|------|----------|-----------|
| 学术Skill数 | 6 | 3 |
| 平均DepthScore | 4.17 | 4.17 |
| 安装复杂度 | 中 | 低 |

---

## 扩展方案5: 医学研究专项（Phase 3方案B）

**适用场景：** 医学/流行病学研究

### 扩展规则

| 角色 | 核心方案 | 扩展方案 | 替换理由 |
|------|----------|----------|----------|
| 数据分析 | scientific-agent-skills | **medsci-skills** | 医学统计专项 |
| 图表+投稿 | paper-plot + Paper-Polish | **nature-skills** | Nature图表+投稿 |

### 扩展后组合

| 角色 | Skill | DepthScore | 覆盖特点 |
|------|-------|-----------|----------|
| 文献检索 | deepxiv_sdk | 4.0 | 渐进式阅读 |
| **数据分析** | **medsci-skills** | **4.5** | **PRISMA/STROBE** |
| 论文写作 | academic-writing-skills | 4.0 | 多格式写作 |
| **图表生成** | **nature-skills** | **4.0** | **Nature图表** |
| **投稿润色** | **nature-skills** | **4.0** | **Nature投稿** |

### 统计变化

| 指标 | 核心方案 | 扩展方案5 |
|------|----------|-----------|
| 学术Skill数 | 6 | 5 |
| 平均DepthScore | 4.17 | 4.1 |
| 覆盖特点 | 通用 | 医学/流行病学专项 |

---

## 扩展方案对比

| 方案 | Skill数 | 特点 | 适用场景 |
|------|--------|------|----------|
| 核心方案 | 6+1 | 通用全面 | 通用研究 |
| 扩展方案1 | 6+1 | Nature期刊 | 高影响因子投稿 |
| 扩展方案2 | 7+1 | +引用管理 | 综述/meta分析 |
| 扩展方案3 | 6+2 | +OpenClaw | OpenClaw用户 |
| 扩展方案4 | 3+1 | 快速精简 | 快速测试 |
| 扩展方案5 | 5+1 | 医学专项 | 医学研究 |

---

## 扩展选择建议

| 需求 | 推荐方案 |
|------|----------|
| 通用AI/ML研究 | 核心方案 |
| Nature/Science投稿 | 扩展方案1 |
| 系统综述/meta分析 | 核心方案 + 扩展方案2 |
| OpenClaw用户 | 核心方案 + 扩展方案3 |
| 快速测试/演示 | 扩展方案4 |
| 医学/流行病学研究 | 扩展方案5 |
