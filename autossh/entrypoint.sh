#!//usr/bin/env bash

AUTOSSH_LOGFILE=${AUTOSSH_LOGFILE:-/dev/stdout}
AUTOSSH_POLL=${AUTOSSH_POLL:-60}
AUTOSSH_PORT=${AUTOSSH_PORT:-60010}

SSH_ARGS=${SSH_ARGS:-"-N4v"}
SSH_OPTIONS=${SSH_OPTIONS:-"StrictHostKeyChecking=no ServerAliveInterval=5 ServerAliveCountMax=1"}

# ===
export ${!AUTOSSH_*}

DEF_ARGS=""

append_args() {
    [[ -z "$1" ]] && return
    DEF_ARGS="$DEF_ARGS $@"
}

expand_args() {
    local arg=$1

    [[ -z "$arg" ]] && return

    shift
    until [[ -z "$1" ]]; do
        DEF_ARGS="$DEF_ARGS $arg $1"
        shift
    done
}

log_cmd() {
    echo =====
    echo CMD: $@
    echo =====
    echo
}

append_args ${SSH_ARGS}
expand_args -o $SSH_OPTIONS

expand_args -O $SSH_DYNAMIC_FORWARD
expand_args -L $SSH_LOCAL_FORWARD
expand_args -R $SSH_REMOTE_FORWARD

expand_args -i "$SSH_KEY"

if [[ -n "$@" && "${1:0:1}" != '-' ]]; then
    log_cmd $@
    exec $@
fi

if [[ "${1:0:1}" = '-' ]]; then
    append_args $@
fi

append_args -p ${SSH_PORT:-22} ${SSH_USR:-root}@${SSH_HOST:-localhost}

log_cmd autossh $DEF_ARGS
exec autossh $DEF_ARGS
