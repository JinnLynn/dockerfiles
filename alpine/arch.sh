#!/usr/bin/env sh
#
# CPU架构信息
# 386   amd64   arm     arm64     默认: GO语言的架构描述
#                                 原生:
# x86   x86_64  armhf   aarch64     alpine: 等同于于`apk --print-arch`
# i386  amd64   armhf   arm64       debian/ubuntu/raspbian: 等同于`dpkg --print-architecture`
#
# 也可自定义描述
#
# AUTHOR:   JinnLynn <eatfishlin@gmail.com>
# DATE:     2018-09-26
#

VERSION=2018.09.26
# 架构的系统原生描述
ARCH=
# 是否使用当前环境原生输出
USE_RAW=
# 要比较的字符串
CHECK_ARCH=

which dpkg 1>/dev/null 2>&1 && ARCH=$(dpkg --print-architecture)
which apk 1>/dev/null 2>&1 && ARCH=$(apk --print-arch)

[ -z "$ARCH" ] && ARCH="unknown"

# 默认使用GO语言的架构描述
# REF: https://golang.org/doc/install/source#environment
ARCH_386="386"
ARCH_AMD64="amd64"
ARCH_ARM="arm"
ARCH_ARM64="arm64"

exit_err() {
    [ -n "$@" ] && echo "$@" >&2
    exit 1
}

arch_mark() {
    [ -n "$USE_RAW" ] && {
        # 输出环境原生描述
        echo $ARCH
        return 0
    }
    local mark=$ARCH
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
    if [ "$CHECK_ARCH" = "check_" ]; then
        exit_err "ERROR: arch mark missing."
        exit 1
    fi
    [ "check_$(arch_mark)" = "$CHECK_ARCH" ]
    exit $?
}

print() {
    echo "$1$(arch_mark)"
}

help() {
cat <<EOF
USAGE: $0 [OPTION]

系统架构，默认使用GO语言的架构描述。

Options:
    --check|-c MARK     比较检测arch
    --raw|-r            使用环境原生的架构描述
                        有此参数时将忽略下列自定义输出
    --386 MARK          自定义386/i386/x86架构输出
    --amd64 MARK        自定义amd64/x86_64架构输出
    --arm MARK          自定义arm/armhf架构输出
    --arm64 MARK        自定义aarch64/arm64架构输出

    --help|-h           帮助
    --version|-v        版本
EOF
}

while [ ${#} -gt 0 ]; do
    case "$1" in
        --version|-v )
            echo "arch v$VERSION"
            exit 0
            ;;
        --help|-h )
            help
            exit 0
            ;;
        --check|-c )
            shift 1
            CHECK_ARCH=check_$1
            ;;
        --raw|-r )
            USE_RAW=true
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

if [ -n "$CHECK_ARCH" ]; then
    check
fi

print "$@"
