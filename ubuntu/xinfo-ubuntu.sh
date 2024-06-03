#!/bin/sh

_cleanup() {
    apt-get autoremove -qy
    apt-get clean -qy
    rm -rf /var/lib/apt/lists/*
    rm -rf /tmp/*
    rm -rf /var/tmp/*
}

_update_apt_sources() {
    local mirror=$1
    if [ -z "$mirror" ]; then
        echo "Mirror missing" 2>&1
        return 1
    fi
    if echo $mirror | grep -qE "^https:"; then
        if ! dpkg -l ca-certificates | grep -qE "^ii +"; then
            apt-get update
            apt-get install -y ca-certificates
        fi
    fi
    (
        . /etc/os-release
        if [ -f "/etc/apt/sources.list.d/ubuntu.sources" ]; then
            cat <<EOF >/etc/apt/sources.list.d/ubuntu.sources
Types: deb
URIs: ${mirror}
Suites: ${UBUNTU_CODENAME} ${UBUNTU_CODENAME}-updates ${UBUNTU_CODENAME}-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: ${mirror}
Suites: ${UBUNTU_CODENAME}-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF
        else
            cat <<EOF >/etc/apt/sources.list
deb ${mirror} ${UBUNTU_CODENAME} main restricted universe multiverse
deb ${mirror} ${UBUNTU_CODENAME}-updates main restricted universe multiverse
deb ${mirror} ${UBUNTU_CODENAME}-backports main restricted universe multiverse
deb ${mirror} ${UBUNTU_CODENAME}-security main restricted universe multiverse
EOF
        fi
    )
}

case "$1" in
    --cleanup )
        _cleanup
        ;;
    --apt-sources )
        _update_apt_sources $2
        ;;
    # ==
    --xinfo-help )
        echo "About Ubuntu"
        ;;
    * )
        (
            . /etc/os-release
            echo Ubuntu ${VERSION}
        )
        ;;
esac
