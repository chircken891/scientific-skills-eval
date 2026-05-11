# Phase 1.5: VS Code Marketplace 搜索（补充）

**Generated:** 2026-05-11
**Platform:** GitHub API + OpenVSX

---

## Search Approach

### Attempted Methods

1. **WebSearch** - Not available in this environment
2. **WebFetch** - Not available in this environment
3. **OpenVSX API** - Endpoint `/search` returned 404, namespace not found
4. **GitHub API** - Successfully used as alternative to find VS Code research extensions

### GitHub API Search Strategy

Since VS Code Marketplace and OpenVSX lack public APIs, used GitHub API to search for repositories with `vscode-extension` + research topics.

---

## Search Results

### Research-Focused VS Code Extensions Found

| # | 仓库 | Stars | Topics | 描述 | 最后更新 |
|---|------|-------|--------|------|----------|
| 1 | andre-inter-collab-llc/research-workflow-assistant | 16 | academic-writing, mcp-server, pubmed, systematic-review, zotero | Open-source AI research assistant for VS Code + GitHub Copilot. Connects to PubMed, OpenAlex, Semantic Scholar, Europe PMC, CrossRef, Zotero via MCP | 2026-05-05 |
| 2 | pallaprolus/dev-scholar | 4 | academic, arxiv, citations, doi, mendeley, zotero | Research workflow accelerator for academic citations in code | 2026-01-06 |

### General Claude Code VS Code Extensions (for reference)

| # | 仓库 | Stars | Topics |
|---|------|-------|--------|
| 1 | Alishahryar1/free-claude-code | 23,582 | - |
| 2 | kodu-ai/claude-coder | 5,279 | claude, vscode-extension |
| 3 | jasonjmcghee/claude-debugs-for-you | 509 | anthropic, claude, mcp, vscode-extension |
| 4 | VikashLoomba/copilot-mcp | 490 | agent-skills, claude-skills, mcp, vscode-extension |

---

## Quality Assessment

| 类别 | 数量 | 说明 |
|------|------|------|
| 科研相关高质量 (stars > 10) | 1 | research-workflow-assistant (16 stars, full MCP integration) |
| 科研相关低质量 (stars < 10) | 1 | dev-scholar (4 stars, niche use case) |
| 通用 Claude 扩展 | 4 | 非科研导向，但包含在 Claude skills 生态 |

---

## New Discoveries

**Phase 1.5 新增 VS Code 扩展：**

| # | 仓库 | Stars | 来源平台 |
|---|------|-------|----------|
| 22 | andre-inter-collab-llc/research-workflow-assistant | 16 | GitHub API |
| 23 | pallaprolus/dev-scholar | 4 | GitHub API |

---

## Conclusion

使用 GitHub API 作为替代方案成功发现了 2 个科研相关 VS Code 扩展：
1. **research-workflow-assistant** — 功能完整（PubMed, OpenAlex, Zotero MCP），星数低但功能强
2. **dev-scholar** — 文献引用加速器，星数极低但垂直

注：OpenVSX 的 `/search` 接口返回 404，其 API 结构与文档不符。

**D-01 Exception 处理：** 通过 GitHub API 替代方案完成搜索，已更新本报告。
