#!/usr/bin/env sh

# 协议 默认启用 设置为空时禁用 不能同时禁用
# uwsgi
: ${UWSGI_SOCKET=":8089"}
# http
: ${UWSGI_HTTP_SOCKET=":8080"}

: ${UWSGI_MOUNT:="/=app:app"}
: ${UWSGI_WORKERS="$(( $(cat /proc/cpuinfo| grep 'processor'| wc -l) * 2 ))"}

: ${UWSGI_UNSET_ENVIRONMENT_VARIABLES:=1}

if [ $# -eq 0 ] || [ "${1:0:1}" = "-" ]; then
    set -- uwsgi ${UWSGI_SOCKET:+--socket="$UWSGI_SOCKET"} ${UWSGI_HTTP_SOCKET:+"--http-socket=$UWSGI_HTTP_SOCKET"} \
                --protocol="uwsgi" \
                --mount="${UWSGI_MOUNT}" \
                --workers="${UWSGI_WORKERS:-1}" \
                --manage-script-name --enable-threads \
                --logformat-strftime --log-date="%Y-%m-%d %H:%M:%S,000" \
                --logformat="[%(ftime)][UWSGI]: %(addr) %(method) %(status) %(uri) %(proto) {req %(cl) / %(pktsize) bytes} => {rep %(wid) %(rsize) / %(hsize) bytes in %(msecs) msecs}" \
                "$@"
fi

# 当执行的是默认定义的参数时，删除一些环境变量 防止这些环境变量被当做uwsgi的参数
# https://uwsgi-docs.readthedocs.io/en/latest/Configuration.html#environment-variables
if [ "${1:0:5}" == "uwsgi" ] && [ "$UWSGI_UNSET_ENVIRONMENT_VARIABLES" == "1" ]; then
    unset UWSGI_SOCKET UWSGI_HTTP_SOCKET UWSGI_MOUNT UWSGI_WORKERS
fi

exec "$@"
