# 安全策略

## 报告渠道

**请不要用公开 Issue 报告安全漏洞。** 请走 GitHub 的私密漏洞报告：

```
https://github.com/<owner>/<repo>/security/advisories/new
```

（把 `<owner>/<repo>` 替换为本仓库实际路径；也可用仓库 Security 页的 "Report a vulnerability"。）

## 请提供

- 影响版本 / 复现环境
- 复现步骤与概念验证（PoC）
- 影响面评估，以及你建议的修复方向（如有）

## 响应承诺

| 阶段 | 时限 |
| --- | --- |
| 确认收到 | 3 个工作日内 |
| 初步评估与定级 | 7 个工作日内 |
| 修复或缓解方案 | 视严重度，高危优先 |
| 公开披露 | 修复发布后，与报告人协商时间 |

## 支持范围

仅维护最新稳定版与当前主线分支；旧版本建议升级。

## 基线配置

本仓库应开启：Secret scanning + Push protection、Dependabot alerts 与 security updates、CodeQL 代码扫描、Dependency Review（PR 阶段拦截高危依赖与不允许的许可证）。配置方法见 `docs/INTEGRATIONS.md`。
