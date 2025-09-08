#!/usr/bin/env bash
. /nginx.rc

# 改变目录权限
find /app -maxdepth 1  -type d | while read dir; do
    if [ -w "$dir" ]; then
        chown nginx:nginx "$dir"
    else
        echo_msg "$dir is not writable"
    fi
done
