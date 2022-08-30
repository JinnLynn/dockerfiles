#!/usr/bin/env bash

: ${REQUIRED_PKGS:=}

# ===
install_pkgs() {
    local j=" "
    local pkgs=$(echo "$@" | sed "s/[ ,]\{1,\}/${j}/g" | sed "s/\(^${j}\{1,\}\|${j}\{1,\}$\)//g")
    [[ -z "$pkgs" ]] && return 0

    local pkg_need=
    local pkg_installed=
    for p in $pkgs; do
        if apk info -e $p 1>/dev/null 2>&1; then
            pkg_installed="$pkg_installed $p"
        else
            pkg_need="$pkg_need $p"
        fi
    done

    pkg_installed=$(echo $pkg_installed)
    if [[ -n "$pkg_installed" ]]; then
        echo "Package Installed: $pkg_installed" >&2
    fi

    pkg_need=$(echo $pkg_need)
    if [[ -n "$pkg_need" ]]; then
        echo "Package Installing: $pkg_need" >&2
        apk add --no-cache --no-progress --quiet $pkg_need
    fi
}

# ===
if [[ -n "${REQUIRED_PKGS}" ]]; then
    install_pkgs "$REQUIRED_PKGS"
fi

exec $@
