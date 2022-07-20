#!/usr/bin/env bash

: ${REQUIRED_PKGS=}

if [[ -n "${REQUIRED_PKGS}" ]]; then
    apk add --no-cache ${REQUIRED_PKGS}
fi

exec $@
