# 仓库治理策略

> 本文件记录**预期策略**，便于审计与重建；真正的强制机制在 GitHub 设置侧（Repository Rulesets / 组织策略），文档本身不具强制力。
>
> ⚠️ 费用提示：下列 rulesets / CODEOWNERS / 必需评审与状态检查、以及私有仓库的 Secret Protection / Code Security，在 **GitHub Free 的私有仓库**下属于 Team 套餐或付费附加项；公开仓库则免费。零成本路线见 [COSTS.md](COSTS.md)。

## 分支与合并

- 默认分支 `main`；`release/*` 同级别保护。
- 所有改动走短生命周期分支 + PR；禁止直接 push、force push、分支删除。
- 合并方式：squash merge，合并后自动删除源分支，保持线性历史。

## Ruleset 基线（推送后在 GitHub 设置里配置）

| 规则 | 值 |
| --- | --- |
| Require a pull request before merging | 开启，≥1 审批 |
| Require review from Code Owners | 开启 |
| Dismiss stale approvals | 开启 |
| Require status checks | CI / lint / CodeQL / Dependency Review |
| Require branches to be up to date | 开启 |
| Block force pushes and deletions | 开启 |
| Require signed commits | 建议开启 |
| Bypass list | 保持最小，定期审计并告警 |

## 权限

| 角色 | 给谁 |
| --- | --- |
| Admin | 最少人数，仅平台负责人 |
| Maintain | 模块负责人 |
| Write | 开发者 |
| Read / Triage | 外部协作、只读方 |

按路径的责任人见 `.github/CODEOWNERS`。工作流默认 `permissions: contents: read`，各 job 按需单独提权；第三方 Action 固定到 commit SHA。

## 标签体系

`bug` / `enhancement` / `documentation` / `dependencies` / `security` / `triage` / `ci` / `good first issue`。
模板里只允许引用已存在的标签，否则 GitHub 会在首次使用时自动创建，污染体系。

## 版本与发布

- SemVer，tag 形如 `v1.2.3`，tag 与 Release 产物不可变。
- 每次发布同步 `CHANGELOG.md`；beta 用单独的 tag / dist-tag。
- 发布前 CI、导出检查、类型校验、体积预算与浏览器测试全部通过。

## 安全

- Secret scanning + Push protection、Dependabot alerts/updates、CodeQL、Dependency Review 全开。
- 漏洞走 Private Vulnerability Reporting，公开 Issue 里不讨论未修复漏洞。
- 审计日志流式留存；对 ruleset / push protection 的绕过事件、可见性变更、新 token 与 deploy key 告警。

## 生命周期

- 长期不维护的仓库先归档（只读），不直接删除。
- 归档前确认：README 说明状态、文档保留、依赖与凭据已清理。
