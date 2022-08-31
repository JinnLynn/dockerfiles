
set -e

if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
    exec 3>&1
else
    exec 3>/dev/null
fi

echo_msg() {
    echo >&3 "$(basename $0): $@"
}

# 以空格或逗号分割字符串并以指定字符串合并
# 默认以空格合并
join() {
    [[ -z "$1" ]] && return 0
    local j=${2:-" "}
    echo "$1" | sed "s/[ ,]\{1,\}/${j}/g" | sed "s/\(^${j}\{1,\}\|${j}\{1,\}$\)//g"
}
