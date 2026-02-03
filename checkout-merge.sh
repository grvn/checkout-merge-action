#!/bin/bash

set -ex

/bin/echo -e '::group::\x1b[32mCloning primary repository...\x1b[0m'
git clone --progress --no-checkout --filter=tree:0 --depth=1 "${PRIM_SERVER_URL}/${PRIM_REPOSITORY}" "$PWD"
git config --global --add gc.auto 0
git config --global --add safe.directory "$PWD"
echo "::endgroup::"

/bin/echo -e '::group::\x1b[32mChecking out primary repository...\x1b[0m'
git checkout --progress --force "${PRIM_REF}"
echo "::endgroup::"

/bin/echo -e '::group::\x1b[32mConfiguring for merging secondary repository...\x1b[0m'
git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
git remote add -f secondary "${SEC_SERVER_URL}/${SEC_REPOSITORY}"
echo "::endgroup::"

/bin/echo -e '::group::\x1b[32mMerging secondary repository...\x1b[0m'
git merge --no-commit --strategy-option=theirs --allow-unrelated-histories -Xignore-space-change "secondary/${SEC_REF}"
echo "::endgroup::"
