#!/usr/bin/env bash
# 仓库体检：与技术栈无关，本地和 CI 都跑同一套。
# 用法：bash scripts/verify.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail=0
ok()   { printf '  [OK]   %s\n' "$1"; }
bad()  { printf '  [FAIL] %s\n' "$1"; fail=1; }
info() { printf '  [INFO] %s\n' "$1"; }

echo "== 1. 必备文件 =="
for f in README.md LICENSE CONTRIBUTING.md CODE_OF_CONDUCT.md SECURITY.md CHANGELOG.md AGENTS.md \
         .gitignore .github/CODEOWNERS .github/dependabot.yml .github/pull_request_template.md \
         docs/INTEGRATIONS.md docs/AGENT-SETUP.md docs/COSTS.md docs/WORK-PLAN.md; do
  if [ -f "$f" ]; then ok "$f"; else bad "缺少 $f"; fi
done

echo "== 2. 工作流 YAML 语法 =="
if python -c 'import yaml' >/dev/null 2>&1; then
  for f in .github/workflows/*.yml .github/dependabot.yml .github/ISSUE_TEMPLATE/*.yml; do
    if python -c 'import sys, yaml; yaml.safe_load(open(sys.argv[1], encoding="utf-8"))' "$f" >/dev/null 2>&1; then
      ok "$f"
    else
      bad "$f 不是合法 YAML"
    fi
  done
else
  info "未安装 PyYAML，跳过语法解析（CI 环境会执行）"
fi

echo "== 3. 凭据泄漏粗筛 =="
# 只扫已跟踪的文本文件；命中即失败，避免 token 进入历史。
if git grep -n -I -E 'ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}' -- . ':!scripts/verify.sh' >/tmp/verify-secrets.txt 2>/dev/null; then
  bad "发现疑似凭据："
  cat /tmp/verify-secrets.txt
else
  ok "未发现疑似真实凭据"
fi

echo "== 4. 空白与格式 =="
if git diff --check >/dev/null 2>&1; then ok "无行尾空白 / 空白错误"; else bad "git diff --check 有告警"; fi

echo "== 5. 占位符提醒 =="
if grep -R -n -I 'your-org/your-repo\|@your-org' -- README.md SECURITY.md .github config docs >/dev/null 2>&1; then
  info "仍有待确认占位符，清单见 docs/WORK-PLAN.md（不视为失败）"
else
  ok "无遗留占位符"
fi

echo
if [ "$fail" -eq 0 ]; then
  echo "体检通过 ✅"
  exit 0
else
  echo "体检未通过 ❌，请修复上面的 [FAIL] 项"
  exit 1
fi
