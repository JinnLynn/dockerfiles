#!/bin/sh

_cleanup() {
    rm -rf /var/cache/apk/*
    rm -rf /tmp/*
    rm -rf /var/tmp/*
}

_update_apk_sources() {
    [ -z "$1" ] && return
    local mirror=${1%%/}
    (
        . /etc/os-release
        local branch=$(echo $PRETTY_NAME | cut -d" " -f3)

        cat <<-EOF | awk 'NF' >/etc/apk/repositories
${mirror}/${branch}/main
${mirror}/${branch}/community
$([ "$branch" = "edge" ] && echo "${mirror}/${branch}/testing")
EOF
    )
}

case "$1" in
    --cleanup )
        _cleanup
        ;;
    --apk-mirror )
        _update_apk_sources $2
        ;;
    # ==
    --xinfo-help )
        echo "About Alpine"
        ;;
    * )
        (
            . /etc/os-release
            echo Alpine ${VERSION_ID}
        )
        ;;
esac
