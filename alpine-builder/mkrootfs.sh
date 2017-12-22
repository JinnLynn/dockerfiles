#!/usr/bin/env bash
set -e

ALPINE_RELEASE=${ALPINE_RELEASE:-edge}
ALPINE_ARCH=${ALPINE_ARCH:-x86_64 armhf}
ALPINE_MIRROR=${ALPINE_MIRROR:-https://mirrors.ustc.edu.cn/alpine/}
ALPINE_LATEST=${ALPINE_LATEST:-}
ALPINE_OUTPUT=${ALPINE_OUTPUT:-}

BASE_DIR=$(realpath $(dirname $0))
TPL_DIR=${TPL_DIR:-/app/etc}

VALID_ARCH=(aarch64 armhf ppc64le s390x x86 x86_64)
APP_DIRS="bin etc opt mnt local log run tmp var"

echo_err() {
    echo -e "\033[31m$@\033[0m" >&2
}

exit_err() {
    [[ -n "$@" ]] && echo_err "$@\n"
    usage >&2
    exit 1
}

usage() {
    echo "USAGE: "
}

check_param() {
    :
}

is_true() {
    [[ -z "$1" || "$1" == "false" ]] && return 1 || return 0
}

download_info() {
    tmp=$(mktemp)
    rel_yaml=$1/latest-releases.yaml
    {
        curl -sSL "$rel_yaml" | grep "flavor: alpine-minirootfs" -C 6 | while read line; do
            for s in version file date time size sha256; do
                if echo $line | grep -q "$s: "; then
                    echo "# $line"
                    echo "latest_$s=$(echo $line | awk '{print $2}')"
                fi
            done
        done
    } >$tmp
    # echo "Latest Info file: $tmp" >&2
    echo $tmp
}

is_arch_valid() {
    for a in ${VALID_ARCH[@]}; do
        [[ "$1" == "$a" ]] && return 0
    done
    return 1
}

build() {
    release=${1#v}
    arch=$2

    is_arch_valid $arch || exit_err "arch error: $arch"

    branch=$release
    if [[ $branch != "edge" && $branch != "latest-stable" ]]; then
        branch="v$release"
    fi

    rel_remote_dir="$MIRROR/$branch/releases/$arch"
    rel_local_dir="$OUTPUT/$release"
    rootfs_file="$rel_local_dir/rootfs-$arch.tar.xz"
    info_file="$rootfs_file.txt"
    init_script_file="$rel_local_dir/init-$arch"

    dockerfile="$rel_local_dir/Dockerfile"
    [[ "$arch" != "x86_64" ]] && dockerfile="$dockerfile.$arch"

    # rm -rf $rootfs_file $info_file $dockerfile
    # echo "BUILD: $release $arch"
    # echo "REMOTE: $rel_remote_dir"
    # echo "LOCAL: $rel_local_dir $rootfs_file $info_file $dockerfile"
    # return 0
    (
        # 获取在线信息
        source $(download_info $rel_remote_dir)
        # 信息下载失败
        if [[ -z "$latest_sha256" ]]; then
            exit_err "FAILED: Fetch Alpine-$release-$arch info."
        fi

        if is_true $FORCE; then
            rm -f $rootfs_file $info_file $dockerfile $init_script_file
        fi

        # 载入现有rootfs信息
        [[ -f "$info_file" ]] && source "$info_file"

        if [[ "$latest_sha256" == "${current_sha256:-}" ]]; then
            echo "SKIPPED: $release-$arch rootfs unchanged."
            return 0
        fi

        # =====
        # 与在线信息不同 重新生成

        mkdir -p "$rel_local_dir"

        # 下载rootfs
        rootfs_remote=$rel_remote_dir/$latest_file
        curl -sSL -o "$rootfs_file" $rootfs_remote || exit_err "FAILED: $release-$arch, Download rootfs file from $rootfs_remote."

        # copy init script
        cp $TPL_DIR/init.tpl $init_script_file
        sed -i"" "s/__VERSION__/$latest_version/g" $init_script_file
        sed -i"" "s/__BRANCH__/$branch/g" $init_script_file
        sed -i"" "s/__ARCH__/$arch/g" $init_script_file
        sed -i"" "s/__MIRROR__/${MIRROR//\//\\\/}/g" $init_script_file
        sed -i"" "s/__TIMEZONE__/${TIMEZONE//\//\\/}/g" $init_script_file
        app_dirs=""
        if is_true $MAKE_APP_DIRS; then
            app_dirs="$APP_DIRS"
        fi
        sed -i"" "s/__APP_DIRS__/${app_dirs//\//\\/}/g" $init_script_file
        chmod +x $init_script_file

        # generate dockerfile
        cp $TPL_DIR/Dockerfile.tpl $dockerfile
        sed -i"" "s/__ARCH__/$arch/g" $dockerfile

        # save info
        {
            echo "current_version=$latest_version"
            echo "current_build=\"$latest_date $latest_time\""
            echo "current_sha256=$latest_sha256"
            echo "download_time=\"$(date +%Y-%m-%d\ %H:%M:%S)\""
        } >$info_file

        echo "SUCCESSED: $release-$arch"
    )
}

build_latest() {
    [[ -z "$LATEST" ]] && return
    for a in ${ARCH[@]}; do
        tag="alpine:$LATEST"
        dockerfile="Dockerfile"
        if [[ "$a" != "x86_64" ]]; then
            tag="alpine:$arch-$LATEST"
            dockerfile="$dockerfile.$arch"
        fi
        echo "FROM jinnlynn/$tag" >$OUTPUT/$dockerfile
    done
}

while (( ${#} )); do
    case "$1" in
        --latest|-l)
            shift 1
            LATEST=$1
            ;;
        --release|-r)
            shift 1
            RELEASE="$RELEASE $1"
            ;;
        --arch|-a)
            shift 1
            ARCH="$ARCH $1"
            ;;
        --mirror|-m)
            shift 1
            MIRROR=$1
            ;;
        --timezone|-t)
            shift 1
            TIMEZONE=$1
            ;;
        --disable-app-dirs)
            MAKE_APP_DIRS=false
            ;;
        --force|-f)
            FORCE=true
            ;;
        --output|-o)
            shift 1
            OUTPUT=$1
            ;;
        -* )
            exit_err "错误的选项: $1"
            ;;
        * )
            # 参数结束
            break
            ;;
    esac
    shift 1
