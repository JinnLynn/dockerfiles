#!/usr/bin/env sh
#
# CPU架构信息，默认:
# alpine环境等于`apk --print-arch`: x86 x86_64 armhf aarch64
# debian/ubuntu/raspbian环境等于`dpkg --print-architecture`: i386 amd64 armhf arm64
#
# 也可使用GO语言的架构描述或自定义描述
#
# AUTHOR:   JinnLynn <eatfishlin@gmail.com>
# DATE:     2018-09-12
#
ARCH=x86_64

which dpkg 1>/dev/null 2>&1 && ARCH=$(dpkg --print-architecture)
which apk 1>/dev/null 2>&1 && ARCH=$(apk --print-arch)

[ -z "$ARCH" ] && ARCH="unknown"

# 是否使用GO语言的架构描述
USE_GO_ARCH_TPL=

# 自定义架构描述
ARCH_386=
ARCH_AMD64=
ARCH_ARM=
ARCH_ARM64=

exit_err() {
    [ -n "$@" ] && echo "$@" >&2
    exit 1
}

# 使用GO语言的架构描述
# REF: https://golang.org/doc/install/source#environment
arch_go_tpl() {
    ARCH_386="386"
    ARCH_AMD64="amd64"
    ARCH_ARM="arm"
    ARCH_ARM64="arm64"
}

arch_mark() {
    local mark=$ARCH
    [ -n "$USE_GO_ARCH_TPL" ] && arch_go_tpl
    case "$ARCH" in
        i386|x86 )
            [ -n "$ARCH_386" ] && mark=$ARCH_386
            ;;
        amd64|x86_64 )
            [ -n "$ARCH_AMD64" ] && mark=$ARCH_AMD64
            ;;
        armhf )
            [ -n "$ARCH_ARM" ] && mark=$ARCH_ARM
            ;;
        arm64|aarch64 )
            [ -n "$ARCH_ARM64" ] && mark=$ARCH_ARM64
            ;;
    esac
    echo $mark
}

check() {
    [ -z "$1" ] && exit_err "ERROR: arch mark missing."
    [ "$(arch_mark)" == "$1" ] && exit 0 || exit 1
}

print() {
    echo "$@$(arch_mark)"
}

help() {
cat <<EOF
USAGE: $0 [COMMAND] [OPTION]

Command:
    print           输出arch，可通过参数自定义
    check ARCH      检测arch
    help            Help

Options:
    --go                使用GO语言的架构描述
                        有此参数时将忽略下列自定义输出
    --386 MARK          自定义386/i386/x86架构输出
    --amd64 MARK        自定义amd64/x86_64架构输出
    --arm MARK          自定义arm/armhf架构输出
    --arm64 MARK        自定义aarch64/arm64架构输出
EOF
}

COMMAND="print"
if [ ${#} -gt 0 ]; then
    cmd=$1
    # debian/ubuntu/raspbian下sh实际为dash不支持${cmd:0:1}形式的切割字符串语法
    # REF: https://wiki.ubuntu.com/DashAsBinSh
    if [ "$(echo $cmd | awk '{ s=substr($0, 1, 1); print s; }')" != "-" ]; then
        COMMAND=$cmd
        shift 1
    fi
fi

while [ ${#} -gt 0 ]; do
    case "$1" in
        --go )
            USE_GO_ARCH_TPL=true
            ;;
        --386 )
            shift 1
            ARCH_386=$1
            ;;
        --amd64 )
            shift 1
            ARCH_AMD64=$1
            ;;
        --arm )
            shift 1
            ARCH_ARM=$1
            ;;
        --amd64 )
            shift 1
            ARCH_AMD64=$1
            ;;
        -* )
            exit_err "ERROR OPTION: $1"
            ;;
        * )
            # 参数结束
            break
            ;;
    esac
    shift 1
done

case "$COMMAND" in
    "help" )
        help
        ;;
    "print" )
        print $@
        ;;
    "check" )
        check "$1"
        ;;
    * )
        exit_err "ERROR COMMAND: $COMMAND"
esac
