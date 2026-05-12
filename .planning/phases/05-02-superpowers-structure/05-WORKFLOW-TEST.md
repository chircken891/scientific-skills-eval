# Phase 5 端到端工作流测试

**Created:** 2026-05-12
**Per D-09, D-10**

## 测试策略

### 端到端场景
- [x] 完整场景测试：端到端科研流程
- [x] 科研流程测试：特定场景验证

### 工作流编排测试重点（Per D-10）
- [x] scientific-do协调：验证协调器决策
- [x] 数据传递：验证skill间数据流
- [x] 冲突处理：验证冲突解决逻辑

---

## 场景1：完整科研流程

### 场景描述
用户请求完成一项完整的医学研究论文

### 测试流程
```
1. 文献调研 → deepxiv_sdk
2. 研究设计 → scientific-agent-skills
3. 数据分析 → scientific-agent-skills + medsci-skills
4. 论文写作 → academic-writing-skills
5. 图表制作 → paper-plot-skills
6. 投稿润色 → Paper-Polish-Workflow-skill
```

### 测试提示词
```
我需要完成一项关于"COVID-19疫苗有效性"的meta分析研究。
请帮我：
1. 检索相关文献
2. 设计分析方案
3. 执行统计分析
4. 撰写论文
5. 生成图表
6. 润色投稿
```

### 验证标准
- [ ] scientific-do协调启动
- [ ] 各skill按顺序执行
- [ ] HARD-GATE正确触发
- [ ] 数据在各skill间传递

---

## 场景2：机器学习医学影像分析

### 测试提示词
```
使用scientific-do协调医学影像分析项目
```

### 验证标准
- [ ] scientific-do识别任务类型
- [ ] 正确路由到scientific-agent-skills
- [ ] 数据传递验证

---

## 场景3：临床试验数据分析

### 测试提示词
```
分析临床试验数据并撰写报告
```

### 验证标准
- [ ] scientific-do协调多skill
- [ ] 数据分析skill执行
- [ ] 写作skill执行

---

## 场景4：流行病学调查研究

### 测试提示词
```
进行流行病学调查数据分析
```

### 验证标准
- [ ] medsci-skills被调用
- [ ] 统计分析正确执行
- [ ] 结果可视化

---

## 工作流编排测试

### 2.1 Scientific-Do协调测试

#### 测试用例

| ID | 场景 | 输入 | 预期决策 |
|----|------|------|---------|
| T-01 | 简单任务 | "帮我搜索文献" | 直接调用deepxiv_sdk |
| T-02 | 多Skill任务 | "分析数据并写论文" | scientific-do协调多skill |
| T-03 | 冲突场景 | "生成图表并润色" | 智能判断优先级 |

#### 测试脚本
```bash
# test_coordinator.sh

# T-01: 简单任务
claude skill invoke scientific-do --input "搜索machine learning文献" --log t01.log
grep "deepxiv_sdk" t01.log && echo "T-01 PASS" || echo "T-01 FAIL"

# T-02: 多Skill任务
claude skill invoke scientific-do --input "分析数据并写论文" --log t02.log
grep -E "scientific-agent-skills.*academic-writing-skills" t02.log && echo "T-02 PASS" || echo "T-02 FAIL"

# T-03: 冲突场景
claude skill invoke scientific-do --input "生成图表并润色" --log t03.log
grep -E "冲突处理" t03.log && echo "T-03 PASS" || echo "T-03 FAIL"
```

### 2.2 数据传递测试（Per D-10）

#### 数据流验证
```
deepxiv_sdk → scientific-agent-skills → academic-writing-skills → paper-plot-skills → Paper-Polish-Workflow-skill
```

#### 测试用例

| ID | 数据传递路径 | 验证方法 |
|----|-------------|---------|
| D-01 | deepxiv_sdk → scientific-agent-skills | 验证文献数据格式 |
| D-02 | scientific-agent-skills → academic-writing-skills | 验证分析结果格式 |
| D-03 | academic-writing-skills → paper-plot-skills | 验证图表数据格式 |
| D-04 | paper-plot-skills → Paper-Polish-Workflow-skill | 验证最终输出格式 |

### 2.3 冲突处理测试（Per D-15, D-18）

#### 测试场景

| 场景 | Skill A | Skill B | 预期处理 |
|------|---------|---------|---------|
| 图表竞争 | paper-plot-skills | nature-skills | 优先使用core skill |
| 润色竞争 | Paper-Polish | nature-skills | 用户偏好优先 |
| 分析竞争 | scientific-agent | scientify | scientific-agent优先 |

#### 测试脚本
```bash
# test_conflict.sh

# 测试图表竞争
claude skill invoke scientific-do --input "生成图表nature风格" --log conflict1.log
grep -c "paper-plot-skills" conflict1.log > 0 && echo "优先core skill: PASS" || echo "FAIL"
```

---

## 测试执行清单

### 前置条件
- [ ] Phase 05-01 完成（Skill安装）
- [ ] Phase 05-02 完成（集合包创建）
- [ ] Phase 05-03 完成（scientific-do协调器）

### 执行顺序
1. [ ] 场景1：完整科研流程测试
2. [ ] 场景2：机器学习医学影像分析测试
3. [ ] 场景3：临床试验数据分析测试
4. [ ] 场景4：流行病学调查研究测试
5. [ ] T-01: Scientific-Do简单任务协调
6. [ ] T-02: Scientific-Do多Skill协调
7. [ ] T-03: Scientific-Do冲突处理
8. [ ] D-01~D-04: 数据传递验证
9. [ ] 冲突处理场景测试

### 通过标准
**100%通过** — 所有场景和工作流编排测试通过

### 测试结果记录表

| 类别 | 测试项 | 结果 | 备注 |
|------|--------|------|------|
| 完整场景 | 场景1-4 | 待执行 | |
| Scientific-Do协调 | T-01~T-03 | 待执行 | |
| 数据传递 | D-01~D-04 | 待执行 | |
| 冲突处理 | 3个场景 | 待执行 | |

### 执行日志模板
```
=== Phase 5 端到端工作流测试 ===
执行时间: YYYY-MM-DD HH:MM
执行人: Claude

--- 场景1: 完整科研流程 ---
输入: [测试提示词]
执行Skill: [按顺序列出]
数据传递: [验证结果]
HARD-GATE触发: [列表]
结果: PASS/FAIL

--- Scientific-Do协调测试 ---
T-01: [结果]
T-02: [结果]
T-03: [结果]

--- 汇总 ---
通过: X/Y
失败: Y/N
总计: 100% / X%
```

---
*Generated: 2026-05-12*
