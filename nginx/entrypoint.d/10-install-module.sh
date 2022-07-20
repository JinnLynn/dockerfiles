#!/usr/bin/env sh
. /entrypoint.common

: ${NGINX_MODULE_REQUIRED:=}

install_module() {
    local mod_lst=$(join "$NGINX_MODULE_REQUIRED")

    [ -z "$mod_lst" ] && exit 0

    local mod_pkgs=""
    for mod in "$mod_lst"; do
        mod_pkgs="$mod_pkgs nginx-mod-${mod}"
    done

    mod_pkgs=$(echo $mod_pkgs)
    [ -z "$mod_pkgs" ] && exit 0

    echo_msg "Install: $mod_pkgs"
    apk add --no-cache -q $mod_pkgs
}

install_module

exit 0
