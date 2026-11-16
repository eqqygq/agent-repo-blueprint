# 仓库名称（待定）

> 一句话说明这个项目做什么、为谁解决什么问题。**建仓第一件事就是把它填好。**

## 当前状态

- [x] 本地骨架已按《GitHub 仓库建设全套方案》生成
- [ ] 尚未推送到 GitHub（本机 GitHub CLI 未登录 / 无 PAT）
- [ ] 智能体接入（GitHub MCP Server）待配置
- [ ] 本地大模型兜底待安装

骨架位置：`repo/`。方案全文见工作区根目录的 `GitHub仓库建设全套方案.md`。

## 快速开始

```bash
# 1) 安装依赖 / 启动（按实际技术栈替换）
# 2) 本地校验
# 3) 阅读 CONTRIBUTING.md 了解提交规范
```

## 文档地图

| 我想知道… | 去看 |
| --- | --- |
| 怎么参与开发、提 PR | [CONTRIBUTING.md](CONTRIBUTING.md) |
| AI 智能体怎么连仓库、大模型兜底怎么做 | [docs/AGENT-SETUP.md](docs/AGENT-SETUP.md) |
| 其他软件 / 插件怎么装、怎么用 | [docs/INTEGRATIONS.md](docs/INTEGRATIONS.md) |
| 系统怎么设计 | [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) |
| 分支保护、权限、发布策略 | [docs/REPOSITORY-GOVERNANCE.md](docs/REPOSITORY-GOVERNANCE.md) |
| 安全漏洞往哪报 | [SECURITY.md](SECURITY.md) |
| 版本之间变了什么 | [CHANGELOG.md](CHANGELOG.md) |

> **给 AI 助手**：动手前先读 [AGENTS.md](AGENTS.md)；遇到任何工具或插件的用法问题，先查 `docs/INTEGRATIONS.md`，查不到就补充进去再继续。

## 下一步（按顺序）

1. 补齐上面「一句话说明」，确定仓库名、归属、可见性与许可证。
2. 完成 GitHub 授权后，按 `GitHub仓库建设全套方案.md` 第十节推送并开启规则集与安全开关。
3. 配置 GitHub MCP Server（见 `docs/AGENT-SETUP.md`），让智能体能直接读写仓库。
4. 需要离线 / 私有推理时，按 `docs/AGENT-SETUP.md` 装本地大模型兜底。

## 许可证

[MIT](LICENSE)
