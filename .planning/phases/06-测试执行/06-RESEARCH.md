# Phase 6: 测试执行 - Research

**Research Date:** 2026-05-12
**Purpose:** Document knowledge needed to plan Phase 6 test execution

---

## 1. 测试执行方式

### 手动测试环境

测试必须在**新建Claude Code session**中执行，确保环境干净。

```
执行流程:
1. 退出当前session
2. 启动新Claude Code session
3. 开始测试
```

### 测试调用方式

通过Skill工具调用各技能：
- `/skill <skill-name>` — 启动skill
- 自然语言触发 — Claude Code自动路由

### 实际验证命令

```bash
# 冒烟测试调用示例
/skill deepxiv_sdk
输入: "搜索machine learning in healthcare文献"

/skill academic-paper-analysis
输入: "分析这篇论文的方法学"
```

---

## 2. 测试结果记录系统

### 测试执行日志模板

```
=== Phase 6 测试执行日志 ===
执行时间: YYYY-MM-DD HH:MM
测试环境: 新建Claude Code session

--- Skill冒烟测试 ---
[Skill名称]: PASS/FAIL
  测试输入: [实际输入]
  预期结果: [验证标准]
  实际结果: [观察到的结果]
  问题记录: [如有]

--- Scientific-Do协调测试 ---
[场景]: PASS/FAIL
  输入: [测试提示词]
  预期路由: [应调用的skill]
  实际路由: [观察到的行为]
  决策逻辑: [协调器如何处理]

--- 端到端工作流测试 ---
[场景]: PASS/FAIL
  完整流程: [各阶段skill调用记录]
  数据传递: [验证结果]
  HARD-GATE: [触发情况]
```

### 问题追踪表

| 问题ID | 描述 | 严重度 | 处理方式 | 状态 |
|--------|------|--------|----------|------|
| P6-01 | [描述] | critical/edge | fix/log | open/resolved |

---

## 3. 测试场景设计

### Tier 1: 7个核心Skill冒烟测试

每个skill测试3个维度：

| Skill | 测试内容 | 验证点 |
|-------|----------|--------|
| deepxiv_sdk | 文献检索 | 返回结果、DOI/URL、搜索质量 |
| academic-paper-analysis | 论文分析 | 分析框架、8维度覆盖、结论质量 |
| scientific-agent-skills | 数据分析 | 统计方法、建模能力、结果解释 |
| academic-writing-skills | 论文写作 | 学术规范、语言风格、结构完整性 |
| paper-plot-skills | 图表生成 | 图表类型、发表质量、代码可执行 |
| Paper-Polish-Workflow-skill | 投稿润色 | 润色建议、合规检查、期刊适配 |
| medsci-skills | 医学专项 | 医学术语、临床方法、专项分析 |

### Tier 2: Scientific-Do协调器测试

3个预设测试场景：

#### 场景1: 简单任务路由
```
输入: "搜索机器学习文献"
预期: deepxiv_sdk直接响应
验证: intent-parser正确识别stage=literature, taskType=[文献检索]
```

#### 场景2: 多Skill协调
```
输入: "分析数据并写论文"
预期: scientific-agent-skills + academic-writing-skills
验证: skill-router识别任务链，执行顺序正确
```

#### 场景3: 冲突处理
```
输入: "生成图表并润色"
预期: paper-plot-skills → Paper-Polish-Workflow-skill
验证: 依赖链编排正确，无冲突
```

### Tier 3: 端到端工作流测试

4个完整科研场景（来自05-WORKFLOW-TEST.md）：

| 场景 | 测试目标 | 关键验证点 |
|------|----------|-----------|
| 场景1: COVID-19 meta分析 | 完整流程覆盖 | scientific-do协调启动、各skill顺序执行、数据传递 |
| 场景2: 医学影像ML | 领域专用 | scientific-do识别任务类型、正确路由到scientific-agent-skills |
| 场景3: 临床试验分析 | 多skill协作 | 多skill协调、数据分析+写作skill执行 |
| 场景4: 流病调查 | 医学专项 | medsci-skills调用、统计分析、结果可视化 |

