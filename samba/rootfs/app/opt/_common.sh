#!/usr/bin/env bash

# $1 CONFIG_NAME ENV prefix
multi_config() {
    set | \
        awk '/^'$1'[0-9_]*=/ {sub (/^[^=]*=/, "", $0); print}' | \
        sed "s/^['\"]//; s/['\"]$//g"
}

# 以空格或逗号分割字符串并以指定字符串合并
# 默认以空格合并
join_config() {
    [[ -z "$1" ]] && return 0
    local j=${2:-" "}
    echo "$1" | sed "s/[ ,]\{1,\}/${j}/g" | sed "s/\(^${j}\{1,\}\|${j}\{1,\}$\)//g"
}

log() {
    echo "[$(basename $0)] $@"
}
