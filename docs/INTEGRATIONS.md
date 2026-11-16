# 软件与插件使用说明

> **这是智能体「问仓库要」的那份文档。** 遇到任何工具、CLI、插件、集成的用法问题，先查这里；查不到就先核实官方资料、把结论补进来，再继续干活（见 `AGENTS.md` 第一条规则）。
> 状态列说明本机 2026-11-17 的实际情况；「待配」表示软件可用但缺凭据或配置。

## 一览表

| 工具 / 插件 | 用途 | 状态 |
| --- | --- | --- |
| **WorkBuddy 资料库 / 文献库** | **内部知识检索、文档沉淀、跨设备共享** | ⭐ **日常最常用**，见下节 |
| GitHub CLI (`gh`) | 命令行建仓、查 Issue/PR、发版 | ✅ 已装 2.104.0，已登录 `eqqygq` |
| GitHub MCP Server | 让智能体直接读写 GitHub | ❌ 未配置，需 PAT |
| WorkBuddy GitHub 连接器 | 在 WorkBuddy 里用自然语言管仓库 | ❌ 未连接 |
| Ollama（本地大模型） | 离线推理兜底 | ✅ 0.40.16 + `qwen3:4b`，11434 服务可用，推理已验证 |
| 云端 LLM API | 在线推理 | ❌ 未选型 / 无 Key |
| VS Code + MCP | 远程 MCP 宿主 | ✅ 已装（需 1.101+ 支持远程 MCP + OAuth） |
| Git LFS | 大文件版本管理 | ⚠️ 未确认 |
| Dependabot / CodeQL / Secret scanning | 依赖与代码安全 | ⚠️ 推送后在仓库设置开启 |
| gitleaks | 本地密钥扫描 | ⚠️ 未安装 |
| actions/starter-workflows | 官方 CI 起步模板 | 📚 参考仓库 |

---

## WorkBuddy 资料库 / 文献库（最常用）

> 用户明确：**文献库是日常最常用的工具**。智能体找内部资料、找历史方案、找定稿文档，优先走这里，不要只盯着代码仓库。

- 定位：资料库 / 知识库 / 网盘 / 空间，是团队级知识源；仓库里的 `docs/` 是「工具用法源」，两者分工不同。
- 可检索的数据源：WorkBuddy 资料库、IMA 知识库、腾讯文档、腾讯网盘、腾讯会议。
- 本机状态（2026-11-17 实测）：`workbuddy_library` 可用；`ima` / `tencent_docs` / `tencent_drive` / `tencent_meeting` 上次检索返回 `exchange_failed`，需要用户在连接器里授权后才能检索。**结果不完整时必须如实说明检索范围，不要用推测补内容。**
- 常用操作：
  - 找资料：一次性广度检索 `knowledge_search`，按返回的 `unavailable` 列表判断哪些源没查到，再对已连接的源走各自 skill/MCP 补查。
  - 存资料：`LibraryUpload` 把本地定稿文件加入资料库，便于跨设备、跨会话检索与引用。
  - 整理 / 归档 / 分享 / 导出 / 发布：走 `library` skill，写操作一律通过它，不要自己拼文件路径。
  - 找历史对话：用 `conversation_search`（只搜历史会话，看不到当前对话，查询要自包含）。

**与仓库的约定**

1. 涉及内部知识、历史方案、定稿文档 → **先查资料库**。
2. 查不到或是工具用法问题 → 查本文件；仍查不到就核实官方资料后补进本文件，再继续干活。
3. 定稿文档（如《GitHub 仓库建设全套方案》、[COSTS.md](COSTS.md)）**同步一份进资料库**，让不进代码仓库的人也能检索到；仓库里保留的是给智能体读的实时版本。
4. 资料库连接失败时如实说明「哪些源没查到」，不要假装已全库检索。

## GitHub CLI (`gh`)

- 官方：https://cli.github.com/ ｜ 文档：https://cli.github.com/manual/
- 本机安装：`winget install --id GitHub.cli --source winget`（已执行）。可执行文件：
  `C:\Program Files\GitHub CLI\gh.exe`，**未加入当前会话 PATH**，脚本里请用绝对路径或 `/c/Program Files/GitHub CLI/gh.exe`。

```bash
GH="/c/Program Files/GitHub CLI/gh.exe"
"$GH" auth login --web --scopes "repo,read:org"   # 设备码登录
"$GH" auth status                                  # 看登录状态
"$GH" issue list --state open --json number,title,labels,updatedAt
"$GH" issue list --repo owner/repo --state open --json number,title --jq '.[] | "\(.number): \(.title)"'
"$GH" repo create owner/repo --private --clone --add-readme
"$GH" api repos/owner/repo/rulesets --jq '.[] | "\(.id) \(.name) \(.enforcement)"'
"$GH" release create v1.0.0 --title "v1.0.0" --notes-file CHANGELOG.md
```

> 不在 git 目录里时，命令一律带 `--repo owner/repo`；`gh api` 必须先登录，匿名下载请用 curl 直连 `api.github.com`。

## GitHub MCP Server（智能体通道）