done

MIRROR=${MIRROR:-$ALPINE_MIRROR}
MIRROR=${MIRROR%/}
# TIMEZONE 允许为空
TIMEZONE=${TIMEZONE-Asia/Shanghai}
MAKE_APP_DIRS=${MAKE_APP_DIRS:-true}
FORCE=${FORCE:-false}
OUTPUT=${OUTPUT:-$ALPINE_OUTPUT}

RELEASE=${RELEASE:-$ALPINE_RELEASE}
RELEASE=($RELEASE)

# LATEST允许为空
LATEST=${LATEST-$ALPINE_LATEST}
# 如果latest不存在 则默认release中的第一个值
[[ -z "$LATEST" ]] && LATEST=${RELEASE[0]}
# 如果latest不在release中 添加
if [[ -n "$LATEST" ]]; then
    LATEST=${LATEST#v}
    echo "${RELEASE[@]}" | grep -q "$LATEST" || RELEASE="$RELEASE $LATEST"
fi

ARCH=${ALPINE_ARCH:-x86_64 armhf}
ARCH=($ARCH)

main() {
    echo "RELEASE:  ${RELEASE[@]}"
    echo "LATEST:   $LATEST"
    echo "ARCH:     ${ARCH[@]}"
    echo "MIRROR:   $MIRROR"
    echo "TIMEZONE: $TIMEZONE"
    echo "MK_DIRS:  $MAKE_APP_DIRS"
    is_true $MAKE_APP_DIRS && echo "APP_DIRS: $APP_DIRS"
    echo "FORCE:    $FORCE"
    echo "OUTPUT:   $OUTPUT"
    echo "===== ====="
    for r in ${RELEASE[@]}; do
        for a in ${ARCH[@]}; do
            build $r $a
        done
    done

    build_latest
}

main
