---
wave: 1
depends_on: []
files_modified:
  - .planning/SKILLS-INVENTORY.md
autonomous: false
requirements:
  - R-01.5-01
  - R-01.5-02
  - R-01.5-03
---

# Phase 1.5: 自主搜索仓库补充 — 执行计划

## 目标

对 Phase 1 已有 21 个仓库进行跨平台补充搜索，发现更多科研相关 skill/plugin 仓库，更新 SKILLS-INVENTORY.md。

## 已有发现（来自 01.5-RESEARCH.md）

### GitHub 待验证仓库
| 仓库 | 描述 | 来源依据 |
|------|------|----------|
| brycewang-stanford/Awesome-Agent-Skills-for-Empirical-Research | 23000+ skills for 8 social science disciplines | GitHub search |
| beita6969/ScienceClaw | 285 skills, self-evolving, zero hallucination | GitHub search |
| xjtulyc/MedgeClaw | 140 K-Dense scientific skills for biomedicine | GitHub search |
| Aperivue/medsci-skills | Medical research with PRISMA, STROBE, meta-analysis | GitHub search |
| affaan-m/everything-claude-code | Agent harness optimization with skills/instincts | GitHub search |

### npm 待验证包
| 包名 | 描述 | 来源依据 |
|------|------|----------|
| grd-cli | Biomedical research lifecycle management | npm search |
| scientify | OpenClaw research workflow | npm search |
| shuozhao-academic-skills | PPT generation, literature search, Zotero | npm search |
| researchmcp | MCP for arXiv, Semantic Scholar, PubMed | npm search |
| @gonzih/research-rabbit | Student research MCP | npm search |
| openalex-research-mcp | OpenAlex literature review | npm search |
| ai4scholar | OpenClaw plugin for multi-source academic literature | npm search |

---

## 任务列表

### 任务 1: GitHub 跨平台仓库搜索

<read_first>
- `.planning/phases/01.5-自主搜索仓库补充/01.5-RESEARCH.md` — 搜索策略和已知待验证仓库
- `.planning/SKILLS-INVENTORY.md` — 现有 21 个仓库（去重基准）
</read_first>

<acceptance_criteria>
- `curl -s "https://api.github.com/search/repositories?q=claude+skill+research&per_page=20&sort=stars"` 返回有效 JSON
- GitHub API 响应包含 `items[]` 数组
- 已识别仓库（Awesome-Agent-Skills-for-Empirical-Research, ScienceClaw, MedgeClaw, medsci-skills, everything-claude-code）出现在搜索结果或已单独验证
- 验证 pushed_at 在近 6 个月内（维护状态检查）
</acceptance_criteria>

<verify>
```bash
# 验证 GitHub API 返回有效 JSON 且包含 items
curl -s "https://api.github.com/search/repositories?q=claude+skill+research&per_page=5" \
  -H "User-Agent: research-skill-evaluator" | \
  jq 'if .items then "VALID: items array exists" else "INVALID: no items" end'

# 验证已知仓库可访问
curl -s "https://api.github.com/repos/brycewang-stanford/Awesome-Agent-Skills-for-Empirical-Research" \
  -H "User-Agent: research-skill-evaluator" | \
  jq '{name: .full_name, status: "reachable"}'
```
</verify>

<done>
GitHub 搜索执行完成，已生成 JSON 输出文件，包含至少 5 个新发现仓库的元数据（name, stars, topics, pushed_at），去重后输出到搜索结果文件。
</done>

<action>
执行 GitHub API 搜索，使用 `-H "User-Agent: research-skill-evaluator"` 头：

```bash
# 搜索 compound queries（分批执行）
curl -s "https://api.github.com/search/repositories?q=claude+skill+research&per_page=30&sort=stars&order=desc" \
  -H "User-Agent: research-skill-evaluator" \
  -H "Accept: application/vnd.github.v3+json" | \
  jq '{total: .total_count, items: [.items[] | {name: .full_name, stars: .stargazers_count, topics: .topics, url: .html_url, updated: .pushed_at}]}'

curl -s "https://api.github.com/search/repositories?q=paper+writing+claude+skill&per_page=20&sort=stars" \
  -H "User-Agent: research-skill-evaluator" | \
  jq '{total: .total_count, items: [.items[] | {name: .full_name, stars: .stargazers_count, topics: .topics}]}'

curl -s "https://api.github.com/search/repositories?q=medical+research+claude+skill&per_page=20&sort=stars" \
  -H "User-Agent: research-skill-evaluator" | \
  jq '{total: .total_count, items: [.items[] | {name: .full_name, stars: .stargazers_count, topics: .topics}]}'

curl -s "https://api.github.com/search/repositories?q=empirical+research+skills&per_page=20&sort=stars" \
  -H "User-Agent: research-skill-evaluator" | \
  jq '{total: .total_count, items: [.items[] | {name: .full_name, stars: .stargazers_count, topics: .topics}]}'
```

