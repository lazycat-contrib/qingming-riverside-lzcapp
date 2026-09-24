#!/usr/bin/env bash
# 清明上河 静态站构建：克隆上游 → node build-static.mjs → site/
set -euo pipefail

VERSION="${LAZYCAT_VERSION:-${VERSION:-}}"
echo "==> building qingming-riverside version: ${VERSION:-<default branch>}"

rm -rf .upstream dist site
if [ -n "$VERSION" ]; then
  if ! git clone --depth 1 --branch "$VERSION" https://github.com/xianxie6/qingming-riverside.git .upstream 2>/dev/null; then
    echo "==> tag $VERSION not found, falling back to default branch"
    git clone --depth 1 https://github.com/xianxie6/qingming-riverside.git .upstream
  fi
else
  git clone --depth 1 https://github.com/xianxie6/qingming-riverside.git .upstream
fi

cd .upstream
node build-static.mjs
cd ..
cp -r .upstream/dist site
echo "==> site built: $(du -sh site | cut -f1)"
