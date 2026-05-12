# 05-WORKFLOW-TEST: 工作流测试指南

**Generated:** 2026-05-12
**Phase:** 5-集成与验证
**Status:** 待用户执行

---

## 工作流测试说明

测试从文献检索到论文投稿的完整端到端科研工作流。

---

## 完整科研工作流

```
文献检索 → 数据分析 → 论文写作 → 图表制作 → 投稿润色 → 投稿提交
    ↓           ↓           ↓           ↓           ↓
deepxiv    scientific    academic    paper-plot   Paper-
sdk       -agent        -writing    -skills     Polish
                         -skills
```

---

## 工作流测试：机器学习医学影像论文

### 场景描述
测试完整的医学影像AI论文工作流。

### 测试步骤

#### 步骤1: 文献检索
**Skill:** deepxiv_sdk

**测试：**
```
使用 /deepxiv 或直接调用 deepxiv_sdk 检索：

"machine learning medical imaging" 相关论文
- 目标：获取10-20篇相关论文
- 格式：渐进式阅读（--brief 模式）
```

**预期输出：**
- 返回相关论文列表
- 支持渐进式阅读
- 包含论文摘要

**验证点：**
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| 检索功能 | 返回>5篇论文 | ☐ |
| 渐进式阅读 | 支持--brief模式 | ☐ |
| 输出格式 | 包含摘要 | ☐ |

---

#### 步骤2: 数据分析
**Skill:** scientific-agent-skills

**测试：**
```
使用 /scientific-agent 或直接调用 scientific-agent-skills：

对检索到的论文进行：
1. 元分析（meta-analysis）
2. 统计分析
3. 数据可视化
```

**预期输出：**
- 生成分析结果
- 统计图表
- 可视化结果

**验证点：**
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| 分析功能 | 生成分析报告 | ☐ |
| 统计分析 | 输出统计数据 | ☐ |
| 可视化 | 生成图表 | ☐ |

---

#### 步骤3: 论文写作
**Skill:** academic-writing-skills

**测试：**
```
使用 /academic-writing 或直接调用 academic-writing-skills：

基于分析结果生成论文：
1. LaTeX格式
2. 多章节结构
3. 引用格式化
```

**预期输出：**
- 生成LaTeX论文模板
- 包含引文
- 结构完整

**验证点：**
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| 格式生成 | 生成LaTeX | ☐ |
| 结构完整 | 包含章节 | ☐ |
| 引用格式 | BibTeX格式 | ☐ |

---

#### 步骤4: 图表制作
**Skill:** paper-plot-skills

**测试：**
```
使用 /paper-plot 或直接调用 paper-plot-skills：

为论文生成图表：
1. 精度-召回曲线
2. 混淆矩阵
3. 训练曲线
```

**预期输出：**
- 生成图表代码
- 多种样式可选
- 支持矢量图

**验证点：**
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| 图表生成 | 生成图表 | ☐ |
| 样式多样 | ≥3种样式 | ☐ |
| 格式兼容 | LaTeX可用 | ☐ |

---

#### 步骤5: 投稿润色
**Skill:** Paper-Polish-Workflow-skill

**测试：**
```
使用 /paper-polish 或直接调用 Paper-Polish-Workflow-skill：

对论文草稿进行润色：
1. 语言润色
2. 去AI化处理
3. 审稿人模拟
```

**预期输出：**
- 润色后文本
- AI检测分数降低
- 审稿意见

**验证点：**
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| 润色效果 | 文本改善 | ☐ |
| 去AI化 | AI分数降低 | ☐ |
| 审稿模拟 | 输出意见 | ☐ |

---

#### 步骤6: 医学专项（如适用）
**Skill:** medsci-skills

**测试：**
```
使用 /medsci 或直接调用 medsci-skills：

补充医学研究合规：
1. PRISMA流程检查
2. STROBE清单
3. 生物统计验证
```

**预期输出：**
- PRISMA流程清单
- STROBE清单
- 合规报告

**验证点：**
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| PRISMA | 生成清单 | ☐ |
| STROBE | 生成清单 | ☐ |
| 统计分析 | 医学统计 | ☐ |

---

## 工作流连通性测试

### 数据传递验证

| 步骤 | 数据类型 | 格式 | 下一步接受 | 验证 |
|------|----------|------|-----------|------|
| deepxiv_sdk | 论文列表 | Markdown/JSON | scientific-agent-skills | ☐ |
| scientific-agent-skills | 分析结果 | CSV/Markdown | academic-writing-skills | ☐ |
| academic-writing-skills | 论文草稿 | LaTeX | paper-plot-skills | ☐ |
| paper-plot-skills | 图表 | PDF/SVG | Paper-Polish | ☐ |
| Paper-Polish | 润色稿 | LaTeX | medsci-skills | ☐ |

---

## 工作流测试汇总

| 步骤 | Skill | 状态 | 通过 | 问题 |
|------|-------|------|------|------|
| 1 | deepxiv_sdk | ☐ 待测试 | ☐ | |
| 2 | scientific-agent-skills | ☐ 待测试 | ☐ | |
| 3 | academic-writing-skills | ☐ 待测试 | ☐ | |
| 4 | paper-plot-skills | ☐ 待测试 | ☐ | |
| 5 | Paper-Polish-Workflow-skill | ☐ 待测试 | ☐ | |
| 6 | medsci-skills | ☐ 待测试 | ☐ | |

**工作流连通性：** ☐ 待测试

---

## 更新日志

| 日期 | 操作 | 更新人 |
|------|------|--------|
| 2026-05-12 | 初始创建 | Claude |
