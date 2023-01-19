#!/usr/bin/env sh

# 协议
# uwsgi 作为反向代理服务器(如：nginx)的上游服务器
# http 可做为上游服务器 或直接做为web服务器
: ${UWSGI_PROTOCOL:="uwsgi"}
: ${UWSGI_SOCKET:=":8000"}
: ${UWSGI_MOUNT:="/=app:app"}
: ${UWSGI_PLUGIN:="python"}

if [ -z "$@" ] || [ "${1:0:1}" = "-" ]; then
    set -- uwsgi --socket="$UWSGI_SOCKET" \
                --protocol="$UWSGI_PROTOCOL" \
                --plugin="$UWSGI_PLUGIN" \
                --mount="$UWSGI_MOUNT" $@
fi

exec $@
