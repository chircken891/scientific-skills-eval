# 05-INSTALL-LOG: 安装验证记录

**Generated:** 2026-05-12
**Phase:** 5-集成与验证
**Status:** 待用户更新

---

## 安装说明

**安装方式：** 全局安装（`--global`），所有项目共享

---

## 待安装Skill清单

### 学术Skill（6个）

| 角色 | Skill | GitHub | 全局安装命令 |
|------|-------|--------|---------------|
| 文献检索 | deepxiv_sdk | DeepXiv/deepxiv_sdk | `claude skill install --global https://github.com/DeepXiv/deepxiv_sdk` |
| 数据分析 | scientific-agent-skills | K-Dense-AI/scientific-agent-skills | `claude skill install --global https://github.com/K-Dense-AI/scientific-agent-skills` |
| 论文写作 | academic-writing-skills | bahayonghang/academic-writing-skills | `claude skill install --global https://github.com/bahayonghang/academic-writing-skills` |
| 图表生成 | paper-plot-skills | Boom5426/paper-plot-skills | `claude skill install --global https://github.com/Boom5426/paper-plot-skills` |
| 投稿润色 | Paper-Polish-Workflow-skill | Lylll9436/Paper-Polish-Workflow-skill | `claude skill install --global https://github.com/Lylll9436/Paper-Polish-Workflow-skill` |
| 医学专项 | medsci-skills | MedgeClaw/medsci-skills | `claude skill install --global https://github.com/MedgeClaw/medsci-skills` |

### 工具Skill（1个）

| Skill | GitHub | 全局安装命令 |
|-------|--------|---------------|
| everything-claude-code | affaan-m/everything-claude-code | `claude skill install --global https://github.com/affaan-m/everything-claude-code` |

---

## 安装验证记录表

**请在安装过程中更新此表：**

| Skill | 安装状态 | 安装时间 | 验证结果 | 备注 |
|-------|----------|----------|----------|------|
| deepxiv_sdk | ☐ 待安装 | - | ☐ 未验证 | |
| scientific-agent-skills | ☐ 待安装 | - | ☐ 未验证 | |
| academic-writing-skills | ☐ 待安装 | - | ☐ 未验证 | |
| paper-plot-skills | ☐ 待安装 | - | ☐ 未验证 | |
| Paper-Polish-Workflow-skill | ☐ 待安装 | - | ☐ 未验证 | |
| medsci-skills | ☐ 待安装 | - | ☐ 未验证 | |
| everything-claude-code | ☐ 待安装 | - | ☐ 未验证 | |

---

## 安装顺序建议

1. **deepxiv_sdk** — 文献检索（基础工具）
2. **scientific-agent-skills** — 数据分析（核心工具）
3. **academic-writing-skills** — 论文写作
4. **paper-plot-skills** — 图表生成
5. **Paper-Polish-Workflow-skill** — 投稿润色
6. **medsci-skills** — 医学专项
7. **everything-claude-code** — 工具增强（单独安装）

---

## 安装后验证

```bash
# 查看已安装的skill
claude skill list

# 验证特定skill可用
claude skill invoke <skill-name> --help
```

---

## 更新日志

| 日期 | 操作 | 更新人 |
|------|------|--------|
| 2026-05-12 | 初始创建（全局安装） | Claude |
