#!/usr/bin/env sh

REPO_REMOTE=${REPO_REMOTE:-https://github.com/ytdl-org/youtube-dl.git}
REPO_LOCAL=${REPO_LOCAL:-/app/opt/youtube-dl}

LAST_UPDATE=${LAST_UPDATE:-/app/etc/last-update}
# 拉取检查间隔 默认: 86400(一天) 当 <=0时禁止拉取
PULL_INTERVAL=${PULL_INTERVAL:-86400}

CUR_TS=$(date +%s)
# =====

commit_info() {
    local title=${1:-"LAST COMMIT"}
    echo "$title:" $(git log -n1 --format="%h %cs" | tail -n1)
}

clone() {
    echo "Clone..."
    # pull 某些情况需user
    git clone --recurse-submodules --depth 1 --single-branch --progress ${REPO_REMOTE} . && \
        git config user.email "${GIT_USER_EMAIL:-you@example.com}" && \
        git config user.name "${GIT_USER_NAME:-YourName}" && \
        echo $CUR_TS >$LAST_UPDATE && \
        commit_info "CLONED" && \
        echo "=========="
}

pull() {
    if [ $PULL_INTERVAL -le 0 ]; then
        echo "Pull Ignored..."
        return
    fi

    last_update=$(cat $LAST_UPDATE 2>/dev/null)
    [ -z "$last_update" ] && last_update=0
    diff=$(echo "$CUR_TS-$last_update" | bc)

    if [ "$diff" -gt $PULL_INTERVAL ]; then
        echo "Pull..."
        git pull --recurse-submodules --depth 1 -qfr && \
            echo $CUR_TS >$LAST_UPDATE && \
            commit_info "PULLED" && \
            echo "=========="
    fi
}


if [ "$@" = "cleanup" ]; then
    rm -rfv ${REPO_LOCAL}/*
    rm -rfv ${REPO_LOCAL}/.*
    rm -rfv ${LAST_UPDATE}
    echo "All Removed."
    exit 0
fi

mkdir -p "${REPO_LOCAL}"
cd "${REPO_LOCAL}"
if [ -e "${REPO_LOCAL}/.git" ]; then
    pull
else
    clone
fi
# 版本库提交信息
if [ "$1" == "--version" ]; then
    commit_info
    echo "=========="
fi
cd - >/dev/null

# =====

# REF: https://github.com/ytdl-org/youtube-dl/blob/master/youtube-dl.plugin.zsh
export PYTHONPATH="${REPO_LOCAL}:${PYTHONPATH}"
export PATH="${REPO_LOCAL}/bin:${PATH}"

# 直接指定参数 调用外部下载工具多线程下载
if [ "${1:0:1}" = '-' ]; then
    set -- youtube-dl --external-downloader aria2c \
                      --external-downloader-args --file-allocation=none \
                      --external-downloader-args --summary-interval=60 \
                      --external-downloader-args --max-connection-per-server=16 \
                      $@
fi

exec $@
