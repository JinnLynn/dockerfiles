SPLITLINE="================================================="

echo_red() {
    echo -e "\033[31m$@\033[0m"
}

echo_green() {
    echo -e "\033[32m$@\033[0m"
}

echo_split() {
    local start=
    if [[ -n "$@" ]]; then
        echo "$SPLITLINE"
        echo "\n$@"
        start="\n"
    fi
    echo "$start$SPLITLINE"
}

echo_red_split() {
    echo_red $(echo_split $@)
}

echo_green_split() {
    echo_green $(echo_split $@)
}

echo_err() {
    echo_red $@ >&2
}

exit_err() {
    [[ -n "$@" ]] && echo_err "$@\n"
    usage >&2
    popd >/dev/null
    exit 1
}

exit_ok() {
    [[ -n "$@" ]] && echo_green $@
    popd >/dev/null
    exit 0
}

is_true() {
    [[ -z "$1" || "$1" == "false" ]] && return 1 || return 0
}

# 查找包含Dockerfile或Dockerfile.$ARCH的目录
# $1 要查找的路径 默认: .
# $2 查找最大层 默认: 3
find_dirs() {
    local path=.
    local depth=3
    [[ -n "$1" ]] && path="$1"
    [[ -n "$2" ]] && depth=$2

    IFS=$'\n'
    local dirs=$(find "$path" -maxdepth $depth ! -ipath '.\/[~\._]*' \( -iname "Dockerfile" -o -iname "Dockerfile.$ARCH" \) | sed 's|\.\/||' | xargs -n1 dirname 2>/dev/null | sort -u)
    unset IFS

    echo $dirs
}

run_cmd() {
    is_true $CMD_DRY_RUN && echo "$@" && return 0
    $@
}

arch_mark() {
    local arch=$1
    arch=${arch:-$(uname -m)}
    case "$arch" in
        x86_64 )
            echo "x86_64"
            ;;
        armv* )
            echo "armhf"
            ;;
        *)
            echo $arch
            ;;
    esac
}

arch_go_mark() {
    local arch=$(arch_mark $@)
    case "$arch" in
        x86_64 )
            echo "amd64"
            ;;
        armhf )
            echo "arm"
            ;;
        *)
            echo $arch
            ;;
    esac
}
