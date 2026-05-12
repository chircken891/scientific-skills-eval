# Phase 7: 持续优化 - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-12
**Phase:** 7-持续优化
**Areas discussed:** Scientific-Do改进(借鉴ECC), 配置优化, Phase 6遗留问题, 发现Skill机制, 反馈收集, 更新机制, 扩展Skill激活, 核心vs扩展优先级, 新发现Skill分级入库

---

## Scientific-Do改进（借鉴ECC）

### 集成架构

| Option | Description | Selected |
|--------|-------------|----------|
| 模式借鉴 | Scientific-Do借鉴ECC路由模式，不改ECC代码 | |
| 前置处理器 | ECC作为Scientific-Do前置处理器 | ✓ |
| 独立模块 | 抽取ECC域识别为独立模块 | |

**User's choice:** 前置处理器

### 域识别粒度

| Option | Description | Selected |
|--------|-------------|----------|
| 二分类（科研/非科研） | 粗粒度判断后全量交给Scientific-Do | ✓ |
| 科研子域分类 | 文献/分析/写作/图表/投稿子域标签 | |

**User's choice:** 二分类

### ECC模式借鉴

| Option | Description | Selected |
|--------|-------------|----------|
| 主动意图检测 | 从上下文推断科研意图，替代关键词匹配 | ✓ |
| 后置验证闭环 | 每个科研阶段完成后增加轻量验证节点 | ✓ |
| 结构化Skill注册 | 每个skill加触发条件字段 | ✓ |

**User's decision:** 三个都做，顺序：结构化注册 → 意图检测 → 验证闭环。保持中央协调器架构。

---

## 配置优化

### 模型路由

| Option | Description | Selected |
|--------|-------------|----------|
| Skill声明模型偏好 | SKILL.md中声明，调用时自动切换 | ✓ |
| 全局路径路由 | settings.json按路径匹配 | |

**User's choice:** Skill声明模型偏好

### Hook优化

| Option | Description | Selected |
|--------|-------------|----------|
| 跳过 | 毫秒级优化，无实质收益 | ✓ |

**User's decision:** 不做Hook优化

---

## Phase 6遗留问题

### P6-E01 性能基准测试

| Option | Description | Selected |
|--------|-------------|----------|
| 做 | 测试响应速度、token消耗、编排延迟 | ✓ |
| 不做 | 等实际遇到性能问题再处理 | |

**User's choice:** 做

### P6-E02 自动化测试框架

| Option | Description | Selected |
|--------|-------------|----------|
| 做 | CI式自动化冒烟测试 | |
| 不做 | 对话式skill不适合脚本化，ROI低 | ✓ |

**User's decision:** 不做

---

## 发现Skill机制

### 触发方式

| Option | Description | Selected |
|--------|-------------|----------|
| 用户报告触发 | 用户提出需求时检查gap | |
| 自动检测触发 | Scientific-Do执行任务时自动检测缺口 | ✓ |

**User's choice:** 自动检测触发

### 发现渠道

| Option | Description | Selected |
|--------|-------------|----------|
| GitHub自动搜索 | 自动搜索+Phase 2框架筛选 | ✓ |
| 记录清单人工搜索 | 记录gap，人工决定搜索 | |

**User's choice:** GitHub自动搜索

### 筛选标准

| Option | Description | Selected |
|--------|-------------|----------|
| 沿用Phase 2标准 | 安全否决 + DepthScore阈值 | ✓ |
| 轻量筛选试用后定 | 安全通过+功能相关即纳入 | |

**User's choice:** 沿用Phase 2标准

### 新发现Skill分级入库

| Option | Description | Selected |
|--------|-------------|----------|
| >4.0核心 | 直接激活 | ✓ |
| 3-4扩展 | 预下载不激活 | ✓ |
| <3.0不入 | 不入库 | ✓ |

### 替换逻辑

- 新角色 → 新增为第N个核心角色
- 同角色更强 → 替换旧核心，旧的降级为扩展
- 同角色差不多 → 加入扩展池，协调器按场景选择

---

## 反馈收集 + 更新机制

### 反馈形式

| Option | Description | Selected |
|--------|-------------|----------|
| 静默自动记录 | 自动记录成功/失败+耗时 | ✓（主模式） |
| 每10次评分 | 1-5分+选填评价 | ✓（辅模式） |

### 更新检查

| Option | Description | Selected |
|--------|-------------|----------|
| 与反馈绑定 | 每10次一并检查更新 | ✓ |

### 更新方式

| Option | Description | Selected |
|--------|-------------|----------|
| 通知+人工确认 | 通知changelog摘要，用户决定 | ✓ |
| 自动更新+失败回滚 | 自动更新，失败自动回滚 | |

**User's choice:** 通知+人工确认，更新后全量冒烟测试

---

## 扩展Skill

### 激活方式

| Option | Description | Selected |
|--------|-------------|----------|
| 按需自动激活 | Scientific-Do检测到需要时激活 | ✓ |
| 全部激活 | 都激活让协调器选 | |
| 暂不激活 | 保持Phase 5预下载状态 | |

**User's choice:** 按需自动激活

---

## 核心 vs 扩展优先级

| Option | Description | Selected |
|--------|-------------|----------|
| 核心优先 | 核心skill默认优先 | |
| 按场景匹配 | 根据实际场景选最合适的 | ✓ |

**User's choice:** 按场景匹配

---

## Deferred Ideas

无

---
*Discussion completed: 2026-05-12*
