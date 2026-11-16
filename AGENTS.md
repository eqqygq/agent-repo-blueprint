# AGENTS.md — 给 AI 智能体的仓库上下文

> 任何在本仓库工作的 AI 助手 / 编码智能体，动手前先读完本文件。

## 第一条规则：插件用法「问仓库要」

遇到任何软件、CLI、插件、集成的用法问题，**先查 [docs/INTEGRATIONS.md](docs/INTEGRATIONS.md)**。

- 查得到 → 按仓库里记录的方式执行，不要凭记忆另写一套。
- 查不到 → 先核实官方资料，把结论补进 `docs/INTEGRATIONS.md`，再继续任务。
- **涉及内部资料、历史方案、定稿文档 → 先查 WorkBuddy 资料库 / 文献库（用户标注为日常最常用入口）**；资料库没命中，再回仓库查工具用法。连接失败时如实说明哪些源没检索到。
- 智能体接入与大模型兜底的具体做法在 [docs/AGENT-SETUP.md](docs/AGENT-SETUP.md)，费用边界在 [docs/COSTS.md](docs/COSTS.md)。

这样仓库本身就是智能体的知识源，换模型、换会话都不会丢上下文。

## 仓库结构

| 路径 | 用途 |
| --- | --- |
| `.github/` | 规则、模板、工作流配置；改动需人工评审 |
| `docs/` | 架构、集成说明、治理策略、智能体接入方案 |
| `config/` | 配置样例（`*.example.json` 可入库，含真实凭据的 `*.local.json` 禁止入库） |
| `src/` `tests/` | 代码与测试（按实际技术栈创建） |

## 常用命令

```bash
# 校验（按实际技术栈替换后写死在这里）
# lint / test / build

# 与 GitHub 交互（本机 gh 需绝对路径）
GH="/c/Program Files/GitHub CLI/gh.exe"
"$GH" auth status
"$GH" issue list --state open
```

## 必须遵守

- 永远不把 token、PAT、密钥、内网地址、个人信息写进任何会被提交的文件。
- 不直接向 `main` push；所有改动走分支 + PR。
- 不擅自修改 `.github/workflows/`、`.github/CODEOWNERS`、`SECURITY.md`，需人工确认。
- 生成的代码要能跑通本地校验；无法验证时明确说明，不要假装通过。
- 引用外部信息时给出来源链接，不编造 URL 或版本号。

## 当前环境状态（2026-11-17）

| 能力 | 状态 | 阻塞点 |
| --- | --- | --- |
| 本地 git 仓库 | ✅ 已就绪（4 次提交，工作区干净） | — |
| 仓库体检脚本 | ✅ `scripts/verify.sh` 本地与 CI 共用，已通过 | — |
| GitHub CLI | ⚠️ 已装 2.104.0，**未登录** | 两次设备码（2030-9FDF / 0A77-6039）均 15 分钟超时，需用户本人授权或 PAT |
| GitHub MCP Server | ⏸ 未配置 | 依赖 GitHub 授权 / PAT |
| 本地大模型（Ollama） | ✅ 0.40.16 + `qwen3:4b`（2.5 GB），11434 服务可用，推理已验证 | — |
| 云端大模型 API | ❌ 刻意未配置 | 会产生账单，须用户明确选型与 API Key 后才启用 |
