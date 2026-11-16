# 工作布置与进度看板

> 这份文件回答「接下来谁做什么、做到什么算完」。智能体每次开工前先读它，做完立即更新状态，并同步提交。
> 创建：2026-11-17 ｜ 零成本约束见 [COSTS.md](COSTS.md)，任何订阅 / 套餐升级 / API 账单动作必须先经用户确认。

## 目标

把《GitHub 仓库建设全套方案》从文档变成可运行的东西：本地仓库已建 → 打通 GitHub → 连上智能体 → 本地大模型兜底 → 推送并开启免费范围内的治理 → 交付最初的「所有开放 Issue」清单。

## 任务拆解

| # | 任务 | 负责 | 状态 | 验收标准 | 依赖 |
| --- | --- | --- | --- | --- | --- |
| 1 | 补齐仓库标识与占位符 | 智能体 | ✅ 已完成 | 裸占位符全部有说明或已替换，待确认项集中列在本文件 | — |
| 2 | 重新打通 GitHub 授权 | 智能体启动 + **用户授权** | ✅ 已完成 | `gh auth status` 已登录 `eqqygq`，scopes: gist / read:org / repo | — |
| 3 | 配置 GitHub MCP Server 连好智能体 | 智能体 | ✅ 已完成（待用户点「信任」） | 已写入 `~/.workbuddy/mcp.json`（HTTP 端点 + Bearer token）；连接器页点「信任」后 MCP 工具生效 | #2 |
| 4 | 安装本地大模型兜底 | 智能体 | ✅ 已完成 | Ollama 服务可用、能完成一次本地 chat 推理、状态表更新 | — |
| 5 | 推送仓库并开启零成本治理设置 | 智能体 | ✅ 已完成 | 远端 `eqqygq/agent-repo-blueprint` 可见、CI 首次运行通过、未开启任何付费项 | #2 |
| 6 | 列出所有开放 Issue | 智能体 | ✅ 已完成 | 账号 0 仓库 → 0 个开放 Issue（已用 gh CLI 复核） | #2 |

状态图例：✅ 完成 ｜ 🔄 进行中 ｜ ⏸ 阻塞 ｜ ❌ 失败

## 已经开工的动作（不是计划，是正在跑）

- **#2**：新设备码登录已在后台启动，一次性码 **`0A77-6039`**，入口 `https://github.com/login/device`。旧码 `2030-9FDF` 已超时作废。该流程约 15 分钟内有效，期间 `gh` 会自动轮询，用户授权后即完成登录。
- **#4**：`winget install --id Ollama.Ollama` 正在后台执行；完成后启动 `ollama serve`、拉取小参数中文模型，并验证 `http://127.0.0.1:11434/api/tags` 与一次 `/api/chat` 调用。模型只选开源免费权重，不配任何云端 API Key。
- **#1 配套落地**：新增 `scripts/verify.sh`（必备文档 / YAML 语法 / 凭据粗筛 / 空白检查），本地已跑通 `体检通过 ✅`；CI 改为调用同一脚本。另补 `.env.example`、手动触发的 CodeQL 工作流、`docs/QUICKSTART.md`。

> **2026-11-17 07:04 更新**：设备码已连续四次超时作废（`2030-9FDF` → `0A77-6039` → `E682-23BB` → `FB30-652E`），不再自动重发。需要授权时对智能体说一声「给我新码」，或直接给一个 `repo` 权限的 PAT（https://github.com/settings/tokens），PAT 一次搞定、长期有效。授权打通后依次执行 #3 → #5 → #6。
>
> 另：Ollama 模型目录已应要求迁至 `D:\Ollama\models`（`OLLAMA_MODELS` 用户级变量，迁移后推理复验通过，提交 `c755cd4`）。

## 离线期间完成清单（2026-11-17 00:40 – 01:12）

