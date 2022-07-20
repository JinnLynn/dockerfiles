#!/usr/bin/env sh
. /entrypoint.common

: ${NGINX_CLEAN:=}

clean() {
    local clean_lst=$(join "$NGINX_CLEAN")

    [ -z "$clean_lst" ] && return 0

    for f in "$clean_lst"; do
        path=/etc/nginx/$f
        [ ! -e "$path" ] && continue
        rm -rf "$path" && \
            echo_msg "Remove $path" || \
            echo_msg "ERROR: Remove $path"
    done
}


clean

exit 0
