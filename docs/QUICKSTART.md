# 快速开始

## 1. 本地体检（不需要任何账号）

```bash
cd repo
bash scripts/verify.sh
```

检查必备文档、工作流 YAML 语法、疑似凭据泄漏、空白错误。CI 里跑的是同一个脚本，本地过了再提 PR。

## 2. 补齐标识

按 [WORK-PLAN.md](WORK-PLAN.md) 的「占位符清单」替换 `your-org/your-repo` 与 `@your-org/...`。GitHub 用户名 / 组织名必须确认，本机 git 配置里的名字不是有效 GitHub 账号。

## 3. 让智能体连上仓库（需 GitHub 授权）

```bash
GH="/c/Program Files/GitHub CLI/gh.exe"
"$GH" auth login --web --scopes "repo,read:org"
"$GH" auth status
"$GH" api user --jq '.login'
```

随后按 [AGENT-SETUP.md](AGENT-SETUP.md) 配置 GitHub MCP Server（PAT 方式，服务本身免费），并在 WorkBuddy 连接器页点「信任」。

## 4. 本地大模型兜底（不依赖 GitHub，免费）

> 本机已装 Ollama 0.40.16 并拉好 `qwen3:4b`，服务已启动，可直接跳到 `ollama run` 那一步。

```bash
ollama serve                    # 或安装后由系统服务自动启动
curl http://127.0.0.1:11434/api/tags
ollama pull qwen3:4b            # 小参数量化版，CPU 也能跑
ollama run qwen3:4b "用一句话说明这个仓库是做什么的"
```

把 `AGENTS.md` 作为系统上下文、`docs/INTEGRATIONS.md` 作为检索源，即可让本地模型按仓库约定工作；GitHub 侧操作通过 `gh` CLI 完成。

## 5. 推送与治理

授权完成后见《GitHub 仓库建设全套方案》第十节与 [REPOSITORY-GOVERNANCE.md](REPOSITORY-GOVERNANCE.md)。**先读 [COSTS.md](COSTS.md)**：公开仓库几乎全部治理/安全功能免费；Free 私有仓库下的 rulesets / CODEOWNERS / CodeQL 等属付费项，不要擅自开启。

## 常见卡点

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| `gh api` 提示先登录 | 未授权 | 重新走设备码或给 PAT |
| `curl 11434` 连接失败 | Ollama 服务没起 | `ollama serve` |
| 模型没出现在 `ollama list` | `OLLAMA_MODELS` 指向不对 | 确认环境变量为 `D:\Ollama\models` 后重启服务 |
| 资料库检索结果不全 | 部分源未授权 | 看 `docs/INTEGRATIONS.md`，如实说明不可达源 |
| CI 红在 `verify.sh` | 缺文件 / YAML 语法错 | 本地跑一遍脚本按 `[FAIL]` 修 |
