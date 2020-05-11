#!/usr/bin/env sh

LAST_UPDATE=${LAST_UPDATE:-/app/tmp/last-update}
PULL_INTERVAL=${PULL_INTERVAL:-86400}

update() {
    cd ${REPO_LOCAL}
    ts=$(date +%s)
    if [ -e .git ]; then
        last_update=$(cat $LAST_UPDATE 2>/dev/null)
        [ -z "$last_update" ] && last_update=0
        diff=$(echo "$ts-$last_update" | bc)
        if [ "$diff" -gt $PULL_INTERVAL ]; then
            echo "Pull..."
            git pull --recurse-submodules --depth 1 -qfr
            echo $ts >$LAST_UPDATE
        fi
    else
        echo "Clone..."
        git clone --recurse-submodules --depth 1 --single-branch -q ${REPO_REMOTE} .
        pip install -qe .
        echo $ts >$LAST_UPDATE
    fi
    cd - >/dev/null
}

update

# 直接指定参数 调用外部下载工具多线程下载
if [ "${1:0:1}" = '-' ]; then
    set -- youtube-dl --external-downloader aria2c \
                      --external-downloader-args --file-allocation=none \
                      --external-downloader-args --summary-interval=60 \
                      --external-downloader-args --max-connection-per-server=16 \
                      $@
fi

exec $@
