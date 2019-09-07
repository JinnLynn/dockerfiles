#!/usr/bin/env sh

cd ${REPO_DIR}

# 更新
git pull --depth 1 -f --recurse-submodules -q

cd - >/dev/null

exec youtube-dl --external-downloader aria2c \
                --external-downloader-args "--file-allocation=none --summary-interval=0" \
                $@
