# 05-FUNCTIONAL-TEST: 功能测试指南

**Generated:** 2026-05-12
**Phase:** 5-集成与验证
**Status:** 待用户执行

---

## 功能测试说明

对每个已安装的skill执行核心功能测试，验证其可用性和功能正确性。

---

## 测试1: deepxiv_sdk — 文献检索

### Skill信息
| 属性 | 值 |
|------|-----|
| 角色 | 文献检索 |
| GitHub | DeepXiv/deepxiv_sdk |
| 核心能力 | Agent-first文献阅读，渐进式内容访问 |

### 测试指令
```
使用 /deepxiv 或 claude skill invoke deepxiv_sdk 测试以下功能：

1. 搜索功能：检索 "machine learning medical imaging" 相关论文
2. 渐进式阅读：使用 --brief/--head/--section 模式访问论文
3. 多数据库：验证 arXiv/bioRxiv/medRxiv/PMC 覆盖
```

### 预期结果
- 返回相关论文列表
- 支持渐进式内容访问
- 多数据库搜索有效

### 验证点
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| 搜索功能 | 返回>0个结果 | ☐ |
| 渐进式阅读 | 支持三种模式 | ☐ |
| 多数据库 | 覆盖≥2个数据库 | ☐ |

### 测试记录
| 测试项 | 预期 | 实际 | 通过 |
|--------|------|------|------|
| 搜索功能 | 返回论文列表 | | ☐ |
| 渐进式阅读 | 支持三种模式 | | ☐ |
| 多数据库 | ≥2个数据库 | | ☐ |

---

## 测试2: scientific-agent-skills — 数据分析

### Skill信息
| 属性 | 值 |
|------|-----|
| 角色 | 数据分析 |
| GitHub | K-Dense-AI/scientific-agent-skills |
| 核心能力 | 135个skill覆盖20+领域，100+数据库查询 |

### 测试指令
```
使用 /scientific-agent 或 claude skill invoke scientific-agent-skills 测试以下功能：

1. 统计分析：执行基本描述性统计
2. 数据可视化：生成简单图表
3. 领域覆盖：验证多领域分析能力
```

### 预期结果
- 生成统计分析结果
- 图表正确渲染
- 多个领域可用

### 验证点
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| 统计分析 | 输出统计结果 | ☐ |
| 数据可视化 | 生成图表 | ☐ |
| 领域覆盖 | ≥3个领域 | ☐ |

### 测试记录
| 测试项 | 预期 | 实际 | 通过 |
|--------|------|------|------|
| 统计分析 | 输出结果 | | ☐ |
| 数据可视化 | 生成图表 | | ☐ |
| 领域覆盖 | ≥3个领域 | | ☐ |

---

## 测试3: academic-writing-skills — 论文写作

### Skill信息
| 属性 | 值 |
|------|-----|
| 角色 | 论文写作 |
| GitHub | bahayonghang/academic-writing-skills |
| 核心能力 | LaTeX/Typst/Word多格式，多轮修订 |

### 测试指令
```
使用 /academic-writing 或 claude skill invoke academic-writing-skills 测试以下功能：

1. 格式生成：生成 LaTeX 论文模板
2. 多格式支持：验证 LaTeX/Typst/Word
3. 审阅系统：使用 paper-audit 功能
```

### 预期结果
- 生成有效的LaTeX模板
- 支持多种格式
- 审阅系统有效

### 验证点
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| 格式生成 | 生成LaTeX文件 | ☐ |
| 多格式 | ≥2种格式 | ☐ |
| 审阅系统 | 输出审阅结果 | ☐ |

### 测试记录
| 测试项 | 预期 | 实际 | 通过 |
|--------|------|------|------|
| 格式生成 | 生成LaTeX | | ☐ |
| 多格式 | ≥2种格式 | | ☐ |
| 审阅系统 | 输出审阅 | | ☐ |

---

## 测试4: paper-plot-skills — 图表生成

### Skill信息
| 属性 | 值 |
|------|-----|
| 角色 | 图表生成 |
| GitHub | Boom5426/paper-plot-skills |
| 核心能力 | 9种真实论文图表样式，plot-from-image |

### 测试指令
```
使用 /paper-plot 或 claude skill invoke paper-plot-skills 测试以下功能：

1. 图表生成：生成指定类型图表
2. 样式覆盖：验证9种样式
3. plot-from-image：从图片复现风格
```

### 预期结果
- 生成图表代码/图像
- 多种样式可选
- 图片风格复现有效

