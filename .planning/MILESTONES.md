# Milestones

## v1.1 GSD-scientific集成协议 (Shipped: 2026-05-13)

**Phases completed:** 3 phases, 5 plans, 11 tasks

**Key accomplishments:**

1. GSD 项目上下文感知 — gsd-context-detect.sh 自动检测 .planning/ 并解析项目状态，输出结构化 JSON 供 scientific-do 路由使用
2. 调用日志系统 — append-invocation-log.sh 原子写入管道 (mkdir 锁, 200条目截断+归档, %10/%20 触发器)，每次执行记录 9 字段 D-01 entry
3. GSD 合规输出 — SD-SUMMARY.md / SD-SUPPLEMENT.md 自动写入 phase 目录，支持 GSD 项目内外的优雅降级
4. everything-claude-code 域识别路由 — scientific-do 新增 detectDomain() 关键词白名单，非科学请求自动引导到 everything-claude-code

---

## v1.0 科研Skill评测与集成 (Shipped: 2026-05-12)

**Phases completed:** 10 phases, 26 plans
**Requirements:** 6/6 validated

**Key accomplishments:**

1. 建立两阶段评估体系（Tier 1 安全否决 + Tier 2 专业深度评分），评测39个科研skill仓库
2. 生成1+N最优组合方案 — 7核心学术skill + 3扩展skill + scientific-do 中央协调器
3. scientific-do 5-step 协调器：意图解析 → 结构化路由 → 依赖编排 → 后置验证 → 反馈闭环
4. 结构化Skill注册 — 每个 skill 声明触发关键词、典型场景、排除场景、模型偏好
5. 持续优化基础设施：07-VERIFY.sh 验证脚本（17/17 D-xx 决策覆盖）、更新检测、缺口发现、性能基准
6. Phase 7 建立的技能发现管线（缺口检测 → GitHub搜索 → 分级入库 → 替换逻辑）为后续 phase 提供了可扩展机制