# Changelog

本文件记录版本的显著变更，格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，版本号遵循 [Semantic Versioning](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### Added

- 仓库基础骨架：README / LICENSE / CONTRIBUTING / CODE_OF_CONDUCT / SECURITY / CHANGELOG / AGENTS
- `.github/` 配置：CODEOWNERS、Dependabot、Issue 与 PR 模板、CI 工作流
- `docs/AGENT-SETUP.md`：智能体接入与本地大模型兜底方案
- `docs/INTEGRATIONS.md`：软件与插件使用说明（智能体「问仓库要」的入口）
- `docs/COSTS.md`：费用边界（免费项 / 付费项 / 零成本路线），并标注 Free 私有仓库下治理与安全功能的套餐限制
- `docs/WORK-PLAN.md`：工作布置与进度看板（6 项任务、负责人、依赖、验收标准、待确认占位符清单）
- `docs/QUICKSTART.md`：本地体检、智能体接入、本地大模型兜底的快速开始
- `scripts/verify.sh` + CI 接入：本地与 CI 共用同一套仓库体检（必备文档、YAML 语法、凭据粗筛、空白检查）
- `.github/workflows/codeql.yml`：CodeQL 工作流，默认手动触发，避免 Free 私有套餐下自动失败
- `.env.example`：环境变量占位样例（云端 LLM 与 GitHub token 均留空）
- `docs/INTEGRATIONS.md` 与 `AGENTS.md`：把资料库 / 文献库标记为日常最常用入口，明确「内部资料查资料库、工具用法查仓库」的分工
- README 首段说明、LICENSE 版权人、README 文档地图补齐

---

## [0.1.0] - 2026-11-17

### Added

- 初始骨架（本地，尚未推送 GitHub）