单独验证已知待发现仓库（验证 star 数、topics、更新时间）：
```bash
curl -s "https://api.github.com/repos/brycewang-stanford/Awesome-Agent-Skills-for-Empirical-Research" \
  -H "User-Agent: research-skill-evaluator" | \
  jq '{name: .full_name, stars: .stargazers_count, topics: .topics, updated: .pushed_at, license: .license.spdx_id}'

curl -s "https://api.github.com/repos/beita6969/ScienceClaw" \
  -H "User-Agent: research-skill-evaluator" | \
  jq '{name: .full_name, stars: .stargazers_count, topics: .topics, updated: .pushed_at}'

curl -s "https://api.github.com/repos/xjtulyc/MedgeClaw" \
  -H "User-Agent: research-skill-evaluator" | \
  jq '{name: .full_name, stars: .stargazers_count, topics: .topics, updated: .pushed_at}'

curl -s "https://api.github.com/repos/Aperivue/medsci-skills" \
  -H "User-Agent: research-skill-evaluator" | \
  jq '{name: .full_name, stars: .stargazers_count, topics: .topics, updated: .pushed_at}'

curl -s "https://api.github.com/repos/affaan-m/everything-claude-code" \
  -H "User-Agent: research-skill-evaluator" | \
  jq '{name: .full_name, stars: .stargazers_count, topics: .topics, updated: .pushed_at}'
```
</action>

<verify>
```bash
# 验证 GitHub API 返回有效 JSON 且包含 items
curl -s "https://api.github.com/search/repositories?q=claude+skill+research&per_page=5" \
  -H "User-Agent: research-skill-evaluator" | \
  jq 'if .items then "VALID: items array exists" else "INVALID: no items" end'

# 验证已知仓库可访问
curl -s "https://api.github.com/repos/brycewang-stanford/Awesome-Agent-Skills-for-Empirical-Research" \
  -H "User-Agent: research-skill-evaluator" | \
  jq '{name: .full_name, status: "reachable"}'
```
</verify>

<done>
GitHub 搜索执行完成，已生成 JSON 输出文件，包含至少 5 个新发现仓库的元数据（name, stars, topics, pushed_at），去重后输出到搜索结果文件。
</done>

### 任务 2: npm Registry 搜索

<read_first>
- `.planning/phases/01.5-自主搜索仓库补充/01.5-RESEARCH.md` — npm 搜索策略
- `D:/cc/项目/科研skill/.planning/SKILLS-INVENTORY.md` — 已有仓库清单
</read_first>

<acceptance_criteria>
- `npm search "research claude"` 返回结果列表
- `npm search "academic research"` 返回结果列表
- 已知 npm 包（grd-cli, scientify, shuozhao-academic-skills, researchmcp）出现在搜索结果中
- 每个包验证：`npm view <pkg> homepage` 确认 GitHub 链接有效性
</acceptance_criteria>

<action>
```bash
# npm 学术研究搜索
npm search "research claude" 2>/dev/null | head -40
npm search "academic research" 2>/dev/null | head -30
npm search "mcp server research" 2>/dev/null | head -20
npm search "openclaw research" 2>/dev/null | head -20

# 验证已知 npm 包
for pkg in grd-cli scientify shuozhao-academic-skills researchmcp @gonzih/research-rabbit openalex-research-mcp ai4scholar scholarlab; do
  echo "=== $pkg ==="
  npm view "$pkg" homepage description 2>/dev/null || echo "NOT FOUND"
done
```
</action>

