#!/usr/bin/env bash
: ${ALIST_PROXY_PORT:="5243"}
: ${ALIST_PROXY_ADDRESS:="http://127.0.0.1:5244"}
: ${ALIST_PROXY_TOKEN:=}
: ${ALIST_PROXY_HTTPS:=}
: ${ALIST_PROXY_KEY:=}
: ${ALIST_PROXY_CERT:=}

if [[ -z "$@" ]]; then
    set -- alist-proxy \
            ${ALIST_PROXY_PORT:+-port $ALIST_PROXY_PORT} \
            ${ALIST_PROXY_ADDRESS:+-address $ALIST_PROXY_ADDRESS} \
            ${ALIST_PROXY_TOKEN:+-token $ALIST_PROXY_TOKEN} \
            ${ALIST_PROXY_HTTPS:+-https} \
            ${ALIST_PROXY_CERT:+-cert $ALIST_PROXY_CERT} \
            ${ALIST_PROXY_KEY:+-key $ALIST_PROXY_KEY}
elif [[ "${1:0:1}" = "-" ]]; then
    set -- alist-proxy $@
fi

exec "$@"
