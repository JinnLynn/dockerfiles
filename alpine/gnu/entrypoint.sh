#!/usr/bin/env bash

: ${INSTALL_PAGS:=}

if [[ -n "$INSTALL_PAGS" ]]; do
    apk add --no-cache $INSTALL_PAGS
done

exec $@
