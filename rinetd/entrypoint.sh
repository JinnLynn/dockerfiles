#!/usr/bin/env sh
: ${RINETD_CONF_ATTACHED:=}
: ${RINETD_LOGFILE:="/dev/stdout"}

# $1 CONFIG_NAME ENV prefix
multi_config() {
    set | \
        awk '/^'$1'[0-9_]*=/ {sub (/^[^=]*=/, "", $0); print}' | \
        sed "s/^['\"]//; s/['\"]$//g"
}

# ENV_PREFIX [DEFAULT]
write_env_config() {
    [ -z "$1" ] && return 1
    set | grep -Eqs "^$1" || {
        [ -n "$2" ] && echo "$2"
        return 1
    }
    echo "# $1"
    multi_config "$1"  | while read -r var; do
        echo $var
    done
    echo
}

if [ -z "$@" ]; then
    run_conf="/app/run/rinetd.conf"
    [ -f "$run_conf" ] && rm -rf "$run_conf"

    (
        write_env_config RINETD_RULE
        write_env_config RINETD_FORWARD

        if [ -n "$RINETD_LOGFILE" ]; then
            echo "logfile $RINETD_LOGFILE"
            echo
        fi

        if [ -f "$RINETD_CONF_ATTACHED" ]; then
            echo "# RINETD_CONF_ATTACHED: ${RINETD_CONF_ATTACHED}"
            cat "$RINETD_CONF_ATTACHED"
            echo
        fi
    ) >> "$run_conf"
    set -- rinetd -f -c "${run_conf}"
fi

if [ "${1:0:1}" = "-" ]; then
    set -- rinetd $@
fi

exec $@