<verify>
```bash
# 验证 npm 搜索返回结果
npm search "research claude" 2>/dev/null | grep -c "package" || echo "0"
npm search "academic research" 2>/dev/null | grep -c "package" || echo "0"

# 验证已知包可访问
npm view grd-cli homepage 2>/dev/null | grep -q "github.com" && echo "VALID: grd-cli has GitHub link" || echo "INVALID"
npm view researchmcp homepage 2>/dev/null | grep -q "github.com" && echo "VALID: researchmcp has GitHub link" || echo "INVALID"
```
</verify>

<done>
npm 搜索执行完成，已生成包含至少 4 个新发现 npm 包的列表（grd-cli, scientify, shuozhao-academic-skills, researchmcp），每个包验证了 homepage GitHub 链接有效性。
</done>

### 任务 3: MCP Server 专项搜索

<read_first>
- `.planning/phases/01.5-自主搜索仓库补充/01.5-RESEARCH.md` — MCP 搜索策略（第 123-124 行）
- `D:/cc/项目/科研skill/.planning/SKILLS-INVENTORY.md` — 已有仓库清单
</read_first>

<acceptance_criteria>
- `npm search "model-context-protocol"` 返回 MCP 相关包
- researchmcp 包存在且有有效的 homepage/GitHub 链接
- 至少 3 个新的 MCP 研究工具被识别
</acceptance_criteria>

<action>
```bash
# MCP 协议专项搜索
npm search "model-context-protocol" 2>/dev/null | head -30
npm search "MCP server academic" 2>/dev/null | head -20

# 验证 MCP 包详情
for pkg in researchmcp @gonzih/research-rabbit openalex-research-mcp prima-scholar-search-mcp; do
  echo "=== $pkg ==="
  npm view "$pkg" 2>/dev/null | jq -r '{name, description, homepage, repository}' || echo "NOT FOUND"
done
```
</action>

<verify>
```bash
# 验证 MCP 包存在且有 GitHub 链接
npm view researchmcp homepage 2>/dev/null | grep -q "github.com" && echo "VALID: researchmcp" || echo "INVALID"
npm view @gonzih/research-rabbit homepage 2>/dev/null | grep -q "github.com" && echo "VALID: research-rabbit" || echo "INVALID"
npm view openalex-research-mcp homepage 2>/dev/null | grep -q "github.com" && echo "VALID: openalex" || echo "INVALID"

# 统计新发现 MCP 工具数量
echo "MCP tools found: $(npm search 'model-context-protocol' 2>/dev/null | grep -c 'model-context-protocol' || echo 0)"
```
</verify>

<done>
MCP 专项搜索完成，已识别至少 3 个新的 MCP 研究工具（researchmcp, @gonzih/research-rabbit, openalex-research-mcp），每个包验证了 homepage GitHub 链接有效性。
</done>

### 任务 4: VS Code Marketplace 手动搜索

<read_first>
- `.planning/phases/01.5-自主搜索仓库补充/01.5-RESEARCH.md` — VS Code marketplace 限制说明（第 109-114 行）
</read_first>

<acceptance_criteria>
- 通过 WebFetch 访问 VS Code marketplace 搜索页面，验证页面可访问
- 通过 WebSearch 搜索 "VS Code extension claude research skill" 获取扩展列表
- 识别至少 3 个与科研相关的 VS Code 扩展（如存在）
</acceptance_criteria>

<action>
VS Code Marketplace 无公共 API，采用手动搜索策略：

```bash
# 方法 1: WebSearch 搜索 VS Code 扩展
# 搜索 claude research 相关扩展
web_search "site:marketplace.visualstudio.com claude research extension"
web_search "VS Code extension scientific research claude ai"

# 方法 2: WebFetch 直接访问 marketplace 搜索页
web_fetch "https://marketplace.visualstudio.com/search?term=claude+research&target=VSCode" \
  --prompt "List all VS Code extensions related to claude, research, academic, or scientific. Include extension name, publisher, and description."

web_fetch "https://marketplace.visualstudio.com/search?term=academic+writing&target=VSCode" \
  --prompt "List all VS Code extensions related to academic writing, paper writing, or literature. Include extension name, publisher, and description."

# 方法 3: OpenVSX（开源替代，可程序化访问）
web_fetch "https://open-vsx.org/search?search=claude+research" \
  --prompt "List all extensions related to research, academic, or scientific work. Include name, namespace, and description."
```

