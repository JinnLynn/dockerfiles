#!/usr/bin/env sh
#
# REF: https://github.com/tonistiigi/xx/blob/master/base/xx-info
# AUTHOR: JinnLynn <eatfishlin@gmail.com>

VERSION="2023.12.25"

# ===
set -e

SCRIPT_EXEC="$0"
SCRIPT_DIR="$(cd $(dirname $0); pwd)"
SCRIPT_BASENAME="$(basename $0 | awk -F. '{print $1}')"

: "${TARGETPLATFORM=}"
: "${TARGETOS=}"
: "${TARGETARCH=}"
: "${TARGETVARIANT=}"

: ${X_OS:=$(uname -s | tr [:upper:] [:lower:])}
: ${X_MARCH:=$(uname -m)}
: ${X_ARCH=}
: ${X_VARIANT=}
: ${X_DARCH:=}
: ${X_VENDOR:=unknown}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    X_VENDOR=$ID
fi

if [ -n "$TARGETPLATFORM" ]; then
    os="$(echo $TARGETPLATFORM | cut -d"/" -f1)"
    arch="$(echo $TARGETPLATFORM | cut -d"/" -f2)"
    if [ -n "$os" ] && [ -n "$arch" ]; then
        TARGETOS="$os"
        TARGETARCH="$arch"
        if [ "$arch" = "arm" ]; then
            case "$(echo $TARGETPLATFORM | cut -d"/" -f3)" in
                "v5")
                    TARGETVARIANT="v5"
                    ;;
                "v6")
                    TARGETVARIANT="v6"
                    ;;
                "v8")
                    TARGETVARIANT="v8"
                    ;;
                *)
                    TARGETVARIANT="v7"
                    ;;
            esac
        fi
    fi
fi

if [ -z "$TARGETARCH" ]; then
    case "$X_MARCH" in
        "x86_64")
            TARGETARCH="amd64"
            TARGETVARIANT=
        ;;
        "i386")
            TARGETARCH="386"
            TARGETVARIANT=
        ;;
        "aarch64"|"arm64")
            TARGETARCH="arm64"
            TARGETVARIANT=
        ;;
        "armv7l")
            TARGETARCH="arm"
            TARGETVARIANT="v7"
            if [ "$X_VENDOR" == "alpine" ] && [ -f /.armv6 ]; then
                # HACK:
                TARGETVARIANT="v6"
            fi
        ;;
        "armv6l")
            TARGETARCH="arm"
            TARGETVARIANT="v6"
        ;;
        "armv5l")
            TARGETARCH="arm"
            TARGETVARIANT="v5"
        ;;
        "riscv64")
            TARGETARCH="riscv64"
            TARGETVARIANT=
        ;;
        "ppc64le")
            TARGETARCH="ppc64le"
            TARGETVARIANT=
        ;;
        "s390x")
            TARGETARCH="s390x"
            TARGETVARIANT=
        ;;
    esac
fi

if [ -z "$TARGETOS" ]; then
    TARGETOS="linux"
fi

if [ "$TARGETARCH" = "arm" ] && [ -z "$TARGETVARIANT" ]; then
    TARGETVARIANT="v7"
fi

X_ARCH=$TARGETARCH
X_VARIANT=$TARGETVARIANT

case "$TARGETARCH" in
    "amd64")
        X_DEBIAN_ARCH="amd64"
        X_ALPINE_ARCH="x86_64"
        ;;
    "arm64")
        X_DEBIAN_ARCH="arm64"
        X_ALPINE_ARCH="aarch64"
        ;;
    "arm")
        X_DEBIAN_ARCH="armhf"
        X_ALPINE_ARCH="armv7"

        if [ "$TARGETVARIANT" = "v6" ]; then
            X_DEBIAN_ARCH="armel"
            X_ALPINE_ARCH="armhf"
        fi
        if [ "$TARGETVARIANT" = "v5" ]; then
            X_DEBIAN_ARCH="armel"
            X_ALPINE_ARCH="armel" # alpine does not actually support v5
        fi
        ;;
    "riscv64")
        X_DEBIAN_ARCH="riscv64"
        X_ALPINE_ARCH="riscv64"
        ;;
    "ppc64le")
        X_DEBIAN_ARCH="ppc64el"
        X_ALPINE_ARCH="ppc64le"
        ;;
    "s390x")
        X_DEBIAN_ARCH="s390x"
        X_ALPINE_ARCH="s390x"
        ;;
    "386")
        X_DEBIAN_ARCH="i386"
        X_ALPINE_ARCH="x86"
        ;;
esac

# =====

_help_extesions() {
    find ${SCRIPT_DIR} -name "${SCRIPT_BASENAME}-*" | while read line; do
        if [ -x "$line" ]; then
            bn="$(basename $line | awk -F. '{print $1}')"
            bn="${bn/${SCRIPT_BASENAME}-/}"
            printf "    %-15s %s\n" "$bn" "$($SCRIPT_EXEC $bn --xinfo-help 2>/dev/null)"
        fi
    done
}

