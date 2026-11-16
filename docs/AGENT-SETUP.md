# 智能体接入与大模型兜底方案

> 目标：让 AI 智能体能读写这个仓库；GitHub 侧连不上时，用本机大模型 + 命令行兜底，保证活儿不中断。
> 官方项目：[github/github-mcp-server](https://github.com/github/github-mcp-server)

## 先厘清两个概念

| | 作用 | 缺了会怎样 |
| --- | --- | --- |
| **MCP Server** | 智能体的「手」：把 GitHub 的读仓库 / 查 Issue / 建 PR 等能力暴露成工具 | 智能体看不到仓库，只能靠人贴内容 |
| **大模型（LLM）** | 智能体的「脑」：负责理解与决策 | 有工具也没人调用 |

两者互补，**本地大模型不能直接替代 GitHub MCP 的 API 权限**；但可以用「本地 LLM + `gh` CLI」组合，让智能体通过命令行完成同样的操作。

## 路径 A（首选）：连官方 GitHub MCP Server

GitHub 官方提供托管远程 MCP，端点 `https://api.githubcopilot.com/mcp/`，支持 OAuth 或 PAT。**该服务对所有 GitHub 用户免费（任意套餐），PAT 认证不需要 Copilot 订阅**；只有 Copilot coding agent 等本身付费的工具才需要付费权益。费用边界见 [COSTS.md](COSTS.md)。以下是官方 README 给出的 VS Code 配置（原文）：

OAuth 方式：

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    }
  }
}
```

PAT 方式（WorkBuddy 等不支持交互式 OAuth 的宿主走这条）：

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${input:github_mcp_pat}"
      }
    }
  },
  "inputs": [
    {
      "type": "promptString",
      "id": "github_mcp_pat",
      "description": "GitHub Personal Access Token",
      "password": true
    }
  ]
}
```

样例文件见 [`config/mcp.example.json`](../config/mcp.example.json)。**真实 token 只放本地 `mcp.local.json`（已被 .gitignore 排除），绝不入库。**

落到 WorkBuddy 时：

1. 拿到具备 `repo` 权限的 PAT（或先完成 `gh auth login` 授权）。
2. 在 `C:\Users\<用户名>\.workbuddy\mcp.json` 的 `mcpServers` 下合并该 server 配置，仅在官方支持的字段里填 `url` / `headers` / `env`，不臆造字段。
3. 打开连接器管理页右上角的自定义连接器入口，对新 server 点「信任」；**配置不会自动生效**。
4. 验证：让智能体列出本仓库开放 Issue，能拿到列表即通。

> 官方对各宿主（VS Code、Claude、Cursor、Codex、Copilot CLI 等）的安装指南见仓库 `docs/installation-guides/`。GitHub Enterprise Server 不支持远程托管，需改用本地 Docker 版 MCP Server。

## 路径 B（兜底）：自己跑本地大模型

适用：GitHub 侧连不上、或不想把代码发到云端推理。

1. 安装 [Ollama](https://ollama.com/)（本机**已装 0.40.16**，`winget install --id Ollama.Ollama --source winget`，可执行文件 `C:\Users\YTR\AppData\Local\Programs\Ollama\ollama.exe`）。
2. 启动服务并确认端口：`curl http://127.0.0.1:11434/api/tags`（安装后服务自动启动，已验证）。
3. 拉模型：已拉 `qwen3:4b`（2.5 GB，中文与代码场景，CPU 可跑）；显存紧张可换 `qwen3:0.6b`。
4. 让智能体以 `http://127.0.0.1:11434` 为 OpenAI 兼容端点调用；工具侧用 `gh` CLI 执行 GitHub 操作。
5. 若要「问仓库要文档」，把 `docs/INTEGRATIONS.md` 切成小段做本地检索（RAG），或直接把 `AGENTS.md` 作为系统上下文注入——本项目已按这个约定组织。

云端 API 替代方案：在 `.env` 里配 `LLM_API_KEY` 与 `LLM_BASE_URL`，代码里通过环境变量读取，不硬编码。选型未定，见 `docs/INTEGRATIONS.md`。

## 当前状态与解锁条件

| 路径 | 状态 | 需要你提供 / 操作 |
| --- | --- | --- |
| A · GitHub MCP | ❌ 未配置 | 完成设备码授权或给一个 `repo` 权限 PAT |
| A' · gh CLI 直连 | ⚠️ 已装 2.104.0，未登录（两次设备码超时） | 同上 |
| B · 本地大模型 | ✅ **已就绪** | Ollama 0.40.16 + `qwen3:4b`，11434 推理已验证，零订阅费 |
| B' · 云端 LLM API | ❌ 刻意未配置 | 会产生账单，须用户明确选型与 API Key |
| 本地骨架 + 体检脚本 | ✅ 已就绪 | 无，可直接开工 |

## 结论

**已落地**：本地骨架、文档、CI、模板、集成说明，以及路径 B 的本地大模型（Ollama + `qwen3:4b`，推理已验证），全程零订阅、零 API 账单。
**唯一还差的**：GitHub 授权（或 PAT）。两次设备码都因需本人操作而超时；用户回来重新生成一个码即可，MCP 与 `gh` 两条通道会同时打通。
**授权前也能工作**：本地 LLM 读 `AGENTS.md` / `docs/` 作上下文，通过 `gh` CLI 的匿名能力（公开仓库）或本地 git 完成不依赖账号的任务；涉及私有仓库的操作必须等授权。