**注意：** VS Code marketplace 无公开 API，以上为 workaround 方法。若未发现有效扩展，需在去重报告中注明"VS Code marketplace 手动搜索完成，未发现新的有效科研 skill 扩展"。

**VS Code marketplace 已知限制（来自 01.5-RESEARCH.md）：**
- 无公共 API，无法程序化枚举
- 手动搜索作为 D-01 异常处理
- OpenVSX 提供部分程序化访问
</action>

<verify>
```bash
# 验证 WebFetch 页面可访问
web_fetch "https://open-vsx.org/search?search=claude+research" \
  --prompt "Count extensions found related to research/academic"

# 验证 WebSearch 执行
web_search "site:marketplace.visualstudio.com claude research extension" 2>/dev/null | grep -c "visualstudio.com" || echo "0"
```
</verify>

<done>
VS Code marketplace 手动搜索完成，已通过 WebSearch + WebFetch 方式搜索，未发现新的有效科研 skill 扩展（或已识别 X 个有效扩展）。
</done>

### 任务 5: 去重与质量评估

<read_first>
- `D:/cc/项目/科研skill/.planning/SKILLS-INVENTORY.md` — 已有 21 个仓库（去重基准）
- `.planning/phases/01.5-自主搜索仓库补充/01.5-RESEARCH.md` — D-04/D-05 去重策略（第 19-26 行）
</read_first>

<acceptance_criteria>
- 输出去重报告，列出：
  - 新发现仓库中与已有 21 个不重复的仓库
  - 重复的仓库（需说明来源）
  - 质量评估（star 数、topics、维护状态）
- 同一作者同名仓库只保留 1 个（star 最高者）
</acceptance_criteria>

<action>
比对新发现仓库与 SKILLS-INVENTORY.md 已有 21 个仓库：

已知的 21 个仓库（需去重比对）：
1. Imbad0202/academic-research-skills
2. Yuan1z0825/nature-skills
3. Boom5426/Nature-Paper-Skills
4. yy/claude-scholar
5. ZhangNy301/citation-assistant
6. stephenlzc/AI-Powered-Literature-Review-Skills
7. ComposioHQ/awesome-claude-skills
8. anthropics/skills
9. Lylll9436/Paper-Polish-Workflow-skill
10. wanshuiyin/Auto-claude-code-research-in-sleep (ARIS)
11. DeepXiv/deepxiv_sdk
12. K-Dense-AI/scientific-agent-skills
13. K-Dense-AI/claude-scientific-writer
14. bahayonghang/academic-writing-skills
15. bengous/claude-code-plugins
16. SpillwaveSolutions/design-doc-mermaid
17. Trae1ounG/paper-plot-skills
18. luwill/research-skills
19. nicholash84/Claude-Scientific-Skills
20. Orchestra-Research/AI-Research-SKILLs
21. kthorn/research-superpower

新发现待去重仓库（如不在上述列表则新增）：
- brycewang-stanford/Awesome-Agent-Skills-for-Empirical-Research (需验证)
- beita6969/ScienceClaw (需验证)
- xjtulyc/MedgeClaw (需验证)
- Aperivue/medsci-skills (需验证)
- affaan-m/everything-claude-code (需验证)
- npm 包（grd-cli, scientify 等）→ 需映射到实际 GitHub 仓库

输出格式：
```
## 去重报告

### 新增仓库（不重复）
| 仓库 | Stars | Topics | 来源平台 |
|------|-------|--------|----------|
| ... | ... | ... | GitHub/npm/VS Code |

### 重复仓库
| 仓库 | 已有来源 | 说明 |
|------|----------|------|
| ... | ... | ... |

### VS Code Marketplace 搜索结果
- 搜索方法：WebSearch + WebFetch (OpenVSX)
- 发现扩展数：X 个
- 有效科研相关扩展：X 个（如无则注明"未发现"）

### 质量评估摘要
- 高质量新增（star > 1000）: X 个
- 中等质量新增（star 100-1000）: X 个
- 低质量新增（star < 100）: X 个
```
</action>

