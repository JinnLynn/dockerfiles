#!/usr/bin/env sh

: ${ICLOUDPD_USERNAME=""}
: ${ICLOUDPD_DIRECTORY:="/app/local/data"}
: ${ICLOUDPD_COOKIE_DIRECTORY:="/app/local/cookie"}
: ${ICLOUDPD_FOLDER_STRUCTURE:="{:%Y/%m}"}
: ${ICLOUDPD_WATCH_WITH_INTERVAL:="86400"}
: ${ICLOUDPD_DOMAIN:="cn"}

# debug|info|error
: ${ICLOUDPD_LOG_LEVEL:="info"}

# 是否删除""已删除"相册中的照片
: ${ICLOUDPD_AUTO_DELETE:=0}

mkdir -p ${ICLOUDPD_DIRECTORY}
mkdir -p ${ICLOUDPD_COOKIE_DIRECTORY}

if [ -z "$@" ] || [ "${1:0:1}" = "-" ]; then
    if [ -z "$ICLOUDPD_USERNAME" ]; then
        echo "ICLOUDPD_USERNAME is non-existend."
        sleep infinity
    fi
    opt=""
    if [ "$ICLOUDPD_AUTO_DELETE" = 1 ]; then
        opt="$opt --auto-delete"
    fi
    set -- icloudpd --directory "${ICLOUDPD_DIRECTORY}" \
                --cookie-directory "${ICLOUDPD_COOKIE_DIRECTORY}" \
                --folder-structure "${ICLOUDPD_FOLDER_STRUCTURE}" \
                --watch-with-interval ${ICLOUDPD_WATCH_WITH_INTERVAL} \
                --domain "${ICLOUDPD_DOMAIN}" \
                --username "${ICLOUDPD_USERNAME}" \
                --log-level "${ICLOUDPD_LOG_LEVEL}" \
                $opt "$@"
fi

echo "RUN: $@"

exec "$@"
