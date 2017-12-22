#!/usr/bin/env sh
INTERVAL=${BYPY_INTERVAL:-6h}
SYNCDIR=${BYPY_SYNCDIR:-/app/mnt}

PROCESSES=${BYPY_PROCESSES:-1}
DELETE_REMOTE=${BYPY_DELETE_REMOTE-true}
DEBUG="$BYPY_DEBUG"
# 同步目录最小大小，只有大于该值才同步，防止挂载失败
SYNCDIR_MIN_SIZE=${BYPY_SYNCDIR_MIN_SIZE:-1024}

is_trap_sync=

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
    local bak_dir="/root/.bypy/bak/$(date +%Y%m%d%H%M%S)"
    mkdir -p $bak_dir
    cp /root/.bypy/*.* $bak_dir/
    # 删除久的备份
    find $(dirname $bak_dir) -maxdepth 1 -mindepth 1 -type d -mtime +2 -exec rm -rf {} \;
}

pre_sync() {
    backup
    echo_line
    log "Syncup start..."
    bypy info
    echo_line
}

post_sync() {
    backup
    echo
    echo_line
    bypy info
    log "Syncup finished, wait $INTERVAL for next."
    echo_line
    echo
}

sync() {
    cd $SYNCDIR

    opts="-vvvv"
    [ -n "$DEBUG" ] && opts="$opts -d"
    [ "$PROCESSES" -ge 2 ] && opts="$opts --processes $PROCESSES"
    del_remote=""
    [ -n "$DELETE_REMOTE" ] && del_remote="true"

    pre_sync

    # 各个文件目录分别处理，防止个别目录未成功挂载内容
    for d in $(ls); do
        echo
        # 文件
        if [ ! -d "$d" ]; then
            log_line "UPLOAD: $(pwd)/$d => /app/bypy/$d"
            bypy $opts upload $d $d true
            continue
        fi

        # 目录
        used=$(du -s "$d" 2>/dev/null | awk '{print $1}')
        if [ "$used" -lt $SYNCDIR_MIN_SIZE ] 2>/dev/null; then
            # 占用空间过小，可能没挂载内容，跳过
            log_line "SKIPPED: $(pwd)/$d disk space used only ${used}K."
            continue
        fi
        log_line "SYNCUP: $(pwd)/$d => /app/bypy/$d"
        bypy $opts syncup $d $d $del_remote
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

echo "SYNCDIR: $SYNCDIR"
echo "INTERVAL: $INTERVAL"
echo "PROCESSES: $PROCESSES"
echo "DELETE_REMOTE: $DELETE_REMOTE"
echo "SYNCDIR_MIN_SIZE: ${SYNCDIR_MIN_SIZE}"
echo "DEBUG: $DEBUG"

if [ ! -d "$SYNCDIR" ]; then
    echo_line
    log "ERROR: $SYNCDIR is not a directory." 2>&1
    exit 1
fi

# sync 信号
trap trap_sync 60

while :; do
    if [ "$is_trap_sync" != "true" ]; then
        sync
    fi
    is_trap_sync=
    sleep $INTERVAL &
    pid=$!
    wait $pid
    kill -9 $pid 1>/dev/null 2>&1
done
