#!/bin/sh
set -e

BRANCH="__BRANCH__"
VERSION="__VERSION__"
MIRROR="__MIRROR__"
TIMEZONE="__TIMEZONE__"
APP_DIRS="__APP_DIRS__"

if [ "$MIRROR" ]; then
    {
        echo "$MIRROR/$BRANCH/main"
        echo "$MIRROR/$BRANCH/community"
        if [ "$BRANCH" == "edge" ]; then
            echo "$MIRROR/$BRANCH/testing"
        fi
    } >/etc/apk/repositories
fi

if [ "$TIMEZONE" ]; then
    apk add --no-cache tzdata
    cp "/usr/share/zoneinfo/$TIMEZONE" "/etc/localtime"
    apk del --no-cache tzdata
fi

if [ "$APP_DIRS" ]; then
    # alpine mkdir 不支持mkdir -p /app/{...}
    for d in $APP_DIRS; do mkdir -p /app/$d; done
fi

exit 0
