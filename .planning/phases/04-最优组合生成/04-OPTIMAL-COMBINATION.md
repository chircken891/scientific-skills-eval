# 04-OPTIMAL-COMBINATION: 最优组合方案

**Generated:** 2026-05-12
**Phase:** 4-最优组合生成
**Status:** Final Document

---

## 执行摘要

本项目通过Phase 2的39个仓库评测 → Phase 3的互补/冗余分析 → 最终生成1+N模式的最优组合方案。

**核心方案：** 6个学术Skill + 1个工具Skill
**扩展方案：** 5个角色替换变体

---

## 核心方案（方案A）

### 学术Skill × 6

| 角色 | Skill | GitHub | DepthScore | Integration |
|------|-------|--------|-----------|-------------|
| 文献检索 | deepxiv_sdk | DeepXiv/deepxiv_sdk | 4.0 | 13 |
| 数据分析 | scientific-agent-skills | K-Dense-AI/scientific-agent-skills | 4.5 | 20 |
| 论文写作 | academic-writing-skills | bahayonghang/academic-writing-skills | 4.0 | 18 |
| 图表生成 | paper-plot-skills | Boom5426/paper-plot-skills | 4.0 | 18 |
| 投稿润色 | Paper-Polish-Workflow-skill | Lylll9436/Paper-Polish-Workflow-skill | 4.0 | 15 |
| 医学专项 | medsci-skills | MedgeClaw/medsci-skills | 4.5 | 18 |

### 工具Skill × 1

| Skill | GitHub | 用途 |
|-------|--------|------|
| everything-claude-code | affaan-m/everything-claude-code | ⚡ Claude Code增强 |

### 统计

| 指标 | 数值 |
|------|------|
| 学术Skill数 | 6 |
| 工具Skill数 | 1 |
| 平均DepthScore | 4.17 |
| 平均Integration | 17.0 |

---

## 扩展方案（角色替换）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| 扩展方案1 | Nature期刊专项 | 高影响因子投稿 |
| 扩展方案2 | +引用管理 | 综述/meta分析 |
| 扩展方案3 | +OpenClaw生态 | OpenClaw用户 |
| 扩展方案4 | 快速精简版 | 快速测试 |
| 扩展方案5 | 医学研究专项 | 流行病学研究 |

详见 [04-EXTENSION-SCHEMES.md](04-EXTENSION-SCHEMES.md)

---

## 安装指南

### 核心方案安装顺序

```
# 阶段1: 基础工具
1. deepxiv_sdk         # 文献检索

# 阶段2: 核心分析
2. scientific-agent-skills  # 数据分析

# 阶段3: 专业工具
3. academic-writing-skills   # 论文写作
4. paper-plot-skills        # 图表生成
5. medsci-skills            # 医学专项

# 阶段4: 润色工具
6. Paper-Polish-Workflow-skill  # 投稿润色

# 阶段5: 工具优化（单独安装）
7. everything-claude-code    # Claude Code增强
```

### 安装命令参考

```bash
# 学术Skill（6个）
claude skill install https://github.com/DeepXiv/deepxiv_sdk
claude skill install https://github.com/K-Dense-AI/scientific-agent-skills
claude skill install https://github.com/bahayonghang/academic-writing-skills
claude skill install https://github.com/Boom5426/paper-plot-skills
claude skill install https://github.com/Lylll9436/Paper-Polish-Workflow-skill
claude skill install https://github.com/MedgeClaw/medsci-skills

# 工具Skill（单独安装）
claude skill install https://github.com/affaan-m/everything-claude-code
```

---

## 互斥规则

### 应排除的Skill

| Skill | 原因 | 替代方案 |
|-------|------|----------|
| research-workflow-assistant | 深度3.0，冗余 | - |
| nicholash84/Claude-Scientific-Skills | 信息有限 | - |

### 二选一规则

| Skill A | Skill B | 选择建议 |
|--------|--------|----------|
| scientify | scientific-agent-skills | scientific-agent-skills（更通用） |
| paper-plot-skills | nature-skills | 通用→paper-plot，Nature→nature |
| deepxiv_sdk | ARIS | 均可，可同时安装 |

---

## 推荐理由

### 为什么选择这些Skill

| Skill | 推荐理由 | Phase 3依据 |
|-------|----------|-------------|
| deepxiv_sdk | 渐进式阅读专项，多数据库聚合 | 文献检索类最高分(4.0) |
| scientific-agent-skills | 135个skill覆盖20+领域，通用分析最高分 | 数据分析类最高分(4.5, 20) |
| academic-writing-skills | LaTeX/Typst/Word多格式，多轮修订 | 学术写作类最高分(4.0, 18) |
| paper-plot-skills | 9种真实论文图表，plot-from-image | 图表生成类最高分(4.0, 18) |
| Paper-Polish-Workflow-skill | 16个润色skill，去AI化流程 | 润色专项，无直接竞争 |
| medsci-skills | PRISMA/STROBE合规，医学统计 | 医学研究类最高分(4.5, 18) |
| everything-claude-code | Claude Code增强，/fork并行工作流 | 工具类，无直接竞争 |

### 互补性验证

所有skill功能互补，无功能重叠：
- deepxiv_sdk → 检索
- scientific-agent-skills → 分析
- academic-writing-skills → 写作
- paper-plot-skills → 可视化
- Paper-Polish-Workflow-skill → 润色
- medsci-skills → 医学专项

---

## 覆盖度总结

### 科研阶段全覆盖

```
文献检索 → 研究设计 → 数据分析 → 论文写作 → 图表制作 → 投稿润色 → 投稿合规
   ↓            ↓           ↓           ↓           ↓           ↓         ↓
deepxiv    medsci    scientific    academic    paper-plot    Paper      medsci
sdk       -skills    -agent       -writing    -skills      Polish     -skills
                                -skills                           -skill  STROBE
```

### 适用研究类型

| 研究类型 | 推荐组合 |
|----------|----------|
| 通用AI/ML研究 | 核心方案 |
| 医学/流行病学研究 | 核心方案 + medsci-skills |
| Nature/Science投稿 | 核心方案替换为nature-skills |
| 系统综述/meta分析 | 核心方案 + yy/claude-scholar |
| 快速测试 | 精简版（3个skill） |

---

## 下一步建议

Phase 5: 集成与验证
- 实际安装核心方案
- 验证工作流连通性
- 测试组合效果

详见 [04-SUMMARY.md](04-SUMMARY.md)

---

*Generated: 2026-05-12*
*Source: Phase 2 evaluation + Phase 3 analysis + Phase 4 optimization*
