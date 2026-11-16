# 费用边界：哪些免费、哪些要钱

> 结论先行：**到目前为止这套东西花费为 0**。本地建仓、写文档、`git init`、安装 GitHub CLI（开源免费）都没有产生任何账单，也没订阅任何服务、没调用付费 API。
> 本文按 2026-11-17 查到的官方定价整理；价格会变，决策前以 https://github.com/pricing 为准。

## 已完成 / 已建议的部分

| 项目 | 费用 | 依据 |
| --- | --- | --- |
| 本地仓库骨架、文档、模板、CI 文件 | ¥0 | 纯本地文件 |
| `git` / `gh` GitHub CLI | ¥0 | 开源免费，https://cli.github.com/ |
| GitHub Free 账号（无限公开 + 私有仓库、Issues/PR/Projects） | ¥0 | GitHub Free $0，含 2,000 Actions 分钟/月、500 MB Packages、Dependabot 安全与版本更新 |
| 官方 GitHub MCP Server（远程 `api.githubcopilot.com/mcp/`） | ¥0 | 官方明确「所有 GitHub 用户、任意套餐可用」，MIT 开源；用 PAT 认证**不需要 Copilot 订阅** |
| PAT / 设备码登录 | ¥0 | 只是凭据，不是付费项 |
| Ollama + 开源模型权重（如 qwen3、deepseek-r1） | ¥0 | 本地运行，权重多为 MIT / Apache 许可；成本只有磁盘与电费，7B 量化模型约 4.7 GB |
| GitHub Actions（公开仓库） | ¥0 | 公开仓库分钟数免费；私有仓库 Free 有 2,000 分钟/月 |

## 会花钱的部分（都可以先不碰）

| 项目 | 价格量级 | 什么时候才会遇到 |
| --- | --- | --- |
| 云端大模型 API（OpenAI / Claude / 国产厂商等） | 按 token 计费 | **只有**主动配置 `LLM_API_KEY` 并调用才产生；本仓库未配置 |
| GitHub Copilot Pro / Pro+ / Business | $10 / $39 / $19 每用户每月量级 | 需要 Copilot 编码助手或 coding agent 时；有**限量免费档** |
| 私有仓库的 rulesets / CODEOWNERS / 必需评审 / 必需状态检查 | Team 约 $4 每用户每月起 | Free 计划下这些只对**公开仓库**免费，私有仓库要升级 |
| 私有仓库的 Secret Protection / Code Security（CodeQL 扫描） | 付费附加项或更高套餐 | 公开仓库免费；私有仓库属 GitHub Advanced Security 范畴 |
| Git LFS 超额 | $5/月 / 50 GB | 只在存大量大文件且超免费额度时 |
| GitHub Codespaces | $0.18/小时起 | 有免费 core-hours，超出才计费 |

来源：https://github.com/pricing ｜ https://github.com/github/github-mcp-server ｜ https://ollama.com/

## ⚠️ 一处需要修正方案的地方

`docs/REPOSITORY-GOVERNANCE.md` 与《GitHub 仓库建设全套方案》里建议「rulesets 锁 main + CODEOWNERS + 四个安全开关全开」。这套组合在**公开仓库**下全部免费；但在 **Free 计划的私有仓库**下，其中相当一部分属于 Team 套餐或 GHAS 附加项。

按「0 成本」目标，两条可行路线：

1. **仓库设为公开** → 分支保护、CODEOWNERS、secret scanning、CodeQL 几乎都能免费拿到（代价是代码公开）。
2. **保持私有 + Free** → 用免费部分（Dependabot、2,000 分钟 Actions、基础 PR 评审），把 rulesets / CODEOWNERS / 平台侧安全扫描列为「升级后再开」；用本地 `gitleaks` + pre-commit 顶上密钥检查，CI 里保留 lint/test。

`docs/REPOSITORY-GOVERNANCE.md` 记录的是**预期策略**，不代表当前套餐下都能零成本启用。

## 全程零成本的组合（推荐）

```text
GitHub Free（私有或公开仓库）
  + gh CLI / GitHub MCP Server（PAT 认证，免费）
  + 本地 Ollama 跑开源模型（免费，只吃磁盘与电）
  + 本地 gitleaks + CI lint/test
  = 智能体能读写仓库、能推理，0 订阅、0 API 账单
```

唯一真正会开始计费的动作是：**主动去配云端 LLM 的 API Key**，或**主动升级 GitHub 套餐 / 开启私有仓库的付费安全附加项**。这两件事都需要你明确点头才会做。