### 验证点
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| 图表生成 | 生成图表 | ☐ |
| 样式覆盖 | ≥5种样式 | ☐ |
| plot-from-image | 复现风格 | ☐ |

### 测试记录
| 测试项 | 预期 | 实际 | 通过 |
|--------|------|------|------|
| 图表生成 | 生成图表 | | ☐ |
| 样式覆盖 | ≥5种样式 | | ☐ |
| plot-from-image | 复现风格 | | ☐ |

---

## 测试5: Paper-Polish-Workflow-skill — 投稿润色

### Skill信息
| 属性 | 值 |
|------|-----|
| 角色 | 投稿润色 |
| GitHub | Lylll9436/Paper-Polish-Workflow-skill |
| 核心能力 | 16个润色skill，去AI化流程 |

### 测试指令
```
使用 /paper-polish 或 claude skill invoke Paper-Polish-Workflow-skill 测试以下功能：

1. 润色功能：润色给定段落
2. 去AI化：验证AI痕迹去除
3. 审稿人模拟：运行审稿流程
```

### 预期结果
- 润色效果明显
- AI痕迹有效去除
- 审稿流程运行

### 验证点
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| 润色功能 | 改善文本 | ☐ |
| 去AI化 | 降低AI分数 | ☐ |
| 审稿人模拟 | 输出审稿意见 | ☐ |

### 测试记录
| 测试项 | 预期 | 实际 | 通过 |
|--------|------|------|------|
| 润色功能 | 改善文本 | | ☐ |
| 去AI化 | 降低AI分数 | | ☐ |
| 审稿人模拟 | 输出意见 | | ☐ |

---

## 测试6: medsci-skills — 医学专项

### Skill信息
| 属性 | 值 |
|------|-----|
| 角色 | 医学专项 |
| GitHub | MedgeClaw/medsci-skills |
| 核心能力 | PRISMA/STROBE合规，流行病学/生物统计学 |

### 测试指令
```
使用 /medsci 或 claude skill invoke medsci-skills 测试以下功能：

1. 医学统计：执行meta分析
2. PRISMA合规：验证PRISMA流程
3. STROBE合规：验证STROBE清单
```

### 预期结果
- 生成meta分析结果
- PRISMA流程有效
- STROBE清单可用

### 验证点
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| 医学统计 | 输出分析 | ☐ |
| PRISMA合规 | 生成清单 | ☐ |
| STROBE合规 | 生成清单 | ☐ |

### 测试记录
| 测试项 | 预期 | 实际 | 通过 |
|--------|------|------|------|
| 医学统计 | 输出分析 | | ☐ |
| PRISMA合规 | 生成清单 | | ☐ |
| STROBE合规 | 生成清单 | | ☐ |

---

## 测试7: everything-claude-code — Claude增强

### Skill信息
| 属性 | 值 |
|------|-----|
| 角色 | 工具Skill |
| GitHub | affaan-m/everything-claude-code |
| 核心能力 | 181个Skills，47子代理，/fork并行 |

### 测试指令
```
使用 /everything 或 claude skill invoke everything-claude-code 测试以下功能：

1. Agent增强：使用并行工作流
2. /fork命令：测试并行执行
3. 规则系统：验证Hooks
```

### 预期结果
- 并行工作流有效
- /fork命令执行
- Hooks生效

### 验证点
| 验证点 | 通过标准 | 结果 |
|--------|----------|------|
| Agent增强 | 功能启用 | ☐ |
| /fork命令 | 并行执行 | ☐ |
| Hooks | 规则生效 | ☐ |

### 测试记录
| 测试项 | 预期 | 实际 | 通过 |
|--------|------|------|------|
| Agent增强 | 功能启用 | | ☐ |
| /fork命令 | 并行执行 | | ☐ |
| Hooks | 规则生效 | | ☐ |

---

## 功能测试汇总

| Skill | 状态 | 通过率 | 问题 |
|-------|------|--------|------|
| deepxiv_sdk | ☐ 待测试 | 0/3 | |
| scientific-agent-skills | ☐ 待测试 | 0/3 | |
| academic-writing-skills | ☐ 待测试 | 0/3 | |
| paper-plot-skills | ☐ 待测试 | 0/3 | |
| Paper-Polish-Workflow-skill | ☐ 待测试 | 0/3 | |
| medsci-skills | ☐ 待测试 | 0/3 | |
| everything-claude-code | ☐ 待测试 | 0/3 | |

---

## 更新日志

| 日期 | 操作 | 更新人 |
|------|------|--------|
| 2026-05-12 | 初始创建 | Claude |
