# 贡献指南

目标：让任何人从 `git clone` 到「可合并的 PR」不需要私下问人。

## 环境准备

1. 安装依赖（见 README 快速开始）。
2. 复制 `.env.example` 为 `.env`，填入本地配置；**`.env` 永不入库**。
3. 跑一次本地校验，确认基线是绿的。

## 分支与提交

- 默认分支 `main`，**禁止直接 push**。从 `main` 切短生命周期分支：`feat/xxx`、`fix/xxx`、`docs/xxx`。
- 提交信息用「动词 + 对象」：`fix: 修复 xxx`、`feat: 增加 xxx`；一个提交做一件事。
- 大改动先开 Issue 或 Discussion 对齐方案，再动手。

## 提交 PR 前必须满足

- [ ] 本地 lint / test / build 全绿
- [ ] 新增逻辑有对应测试
- [ ] 文档、CHANGELOG 同步更新
- [ ] 没有密钥、token、内网地址、个人信息被提交
- [ ] PR 描述填完整，关联 Issue（`Closes #123`）
- [ ] CI 全绿、评审对话全部解决

合并方式：squash merge，合并后自动删除源分支。

## 外部贡献

- 首次贡献请先阅读 [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)。
- 安全问题**不要开公开 Issue**，走 [SECURITY.md](SECURITY.md) 里的私密报告渠道。
- 是否要求 DCO 签名（`Signed-off-by`）目前：**未启用**；若将来启用，会在此处与 CI 检查同步说明。