- **#4 完成**：Ollama 0.40.16 安装成功（winget，安装包 1.8 GB）；服务自动启动，`/api/tags` 可访问；拉取开源模型 `qwen3:4b`（2.5 GB，约 19 分钟），`POST /api/chat` 返回 `done_reason: stop`，本地推理已验证。**零订阅、零 API 账单。**
- **工作布置落地**：本看板 + `docs/QUICKSTART.md`、`scripts/verify.sh`（本地跑通 `体检通过 ✅`）、CI 改为调用同一脚本、`.github/workflows/codeql.yml`（手动触发，避免 Free 私有仓库自动失败）、`.env.example`。
- **标识补齐**：README 首段说明、LICENSE 版权人（`eqqygq`，待确认）、README 文档地图补 QUICKSTART / WORK-PLAN。
- **知识源同步**：4 份定稿已进 WorkBuddy 资料库（文献库）——总方案、费用边界、插件与文献库用法、工作布置看板。
- **状态同步**：`AGENTS.md` / `docs/INTEGRATIONS.md` / `docs/AGENT-SETUP.md` 的环境状态表全部更新为本机实际状态。
- 仓库累计 5 次提交，`bash scripts/verify.sh` 通过，工作区干净。

## 收官（2026-11-17 07:35，6 项任务全部完成）

- **#2 完成**：用户本人注册账号 `eqqygq` 并完成设备码授权，`gh auth status` 显示已登录（keyring），scopes: gist / read:org / repo。全程 0 元。
- **#3 完成**：按 WorkBuddy 官方 MCP 格式写入 `~/.workbuddy/mcp.json`：`github` = HTTP 端点 `https://api.githubcopilot.com/mcp/` + `Authorization: Bearer <token>`；token 由 `gh auth token` 读取后直接写盘、未进对话/仓库。**用户需在连接器管理页点「信任」后 MCP 工具才加载。**
- **#5 完成**：仓库推送到 `eqqygq/agent-repo-blueprint`（public）；CI 首次运行 **success**；Secret scanning + Push protection 默认开启（免费）；CI / CodeQL / Dependabot 三条工作流 active。补齐 workflow scope 后推送成功。（推送时首次因缺 workflow scope 被拒，刷新授权 `55F5-AF49` 后解决——GitHub 发出的授权通知邮件属正常记录。）
- **#6 完成**：`gh api user/repos` 返回 `[]`（0 仓库）→ 账号名下 **0 个开放 Issue**，属实而非权限问题。
- **#3 补充**：刷新 token 后 mcp.json 已同步更新为新 token。

## 仍待用户手工确认

1. **MCP 信任**：到连接器管理页对 `github` 点「信任」（仅此一步需 UI 操作，之后智能体可直接用 MCP 工具）。
2. **标识**：`LICENSE` 版权人填的是 `eqqygq`（已与真实账号一致）；仓库名 `agent-repo-blueprint` 为智能体拟定，可随时改名。

## 占位符清单（#1 的可推断项已补，其余待确认）

| 位置 | 当前值 | 怎么处理 |
| --- | --- | --- |
| `README.md` 首段 | 已补为「仓库骨架 + 智能体知识源」说明 | ✅ 已替换 |
| `LICENSE` Copyright | 已填 `eqqygq`（来自本机 git 配置） | 若与真实版权人不一致请告知 |
| `.github/CODEOWNERS` | `@eqqygq` | ✅ 已替换为真实账号（个人仓库 owner 兜底） |
| `SECURITY.md` / Issue 模板链接 | `eqqygq/agent-repo-blueprint` | ✅ 已替换 |
| `config/mcp.example.json` | `${input:github_mcp_pat}` | 保持占位符，**永不入库真实 token** |
| `docs/INTEGRATIONS.md` 状态列 | 2026-11-17 快照 | 每次环境变化后更新 |

## 硬约束

- 费用：全程零订阅、零 API 账单；付费功能（私有仓库 rulesets / GHAS / Copilot 付费档 / 云端 LLM）一律不擅自开启。
- 凭据：PAT / token 只进本地配置，不进 git，不写进任何会被提交的文件。
- 知识源：内部资料 / 历史方案 / 定稿 → 先查 WorkBuddy 资料库（文献库）；工具用法 → 查 `docs/INTEGRATIONS.md`；查不到先核实补文档再干活。
- 外部动作：推送仓库、改远端设置、安装大体积软件前在任务里记录，做完更新状态。

## 更新规则

每完成一项：改本表状态 → 更新 `AGENTS.md` / `INTEGRATIONS.md` 里对应的环境状态 → `git commit` 并写明任务号。发现新工作就加一行，不要只在对话里说。
