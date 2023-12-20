#!/usr/bin/env sh

: ${ARIA2_CONFIG:="/app/etc/aria2.conf"}

if [ -z "$@" ]; then
    set -- aria2c ${ARIA2_CONFIG:+"--conf-path=$ARIA2_CONFIG"} \
                ${ARIA2_RPC_SECRET:+"--rpc-secret=$ARIA2_RPC_SECRET --enable-rpc=true"}
fi

if [ "${1:0:1}" = "-" ]; then
    set -- aria2c $@
fi

exec $@
