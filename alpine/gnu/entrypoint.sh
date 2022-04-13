#!/usr/bin/env bash

: ${INSTALL_PKGS=}

if [[ -n "${INSTALL_PKGS}" ]]; then
    apk add --no-cache ${INSTALL_PKGS}
fi

exec $@