---

## 4. 失败处理机制

### 分级处理策略（D-02）

| 严重度 | 定义 | 处理方式 |
|--------|------|----------|
| Critical | 核心功能不可用、skill无法启动 | 立即尝试修复，修复失败则测试失败 |
| Edge | 边缘情况、极端输入处理不当 | 记录到问题清单，暂不修复 |

### 修复尝试流程

```
Critical失败 → 尝试修复配置 → 重新测试 → 成功则PASS，失败则记录
Edge失败 → 记录到P6-XX问题清单 → 继续下一测试
```

### 修复决策权限

- Skill配置问题 → 可尝试修复
- Skill逻辑问题 → 记录，Phase 7处理
- 环境问题 → 记录，排查环境

---

## 5. Scientific-Do协调器测试细节

### 意图解析验证

验证`intent-parser.ts`功能：

```
输入: "分析临床试验数据"
解析结果:
  stage: analysis ✓
  taskType: ["数据分析"] ✓
  domainKeywords: ["clinical"] ✓
  confidence: >0.5 ✓
```

### 路由逻辑验证

验证`skill-router.ts`三层路由：

1. **精确匹配**: 完整stage匹配 → 直接返回对应skill
2. **模糊fallback**: 关键词部分匹配 → 返回多个候选skill
3. **智能调优**: 无法匹配 → 默认deepxiv_sdk

### 依赖链编排验证

验证buildDependencyChain函数：

```typescript
// 输入: ['数据分析', '论文写作']
// 预期输出: ['deepxiv_sdk', 'scientific-agent-skills', 'academic-writing-skills']
```

### HARD-GATE验证

验证HARD-GATE节点触发：

| 阶段 | HARD-GATE条件 | 预期行为 |
|------|---------------|----------|
| 规划前 | 无文献研究记录 | 提示先研究 |
| 写作前 | 无研究设计文档 | 提示先设计 |
| 执行前 | 用户未确认 | 暂停等待确认 |

---

## 6. 测试结果文档格式

### 测试报告结构

```markdown
# Phase 6 测试执行报告

## 执行摘要
- 测试时间: YYYY-MM-DD
- 测试环境: 新建Claude Code session
- 通过率: X/Y (Z%)

## 测试结果汇总

### 6.1 Skill冒烟测试
| Skill | 状态 | 备注 |
|-------|------|------|
| deepxiv_sdk | PASS | |
| ... | FAIL | 问题P6-XX |

### 6.2 Scientific-Do协调测试
| 场景 | 预期路由 | 实际行为 | 状态 |
|------|----------|---------|------|
| 搜索ML文献 | deepxiv_sdk | ✓ | PASS |
| ... | | | |

### 6.3 端到端工作流测试
| 场景 | 结果 | 关键发现 |
|------|------|----------|
| COVID-19 meta分析 | PASS | 数据传递正常 |
| ... | | |

## 问题清单

### Critical问题
| ID | 问题 | 影响 | 修复方案 |
|----|------|------|----------|
| P6-01 | [描述] | [影响] | [方案] |

### Edge问题
| ID | 问题 | 优先级 | 备注 |
|----|------|--------|------|
| P6-02 | [描述] | low | 暂不修复 |

## 验收结论
- 100%通过: ✅ 是/❌ 否
- 可进入Phase 7: ✅/❌

---
*Report Generated: YYYY-MM-DD*
```

---

## 7. 测试执行工作流

### Step-by-Step流程

