#!/usr/bin/env sh

ARIA2_CONFIG=${AEIA2_CONFIG:-/app/etc/aria2.conf}

# 没有指定命令
if [ -z "$@" ]; then
    opt=""
    if [ -n "$ARIA2_CONFIG" ]; then
        opt="$opt --conf-path=$ARIA2_CONFIG"
    fi
    exec aria2c $opt
fi

# 指定了命令
if [ "${1:0:1}" = '-' ]; then
    set -- aria2c $@
fi

exec $@
