#!/usr/bin/env sh

: ${CFST_IP_FILE:=}
: ${CFST_URL:=}
: ${CFST_COLO:=}
: ${CFST_OUTPUT:="result-$(date +%Y%m%d-%H%M%S).csv"}

: ${CFST_IPV6:=}
: ${CFST_IPS:=}

function download_ips() {
    local url=${CFST_IP_URL_V4:="https://www.cloudflare-cn.com/ips-v4/"}
    local local_file="/app/etc/ipv4.txt"
    if [ "$CFST_IPV6" = "1" ]; then
        url=${CFST_IP_URL_V6:="https://www.cloudflare-cn.com/ips-v6/"}
        local_file="/app/etc/ipv6.txt"
    fi
    CFST_IPS=$(wget -qO- ${CFST_IP_URL_V4:="https://www.cloudflare-cn.com/ips-v6/"} | tr "\n" ",")
    if [ -z "$CFST_IPS" ]; then
        echo "Download IP file fail."
        CFST_IPS=$(cat $local_file)
    fi
}

if [ -z "$1" ]; then
    if [ -z "$CFST_IPS" ]; then
        if [ -z "$CFST_IP_FILE" ]; then
            download_ips
        else
            CFST_IPS=$(cat "$CFST_IP_FILE" | tr "\n" ",")
        fi
    fi
    set -- CloudflareST \
        ${CFST_IPS:+"-ip $CFST_IPS"} \
        ${CFST_URL:+"-url $CFST_URL"} \
        ${CFST_COLO:+"-cfcolo $CFST_COLO"} \
        ${CFST_OUTPUT:+"-o $CFST_OUTPUT"}
elif [ "${1:0:1}" = "-" ]; then
    set -- CloudflareST $@
fi

echo RUNNING: "$@"
echo "==="
exec $@
