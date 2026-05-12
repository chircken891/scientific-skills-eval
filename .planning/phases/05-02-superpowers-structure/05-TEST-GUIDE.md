# Phase 5 功能测试指南

**Created:** 2026-05-12
**Per D-06, D-07, D-08**

## 测试策略

### 测试覆盖范围
- [x] 冒烟测试：核心功能可用
- [x] 边界情况：输入边界测试
- [x] 异常处理：错误情况处理

### 测试通过标准
**100%通过**（Per D-08）

### 测试用例格式
混合模式（Per D-07）：
- 手动测试文档：详细测试步骤
- 自动化验证脚本：可重复执行

---

## 1. deepxiv_sdk 冒烟测试

### 测试目标
验证文献检索功能可用

### 测试步骤
1. 启动Claude Code新session
2. 输入测试提示词
3. 验证返回结果

### 测试提示词
```
使用deepxiv_sdk搜索关于"machine learning in healthcare"的文献
```

### 预期结果
- [ ] 返回文献列表
- [ ] 包含DOI或URL
- [ ] 支持渐进式阅读

### 自动化验证
```bash
claude skill invoke deepxiv_sdk --input "machine learning healthcare" --verify
```

---

## 2. academic-paper-analysis 冒烟测试

### 测试目标
验证论文分析功能可用

### 测试步骤
1. 启动Claude Code新session
2. 输入测试提示词
3. 验证返回结果

### 测试提示词
```
使用academic-paper-analysis分析这篇论文的方法学
```

### 预期结果
- [ ] 返回分析结果
- [ ] 包含方法学评价
- [ ] 支持8维度分析

### 自动化验证
```bash
claude skill invoke academic-paper-analysis --input "analyze methodology"
```

---

## 3. scientific-agent-skills 冒烟测试

### 测试目标
验证数据分析功能可用

### 测试步骤
1. 启动Claude Code新session
2. 输入测试提示词
3. 验证返回结果

### 测试提示词
```
使用scientific-agent-skills进行统计分析
```

### 预期结果
- [ ] 返回分析结果
- [ ] 支持统计分析
- [ ] 支持建模

### 自动化验证
```bash
claude skill invoke scientific-agent-skills --input "statistical analysis"
```

---

## 4. academic-writing-skills 冒烟测试

### 测试目标
验证论文写作功能可用

### 测试步骤
1. 启动Claude Code新session
2. 输入测试提示词
3. 验证返回结果

### 测试提示词
```
使用academic-writing-skills撰写方法学部分
```

### 预期结果
- [ ] 返回写作内容
- [ ] 符合学术规范
- [ ] 支持风格校准

### 自动化验证
```bash
claude skill invoke academic-writing-skills --input "write methods section"
```

---

## 5. paper-plot-skills 冒烟测试

### 测试目标
验证图表生成功能可用

### 测试步骤
1. 启动Claude Code新session
2. 输入测试提示词
3. 验证返回结果

### 测试提示词
```
使用paper-plot-skills生成统计图表
```

### 预期结果
- [ ] 返回图表代码
- [ ] 支持多种图表类型
- [ ] 支持发表级质量

### 自动化验证
```bash
claude skill invoke paper-plot-skills --input "generate figure"
```

---

## 6. Paper-Polish-Workflow-skill 冒烟测试

### 测试目标
验证投稿润色功能可用

### 测试步骤
1. 启动Claude Code新session
2. 输入测试提示词
3. 验证返回结果

### 测试提示词
```
使用Paper-Polish-Workflow-skill润色论文
```

### 预期结果
- [ ] 返回润色建议
- [ ] 支持投稿合规检查
- [ ] 支持多期刊适配

### 自动化验证
```bash
claude skill invoke Paper-Polish-Workflow-skill --input "polish paper"
```

---

## 7. medsci-skills 冒烟测试

### 测试目标
验证医学专项功能可用

### 测试步骤
1. 启动Claude Code新session
2. 输入测试提示词
3. 验证返回结果

### 测试提示词
```
使用medsci-skills进行医学专项分析
```

