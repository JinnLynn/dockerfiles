#!/usr/bin/env sh

ARIA2_RPC_HOST=${ARIA2_RPC_HOST:-"http://localhost"}
ARIA2_RPC_PORT=${ARIA2_RPC_PORT:-6800}
ARIA2_RPC_SECRET=${ARIA2_RPC_SECRET:-}

ARIA2P_TIMEOUT=${ARIA2P_TIMEOUT:-60}

if [ "$1" != "aria2p" ]; then
    set -- aria2p --host=$ARIA2_RPC_HOST --port=$ARIA2_RPC_PORT --secret=$ARIA2_RPC_SECRET --client-timeout=$ARIA2P_TIMEOUT $@
fi

exec $@