```
Phase 6 执行流程:

Step 1: 环境准备
  ├─ 确认7个核心Skill已安装 (~/.claude/scientific-skills/skills/)
  ├─ 确认scientific-do协调器存在
  └─ 确认测试文档可用 (05-TEST-GUIDE.md, 05-WORKFLOW-TEST.md)

Step 2: 新建测试session
  ├─ 退出当前session (如有)
  └─ 启动全新Claude Code session

Step 3: Tier 1 - Skill冒烟测试 (顺序执行)
  ├─ deepxiv_sdk: 3项验证
  ├─ academic-paper-analysis: 3项验证
  ├─ scientific-agent-skills: 3项验证
  ├─ academic-writing-skills: 3项验证
  ├─ paper-plot-skills: 3项验证
  ├─ Paper-Polish-Workflow-skill: 3项验证
  └─ medsci-skills: 3项验证

Step 4: Tier 2 - Scientific-Do协调测试
  ├─ 场景1: 简单任务路由
  ├─ 场景2: 多Skill协调
  └─ 场景3: 冲突处理

Step 5: Tier 3 - 端到端工作流测试
  ├─ 场景1: 完整科研流程 (COVID-19 meta分析)
  ├─ 场景2: ML医学影像
  ├─ 场景3: 临床试验分析
  └─ 场景4: 流行病学调查

Step 6: 边界情况测试 (可选)
  ├─ 空输入处理
  ├─ 过长输入处理
  └─ 特殊字符处理

Step 7: 汇总报告
  ├─ 统计通过率
  ├─ 问题清单整理
  └─ 验收结论
```

### 测试时间估算

| 阶段 | 预计时间 | 说明 |
|------|----------|------|
| Tier 1: 7个Skill冒烟 | ~30分钟 | 每个skill约4-5分钟 |
| Tier 2: Scientific-Do协调 | ~15分钟 | 3个场景 |
| Tier 3: 4个端到端场景 | ~30-40分钟 | 复杂场景需要更多时间 |
| 边界测试 | ~10分钟 | 可选 |
| **总计** | **~85-95分钟** | 预留缓冲 |

---

## 8. 通过标准与验收

### 通过标准

**100%通过**（Per D-08 from Phase 5）

- 所有21个冒烟测试项必须PASS
- 所有3个Scientific-Do协调场景PASS
- 所有4个端到端工作流PASS
- Critical问题必须已修复或已知

### 验收条件

1. **功能验收**: 7个核心Skill全部可正常调用
2. **协调验收**: Scientific-Do正确路由和协调
3. **流程验收**: 端到端工作流正常执行
4. **问题验收**: 无未解决的Critical问题

### 进入Phase 7条件

满足以下任一条件：
- 测试通过率 = 100%
- Critical问题已修复（重新测试后PASS）
- Edge问题不影响核心功能（经评估）

---

## 附录: 关键参考文件

| 文件 | 路径 | 内容 |
|------|------|------|
| 05-TEST-GUIDE.md | .planning/phases/05-02-superpowers-structure/ | 7个Skill功能测试指南 |
| 05-WORKFLOW-TEST.md | .planning/phases/05-02-superpowers-structure/ | 端到端工作流测试 |
| 05-VERIFICATION.md | .planning/phases/05-02-superpowers-structure/ | Phase 5验证报告 |
| SKILL.md | ~/.claude/scientific-skills/skills/scientific-do/ | Scientific-Do协调器定义 |
| intent-parser.ts | ~/.claude/scientific-skills/skills/scientific-do/ | 意图解析模块 |
| skill-router.ts | ~/.claude/scientific-skills/skills/scientific-do/ | Skill路由模块 |
| 06-CONTEXT.md | .planning/phases/06-测试执行/ | Phase 6上下文和决策 |
| 06-DISCUSSION-LOG.md | .planning/phases/06-测试执行/ | Phase 6讨论记录 |

---

## 锁定决策回顾 (D-01 ~ D-06)

| Decision | 内容 | 来源 |
|----------|------|------|
| D-01 | 手动测试 — 在Claude Code session中逐个调用skill测试 | Phase 6讨论 |
| D-02 | 分级处理 — 关键功能立即修复，边缘情况记录到问题清单 | Phase 6讨论 |
| D-03 | Scientific-Do测试 — 预设场景 + 自由测试 | Phase 6讨论 |
| D-04 | 测试环境 — 新建Claude Code session执行测试 | Phase 6讨论 |
| D-05 | 测试优先级 — 7冒烟 → Scientific-Do → E2E → 边界 | Phase 6讨论 |
| D-06 | 通过标准 — 100%通过 | Phase 5继承 |

---
*Research completed: 2026-05-12*
*Next: Write 06-PLAN.md*