### 预期结果
- [ ] 返回医学专项结果
- [ ] 支持医学术语
- [ ] 支持临床研究方法

### 自动化验证
```bash
claude skill invoke medsci-skills --input "medical analysis"
```

---

## 边界情况测试

### 2.1 空输入处理
| Skill | 测试输入 | 预期行为 |
|-------|---------|---------|
| deepxiv_sdk | 空字符串 | 提示需要搜索词 |
| academic-writing-skills | 空字符串 | 提示需要写作内容 |
| paper-plot-skills | 空数据 | 提示需要数据 |

### 2.2 过长输入处理
| Skill | 测试输入 | 预期行为 |
|-------|---------|---------|
| deepxiv_sdk | 500+字符搜索词 | 截断或提示过长 |
| academic-writing-skills | 10000+字符 | 分段处理 |
| paper-plot-skills | 100000+数据点 | 采样或拒绝 |

### 2.3 特殊字符处理
| Skill | 测试输入 | 预期行为 |
|-------|---------|---------|
| deepxiv_sdk | "CRISPR-Cas9" | 正确识别 |
| academic-writing-skills | LaTeX公式 | 正确渲染 |
| paper-plot-skills | Unicode字符 | 正确显示 |

### 2.4 边界数值
| Skill | 测试输入 | 预期行为 |
|-------|---------|---------|
| medsci-skills | p-value = 0.05 | 正确判断显著性 |
| scientific-agent-skills | 超大数据集 | 采样或超时处理 |

---

## 异常处理测试

### 3.1 网络异常
| 场景 | 测试方法 | 预期行为 |
|------|---------|---------|
| 网络断开 | 断网测试 | 提示网络不可用 |
| 超时 | 设置5秒超时 | 优雅降级 |
| API错误 | 模拟返回500 | 错误提示 |

### 3.2 数据异常
| 场景 | 测试方法 | 预期行为 |
|------|---------|---------|
| 数据格式错误 | 输入无效JSON | 格式错误提示 |
| 数据缺失 | 缺少必需字段 | 明确缺失提示 |
| 权限不足 | 无权限访问 | 权限错误提示 |

### 3.3 冲突处理测试（Per D-15）
| 场景 | 测试方法 | 预期行为 |
|------|---------|---------|
| 多Skill竞争 | 同时匹配多个Skill | scientific-do协调决策 |
| 依赖缺失 | 前置Skill不可用 | 提示并建议安装 |
| 版本冲突 | Skill版本不兼容 | 警告并建议升级 |

### 3.4 自动化验证脚本模板

```bash
#!/bin/bash
# test_skill_smoke.sh

SKILL_NAME=$1
TEST_INPUT=$2
EXPECTED=$3

RESULT=$(claude skill invoke $SKILL_NAME --input "$TEST_INPUT")

if echo "$RESULT" | grep -q "$EXPECTED"; then
  echo "PASS: $SKILL_NAME"
  exit 0
else
  echo "FAIL: $SKILL_NAME"
  echo "Expected: $EXPECTED"
  echo "Got: $RESULT"
  exit 1
fi
```

---

## 测试执行清单

### 执行顺序
1. [ ] deepxiv_sdk 冒烟测试
2. [ ] academic-paper-analysis 冒烟测试
3. [ ] scientific-agent-skills 冒烟测试
4. [ ] academic-writing-skills 冒烟测试
5. [ ] paper-plot-skills 冒烟测试
6. [ ] Paper-Polish-Workflow-skill 冒烟测试
7. [ ] medsci-skills 冒烟测试
8. [ ] 边界情况测试
9. [ ] 异常处理测试

### 通过标准
**100%通过** — 所有测试项必须通过（Per D-08）

### 测试结果记录
```
| Skill | 冒烟 | 边界 | 异常 | 总计 | 状态 |
|-------|------|------|------|------|------|
| deepxiv_sdk | X/X | X/X | X/X | X/X | PASS |
| ... | ... | ... | ... | ... | ... |
```

---
*Generated: 2026-05-12*