- 官方仓库：https://github.com/github/github-mcp-server （≈34.5k stars）
- 远程端点：`https://api.githubcopilot.com/mcp/`；支持 OAuth 或 `Authorization: Bearer <PAT>`。
- 配置原文与 WorkBuddy 落地步骤见 [AGENT-SETUP.md](AGENT-SETUP.md)，样例见 [`config/mcp.example.json`](../config/mcp.example.json)。
- 能力：读仓库与代码、管 Issue/PR、看 Actions 与失败日志、查 Dependabot / 代码扫描告警。
- 注意：GitHub Enterprise Server 不支持远程托管，需改用本地 Docker 版。

## WorkBuddy GitHub 连接器

- 属于 WorkBuddy 的「连接器」，从对话左下角「+」里启用，属于**用户手动授权**的操作。
- 已连接后可直接用自然语言查仓库、Issue、PR，不必再走 `gh` 或 MCP。
- 全局 MCP 配置位置：`C:\Users\<用户名>\.workbuddy\mcp.json`（注意**不是** `.mcp.json`）。新增自定义 MCP 后需在连接器管理页右上角点「信任」才会生效。
- 凭据若认证失败，走「重新授权」，不要反复重试用同一个失效 token。

## 本地大模型（Ollama）

- 官方：https://ollama.com/
- 安装后：`ollama serve` 启动服务；`ollama pull qwen3` 拉模型；`ollama list` 查看。
- 健康检查：`curl http://127.0.0.1:11434/api/tags`（本机 2026-11-17 起已返回模型列表）。
- 本机现状：`ollama.exe` 位于 `C:\Users\YTR\AppData\Local\Programs\Ollama\ollama.exe`，安装后服务自动启动；已拉 `qwen3:4b`（2.5 GB），`POST /api/chat` 验证返回 `done_reason: stop`。零订阅、零 API 账单。
- 模型存储：`D:\Ollama\models`（`OLLAMA_MODELS` 用户环境变量，2026-11-17 从 C 盘迁出，迁移后推理复验通过）。
- 调用：OpenAI 兼容端点 `http://127.0.0.1:11434/v1`，模型名用 `ollama list` 里的实际名称。
- 与 MCP 的关系：LLM 是「脑」，MCP 是「手」。没有云端模型时用本地 LLM 驱动智能体，工具侧通过 `gh` CLI 完成 GitHub 操作。

## 云端 LLM API

- 在 `.env` 里配 `LLM_BASE_URL` / `LLM_API_KEY` / `LLM_MODEL`，代码从环境变量读取。
- `.env` 已被 `.gitignore` 排除；仓库里只保留 `.env.example` 占位。
- 选型未定，选定后把厂商、模型名、限流与计费注意点补到本节。

## VS Code

- 远程 MCP + OAuth 需要 **1.101 或更高版本**。
- 配置写在 `servers` 下（不是 `mcpServers`），见 `AGENT-SETUP.md` 的官方原文。
- 装好后在 Copilot Chat 输入切到 Agent 模式，server 会随会话启动。

## Git LFS

- 官方：https://git-lfs.com/
- `git lfs install` → `git lfs track "*.psd"` → 提交 `.gitattributes`。
- 大于 100 MB 的文件 GitHub 会拒收；二进制资产、数据集走 LFS，不要塞进普通提交。

## 安全类内置功能（推送后在仓库设置里开）

| 功能 | 入口 | 作用 |
| --- | --- | --- |
| Secret scanning + Push protection | Settings → Code security and analysis | 密钥进历史前拦截 |
| Dependabot alerts / security updates | 同上 + `.github/dependabot.yml` | 漏洞依赖自动开 PR |
| Code scanning (CodeQL) | 同上 或 工作流 | 静态分析 |
| Dependency Review | PR 必需工作流 | 拦截新增高危依赖 / 不允许的许可证 |
| Private Vulnerability Reporting | Settings → Security | 与 `SECURITY.md` 呼应 |

官方一键基线：https://docs.github.com/en/code-security/getting-started/quickstart-for-securing-your-repository

## gitleaks（本地密钥扫描，可选）

- 官方：https://github.com/gitleaks/gitleaks
- `gitleaks detect --source . --log-opts "--all"` 扫历史；`gitleaks protect --staged` 作为 pre-commit 钩子。
- 与 GitHub 的 Push protection 互补：本地先挡一道，CI 再挡一道。

## 模板与规范来源

| 来源 | 链接 |
| --- | --- |
| `.gitignore` 模板 | https://github.com/github/gitignore |
| CI 起步工作流 | https://github.com/actions/starter-workflows |
| README 结构 | https://github.com/othneildrew/Best-README-Template |
| 行为准则 | https://www.contributor-covenant.org/version/2/1/code_of_conduct/ |
| Changelog 格式 | https://keepachangelog.com/zh-CN/1.1.0/ |
| 许可证选择 | https://choosealicense.com/ |

---

## 维护约定

新增任何工具 / 插件时，**同一次 PR 里必须补上这一节**：用途、安装或配置入口、最小可用命令、官方链接、本机状态。这样智能体换会话、换模型后依然能「问仓库要」到正确用法。