help() {
    cat >&2 <<EOF
Usage: $(basename "$SCRIPT_EXEC") [COMMAND]

Commands:
    arch            Print target architecture for Docker
    variant         Print target variant if architecture is arm (eg. 7)
    march           Print target machine architecture, uname -m
    check ARCH [VARIANT]
                    Check target architecture
    env             Print X_* variables defining target environment
    alpine-arch     Print target architecture for Alpine package repositories
    debian-arch     Print target architecture for Debian/Ubuntu package repositories
    help            Print help

Arguments:
    --ARCH[variant]
                    eg. --arm7 --arm64

Extensions:
$(_help_extesions)

EOF
    exit 0
}

process_darch() {
    while [ ${#} -gt 0 ]; do
        case "$1" in
            "--${X_ARCH}${X_VARIANT}")
                shift 1
                X_DARCH="$1"
                ;;
        esac
        shift 1
    done
}

check() {
    local arch="$1"
    local variant="$2"
    if [ -z "$arch" ] || [ "$arch" != "$X_ARCH" ]; then
        exit 1
    fi
    if [ -n "$variant" ] && [ "$variant" != "$X_VARIANT" ]; then
        exit 1
    fi
    exit 0
}

# ===

# _semver_extract VERSION PART [DEFAUT]
# _semver_extract 1.1.2 major => 1
# _semver_extract 1.1 patch 2 => 2
_semver_extract() {
    _semver_part_check() {
        if echo "$1" | grep -Eq '^[0-9]+$'; then
            echo $1
        else
            echo $2
        fi
    }
    echo "$1" | while IFS=. read major minor patch; do
        case "$2" in
            "major")
                echo $(_semver_part_check $major ${3:-0})
                ;;
            "minor")
                echo $(_semver_part_check $minor ${3:-0})
                ;;
            "patch")
                echo $(_semver_part_check $patch ${3:-0})
                ;;
        esac
    done
}

# 版本号比较
# 0: $1 = $2
# 4[G]: $1 > $2
# 5[L]: $1 < $2
_util_version_compare() {
    if [ "$1" == "$2" ]; then
        return 0
    fi
    for p in major minor patch; do
        if [ "$(_semver_extract "$1" $p)" -gt $(_semver_extract "$2" $p) ]; then
            return 4
        fi
        if [ "$(_semver_extract "$1" $p)" -lt $(_semver_extract "$2" $p) ]; then
            return 5
        fi
    done
    return 0
}

# 版本号检查
# $1 被比较的 如系统安装的软件
# 如
# 1.2.3 1       => 0
# 1.2.3 1.2     => 0
# 1.2.3 2       => 1
# 1.2   1.2.3   => 1
_util_version_check() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        return 1
    fi
    if [ "$1" == "$2" ]; then
        return 0
    fi
    for p in major minor patch; do
        ver1_part=$(_semver_extract "$1" $p)
        ver2_part=$(_semver_extract "$2" $p $ver1_part)

        if [ "$ver1_part" != "$ver2_part" ]; then
            return 1
        fi
    done
    return 0
}
# ===

sub_cmd=
# ubuntu下sh指向dash dash不支持${1:0:1}表达式
if [ "$(echo $1 | cut -c1)" != "-" ]; then
    sub_cmd=$1
    if [ ${#} -gt 0 ]; then
        shift 1
    fi
fi

case "$sub_cmd" in
    "check")
        check $@
        ;;
    "os")
        echo ${X_OS}
        ;;
    "vendor")
        echo ${X_VENDOR}
        ;;
    "arch")
        process_darch $@
        echo ${X_DARCH:="$X_ARCH"}
        ;;
    "variant")
        echo "$X_VARIANT"
        ;;
    "march")
        echo "$X_MARCH"
        ;;
    "env")
        process_darch $@
        echo "X_OS=${X_OS}"
        echo "X_VENDOR=${X_VENDOR}"
        echo "X_ARCH=${X_ARCH}"
        echo "X_VARIANT=${X_VARIANT}"
        echo "X_MARCH=${X_MARCH}"
        echo "X_DARCH=${X_DARCH}"
        echo "TARGETOS=${TARGETOS}"
        echo "TARGETARCH=${TARGETARCH}"
        echo "TARGETVARIANT=${TARGETVARIANT}"
        ;;
    "alpine-arch")
        echo "$X_ALPINE_ARCH"
        ;;
    "debian-arch")
        echo "$X_DEBIAN_ARCH"
        ;;
    "")
        process_darch $@
        echo ${X_DARCH:="${X_ARCH}${X_VARIANT}"}
        ;;
    "help")
        help
        ;;
    "version-compare")
        if [ "$1" = "--strict" ]; then
            shift 1
            _util_version_compare "$@"
        else
            _util_version_check "$@"
        fi
        ;;
    *)
        for s in "" ".sh"; do
            exec_f="${SCRIPT_DIR}/xinfo-${sub_cmd}${s}"
            if [ -x "$exec_f" ]; then
                export XINFO_EXEC=${SCRIPT_EXEC}
                exec "${exec_f}" "$@"
            fi
        done
        help >/dev/stderr
        exit 0
        ;;
esac
