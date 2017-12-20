#!/usr/bin/env sh

ARIA2_INPUT_FILE=${ARIA2_INPUT_FILE:-/app/run/aria2.session}
ARIA2_CONFIG_FILE=${AEIA2_CONFIG_FILE:-/app/etc/aria2.conf}

# 没有指定命令
if [ -z "$@" ]; then
    opt=""
    if [ -n "$ARIA2_CONFIG_FILE" ]; then
        opt="$opt --conf-path=$ARIA2_CONFIG_FILE"
    fi
    if [ -n "$ARIA2_INPUT_FILE" ]; then
        touch $ARIA2_INPUT_FILE
        opt="$opt --input-file=$ARIA2_INPUT_FILE"
    fi
    exec aria2c $opt
fi

# 指定了命令
if [ "${1:0:1}" = '-' ]; then
    set -- aria2c "$@"
fi

exec $@