<verify>
```bash
# 验证去重报告存在且包含新增仓库列表
grep -q "新增仓库" deduplication_report.md && echo "VALID: 去重报告已生成" || echo "INVALID"

# 验证新发现仓库不在已有 21 个中
grep -c "brycewang-stanford/Awesome-Agent-Skills-for-Empirical-Research" existing_inventory.md || echo "NOT_DUPLICATE"

# 验证质量评估存在
grep -q "质量评估" deduplication_report.md && echo "VALID: 质量评估完成" || echo "INVALID"
```
</verify>

<done>
去重报告已生成，包含 X 个新增仓库（已与现有 21 个去重），质量评估完成（高/中/低质量分布已记录）。
</done>

### 任务 6: 更新 SKILLS-INVENTORY.md

<read_first>
- `D:/cc/项目/科研skill/.planning/SKILLS-INVENTORY.md` — 现有清单格式
- `D:/cc/项目/科研skill/.planning/phases/01.5-自主搜索仓库补充/01.5-RESEARCH.md` — 新发现仓库信息
</read_first>

<acceptance_criteria>
- SKILLS-INVENTORY.md 包含新增仓库的完整条目
- 每个新增条目包含：仓库名、URL、描述、Stars、Topics、更新时间
- 新增仓库与已有 21 个仓库无重复
- 文件末尾更新日期为执行日期
</acceptance_criteria>

<action>
在 SKILLS-INVENTORY.md 末尾添加新增仓库节：

```markdown
---

## Phase 1.5 新增仓库（跨平台搜索补充）

### GitHub 新增

| # | 仓库 | 描述 | Stars | Topics | 发现方式 |
|---|------|------|-------|--------|----------|
| 22 | owner/repo | 描述 | N | topic1, topic2 | GitHub API search |

### npm 包新增（已映射 GitHub 仓库）

| # | npm 包 | GitHub 仓库 | 描述 | 发现方式 |
|---|--------|-------------|------|----------|
| ... | ... | ... | ... | npm search |

### 搜索统计更新

| 指标 | Phase 1 | Phase 1.5 | 合计 |
|------|---------|-----------|------|
| 仓库总数 | 21 | X | X |
| 新增来源 | - | GitHub API + npm | - |

*最后更新: 2026-05-11*
```

如无新增有效仓库，则在 SKILLS-INVENTORY.md 末尾注明：
```markdown
---

## Phase 1.5 搜索结果

**搜索平台：** GitHub API, npm registry
**搜索日期：** 2026-05-11
**结果：** 未发现新的有效科研 skill 仓库（已与现有 21 个仓库去重）
**说明：** Phase 1 搜索已饱和
```
</action>

<verify>
```bash
# 验证 SKILLS-INVENTORY.md 存在且包含 Phase 1.5 内容
grep -q "Phase 1.5" .planning/SKILLS-INVENTORY.md && echo "VALID: Phase 1.5 content exists" || echo "INVALID"

# 验证新增条目格式正确（包含必要字段）
grep -E "^\|.*\|.*\|.*\|.*\|.*\|" .planning/SKILLS-INVENTORY.md | wc -l

# 验证更新日期存在
grep -q "最后更新" .planning/SKILLS-INVENTORY.md && echo "VALID: update date exists" || echo "INVALID"
```
</verify>

<done>
SKILLS-INVENTORY.md 已更新，包含 X 个新增仓库（或注明无新增），包含完整字段（仓库名、URL、描述、Stars、Topics、更新时间），文件末尾更新日期为 2026-05-11。
</done>

---

---

## 验证标准

| 任务 | 验证条件 | 检查方式 |
|------|----------|----------|
| GitHub 搜索 | API 返回有效 JSON | `jq '.items'` 非空 |
| npm 搜索 | 返回包列表 | `npm search` 输出非空 |
| VS Code marketplace | WebFetch/WebSearch 返回结果或注明无结果 | 手动验证结果相关性 |
| 去重报告 | 无与已有 21 个重复 | 比对 owner/name |
| SKILLS-INVENTORY.md | 包含新增条目或注明无新增 | 文件内容检查 |

## must_haves（目标逆向验证）

- [x] 跨平台搜索执行（GitHub + npm + VS Code marketplace）
- [x] 去重报告生成
- [x] SKILLS-INVENTORY.md 更新
- [x] 验证新发现仓库有效性（stars > 50 或有明确科研应用场景）
- [x] VS Code marketplace 手动搜索（含 D-01 异常处理说明）
