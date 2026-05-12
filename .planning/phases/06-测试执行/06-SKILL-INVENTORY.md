# Phase 6 技能清单（修正后）

**整理日期:** 2026-05-12

---

## 核心技能 (7)

| # | 技能 | 类型 | 源库 | 后端依赖 | 状态 |
|---|------|------|------|----------|------|
| 1 | deepxiv_sdk | 工具型 | `DeepXiv/deepxiv_sdk` | deepxiv-sdk v0.2.5 (arXiv/PubMed) | ✓ |
| 2 | academic-paper-analysis | prompt型 | 无独立源库 | 无 | ✓ |
| 3 | scientific-agent-skills | prompt型 | `K-Dense-AI/scientific-agent-skills` | 142子skill | ✓ |
| 4 | academic-writing-skills | prompt型 | `bahayonghang/academic-writing-skills` | 22 Python脚本 | ✓ |
| 5 | paper-plot-skills | 工具型 | `Trae1ounG/paper-plot-skills` | Python/matplotlib | ✓ |
| 6 | Paper-Polish-Workflow-skill | prompt型 | `Lylll9436/Paper-Polish-Workflow-skill` | 无 (16 prompt skill) | ✓ |
| 7 | medsci-skills | 工具型 | `Aperivue/medsci-skills` | 39 skill (77.9% Python, 13% R) | ✓ |

## 协调器 (1)

| # | 技能 | 类型 | 说明 | 状态 |
|---|------|------|------|------|
| 8 | scientific-do | 自建 | intent-parser.ts + skill-router.ts | ✓ |

## 扩展技能 (3)

| # | 技能 | 源库 | 内容 | 状态 |
|---|------|------|------|------|
| 9 | nature-skills | `Yuan1z0825/nature-skills` | 7子skill (nature-figure/citation/data/polishing等) | ✓ |
| 10 | claude-scholar | `yy/claude-scholar` | 10子skill (arxiv-prep/check-refs/verify-math等) | ✓ |
| 11 | scientify | `scientify/scientify` | 10子skill (research-plan/implement/review等) | ✓ |

## 技能类型说明

- **工具型**: SKILL.md + 外部代码/工具，需要安装后端才能工作
- **prompt型**: 仅SKILL.md，实现 = Claude自身推理能力
- **自建**: 本地创建，非外部源库

## 修复记录

| 问题 | 技能 | 处理 |
|------|------|------|
| pip包未安装 | deepxiv_sdk | `pip install deepxiv-sdk` |
| 未从源库完整安装 | scientific-agent-skills | `npx skills add` (142子skill) |
| 未从源库完整安装 | academic-writing-skills | `npx skills add` (22脚本) |
| README URL写错 (Boom5426) | paper-plot-skills | `npx skills add Trae1ounG/paper-plot-skills` |
| README URL写错 (MedgeClaw) | medsci-skills | `npx skills add Aperivue/medsci-skills` (39子skill) |

**总计:** 11个skill，全部就绪。181个子skill已安装。
