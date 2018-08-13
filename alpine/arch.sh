#!/bin/sh
#
# CPU架构信息，默认使用alpine的架构描述: x86 x86_64 armhf aarch64
# 也可使用GO语言的架构描述或自定义各架构描述
# 
# AUTHOR:   JinnLynn <eatfishlin@gmail.com>
# DATE:     2018-06-13
#

ARCH=$(apk --print-arch)

# 是否使用GO语言的架构描述
USE_GO_ARCH_TPL=

# 自定义架构描述
ARCH_X86=
ARCH_X86_64=
ARCH_ARMHF=
ARCH_AARCH64=

exit_err() {
    [ -n "$@" ] && echo "$@" >&2
    exit 1
}

# 使用GO语言的架构描述
# REF: https://golang.org/doc/install/source#environment
arch_go_tpl() {
    ARCH_X86="386"
    ARCH_X86_64="amd64"
    ARCH_ARMHF="arm"
    ARCH_AARCH64="arm64"
}

arch_mark() {
    local mark=$ARCH
    [ -n "$USE_GO_ARCH_TPL" ] && arch_go_tpl
    case "$ARCH" in
        "x86" )
            [ -n "$ARCH_X86" ] && mark=$ARCH_X86
            ;;
        "x86_64" )
            [ -n "$ARCH_X86_64" ] && mark=$ARCH_X86_64
            ;;
        "armhf" )
            [ -n "$ARCH_ARMHF" ] && mark=$ARCH_ARMHF
            ;;
        "aarch64" )
            [ -n "$ARCH_AARCH64" ] && mark=$ARCH_AARCH64
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
    --x86 MARK          自定义x86架构输出
    --x86_64 MARK       自定义x86_64架构输出
    --armhf MARK        自定义arm/armhf架构输出
    --aarch64 MARK      自定义aarch64/arm64架构输出
EOF
}

COMMAND="print"
if [ ${#} -gt 0 ]; then
    cmd=$1
    if [ "${cmd:0:1}" != "-" ]; then
        COMMAND=$cmd
        shift 1
    fi
fi

while [ ${#} -gt 0 ]; do
    case "$1" in
        --go )
            USE_GO_ARCH_TPL=true
            ;;
        --x86 )
            shift 1
            ARCH_X86=$1
            ;;
        --x86_64 )
            shift 1
            ARCH_X86_64=$1
            ;;
        --armhf )
            shift 1
            ARCH_ARMHF=$1
            ;;
        --aarch64 )
            shift 1
            ARCH_AARCH64=$1
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
