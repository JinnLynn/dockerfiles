#!/usr/bin/env bash
. /entrypoint.common

: ${NGINX_MODULE_REQUIRED:=}

install_module() {
    local mod_lst=$(join "$NGINX_MODULE_REQUIRED")

    [ -z "$mod_lst" ] && exit 0

    local mod_need=""
    local mod_installed=""
    for mod in "$mod_lst"; do
        mod="nginx-mod-${mod}"
        if apk info -e $mod 1>/dev/null 2>&1; then
            mod_installed="$mod_installed $mod"
        else
            mod_need="$mod_need $mod"
        fi
    done

    mod_installed=$(echo $mod_installed)
    if [[ -n "$mod_installed" ]]; then
        echo_msg "Installed: $mod_installed"
    fi

    mod_need=$(echo $mod_need)
    if [[ -n "$mod_need" ]]; then
        echo_msg "Installing: $mod_need"
        apk add --no-cache -q $mod_need
    fi
}

install_module

exit 0
