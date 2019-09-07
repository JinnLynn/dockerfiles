#!/usr/bin/env sh
CONFIG_DIR=${BYPY_CONFIG_DIR:-""}
# 同步类型 up down
SYNC_TYPE=${BYPY_SYNC_TYPE:-up}
# 同步间隔
SYNC_INTERVAL=${BYPY_SYNC_INTERVAL:-6h}
# 同步的本地目录列表
# 无论是向上同步还是向下同步，百度云盘上的目录都以本地目录名为准
# 如 同步本地目录 /mnt/media 则百度盘上的目录为 /apps/bypy/media
SYNC_DIRS=${BYPY_SYNC_DIRS:-""}
# 同步时是否删除源不存在的文件
SYNC_DELETE=${BYPY_SYNC_DELETE-true}
# 同步命令参数
SYNC_OPTS=${BYPY_SYNC_OPTS:-"-vvvv"}

is_trap_sync=

BYPY="bypy"
[[ -n "$CONFIG_DIR" ]] && BYPY="$BYPY --config-dir $CONFIG_DIR"

echo_line() {
    echo "========================================"
}

log() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) $@"
}

log_line() {
    log $@
    echo_line
}

backup() {
    local cfg_dir="$CONFIG_DIR"
    [[ -z "$cfg_dir" ]] && cfg_dir=$HOME/.bypy
    bak_dir="$cfg_dir/bak/$(date +%Y%m%d%H%M%S)"

    mkdir -p $bak_dir
    cp $cfg_dir/*.* $bak_dir/
    # 删除旧的备份
    find $(dirname $bak_dir) -maxdepth 1 -mindepth 1 -type d -mtime +2 -exec rm -rf {} \;
}

pre_sync() {
    backup
    echo_line
    log "Sync $SYNC_TYPE start..."
    $BYPY info
    echo_line
}

post_sync() {
    echo
    echo_line
    $BYPY info
    log "Sync $SYNC_TYPE finished, wait $SYNC_INTERVAL for next."
    echo_line
    echo
}

sync() {
    pre_sync

    for path in $SYNC_DIRS; do
        name=$(basename $path)

        # 只处理目录
        if [ ! -d "$path" ]; then
            log_line "ERROR: $d is not a directory." 2>&1
            continue
        fi


        if [ "$SYNC_TYPE" == 'down' ]; then
            log_line "SYNC DOWN: /app/bypy/$name => $path"
            $BYPY $SYNC_OPTS syncdown $name $path $SYNC_DELETE
        else
            log_line "SYNC UP: $path => /app/bypy/$name"
            $BYPY $SYNC_OPTS syncup $path $name $SYNC_DELETE
        fi
    done

    post_sync
}

trap_sync() {
    echo_line
    log "trap sync signal..."
    echo_line
    echo
    is_trap_sync=true
    sync
}

echo "SYNC_TYPE:     $SYNC_TYPE"
echo "SYNC_DIRS:     $SYNC_DIRS"
echo "SYNC_INTERVAL: $SYNC_INTERVAL"
echo "CONFIG_DIR:    $CONFIG_DIR"
echo "SYNC_OPTS:     $SYNC_OPTS"
echo "SYNC_DELETE:   $SYNC_DELETE"

if [ -z "$SYNC_DIRS" ]; then
    log_line "ERROR: \$SYNC_DIRS is empty." 2>&1
    exit 1
fi

# sync 信号
trap trap_sync SIGUSR1

while :; do
    if [ "$is_trap_sync" != "true" ]; then
        sync
    fi
    is_trap_sync=
    sleep $SYNC_INTERVAL &
    pid=$!
    wait $pid
    kill -9 $pid 1>/dev/null 2>&1
done
