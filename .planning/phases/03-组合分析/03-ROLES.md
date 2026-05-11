# 03-ROLES: 角色化组合定义

**Generated:** 2026-05-11
**Source:** 03-MATRIX.md, 02-RECOMMENDATIONS.md

---

## 角色体系定义

基于Phase 2评测结果和互补分析，定义6个核心角色：

### Role 1: 文献检索专家
| 属性 | 值 |
|------|-----|
| 核心skill | deepxiv_sdk |
| 备选skill | research-superpower |
| 深度评分 | 4.0 |
| 集成度 | 13/25 |
| 覆盖范围 | 搜索,评估,渐进式阅读 |
| 角色定位 | Agent-first文献阅读，专注研究阅读体验 |

### Role 2: 数据分析专家
| 属性 | 值 |
|------|-----|
| 核心skill | scientific-agent-skills |
| 备选skill | medsci-skills |
| 深度评分 | 4.5 |
| 集成度 | 20/25 |
| 覆盖范围 | 文献,分析,写作 |
| 角色定位 | 通用分析最高分，135个skill覆盖20+领域 |

### Role 3: 论文写作专家
| 属性 | 值 |
|------|-----|
| 核心skill | academic-writing-skills |
| 备选skill | claude-scientific-writer |
| 深度评分 | 4.0 |
| 集成度 | 18/25 |
| 覆盖范围 | 写作 |
| 角色定位 | LaTeX/Typst/Word多格式，多轮修订 |

### Role 4: 图表生成专家
| 属性 | 值 |
|------|-----|
| 核心skill | paper-plot-skills |
| 备选skill | nature-skills |
| 深度评分 | 4.0 |
| 集成度 | 18/25 |
| 覆盖范围 | 分析 |
| 角色定位 | 9种真实论文图表样式 |

### Role 5: 投稿润色专家
| 属性 | 值 |
|------|-----|
| 核心skill | Paper-Polish-Workflow-skill |
| 备选skill | nature-skills |
| 深度评分 | 4.0 |
| 集成度 | 15/25 |
| 覆盖范围 | 翻译,润色,去AI化,审稿 |
| 角色定位 | 16个润色skill，完整润色流程 |

### Role 6: 综合工具专家
| 属性 | 值 |
|------|-----|
| 核心skill | AI-Research-SKILLs |
| 备选skill | scientify |
| 深度评分 | 4.0 |
| 集成度 | 19/25 |
| 覆盖范围 | 文献,分析,写作 |
| 角色定位 | 98个AI科研skill，多agent支持 |

---

## 核心skill选择依据

| 角色 | 选择 | 理由 |
|------|------|------|
| 文献检索 | deepxiv_sdk | 深度4.0，专注渐进式阅读，与其他检索tool互补 |
| 数据分析 | scientific-agent-skills | 深度4.5最高分，集成度20最高，20+领域覆盖 |
| 论文写作 | academic-writing-skills | 深度4.0，集成度18，多格式支持 |
| 图表生成 | paper-plot-skills | 深度4.0，集成度18，真实论文图表 |
| 投稿润色 | Paper-Polish-Workflow-skill | 深度4.0，专注润色去AI化 |
| 综合工具 | AI-Research-SKILLs | 集成度19，98个skill，多agent支持 |

---

## 角色分工矩阵

| 角色 | 核心能力 | 覆盖科研阶段 | 与其他角色互补 |
|------|----------|--------------|----------------|
| 文献检索专家 | 渐进式阅读 | 文献检索 | +数据分析=完整输入 |
| 数据分析专家 | 统计分析 | 数据分析 | +图表生成=可视化输出 |
| 论文写作专家 | 多格式写作 | 论文写作 | +投稿润色=完整输出 |
| 图表生成专家 | 图表制作 | 结果展示 | +数据分析=完整流程 |
| 投稿润色专家 | 润色审稿 | 投稿准备 | +论文写作=完整产出 |
| 综合工具专家 | 工具优化 | 全流程 | +其他角色=增强能力 |
