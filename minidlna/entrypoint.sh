#!/bin/sh
MINIDLNA_PORT=${MINIDLNA_PORT:-8200}
MINIDLNA_MEDIA_DIR=${MINIDLNA_MEDIA_DIR:-/app/mnt/media}
MINIDLNA_FRIENDLY_NAME=${MINIDLNA_FRIENDLY_NAME:-MiniDLNA}
MINIDLNA_DB_DIR=${MINIDLNA_DB_DIR:-/app/local}
MINIDLNA_LOG_DIR=${MINIDLNA_LOG_DIR:-/app/log}
MINIDLNA_INOTIFY=${MINIDLNA_INOTIFY:-no}

video_types="mp4 m4v mkv avi mpg mpeg wmv asf mov rm rmvb webm ts"
audio_types="mp3 m4a wma wav ape flac mpa"
watch_types=${MINIDLNA_WATCH_TYPES:-$video_types $audio_types}
unset MINIDLNA_WATCH_TYPES

watch_enable=${MINIDLNA_WATCH_ENABLE:-true}
unset MINIDLNA_WATCH_ENABLE

watch_interval=${MINIDLNA_WATCH_INTERVAL:-60}
unset MINIDLNA_WATCH_INTERVAL

last_hash=
is_trap_rescan=

start_minidlna() {
    killall minidlnad 2>/dev/null
    # 链接日志输出到stdout
    local entrypoint_pid=$(ps | grep entrypoint | grep -v grep | head -n 1 | awk '{print $1}')
    ln -sf /proc/${entrypoint_pid}/fd/1 $MINIDLNA_LOG_DIR/minidlna.log

    /usr/sbin/minidlnad -v -r
}

trap_rescan() {
    is_trap_rescan=true
    log "trap rescan signal..."
    start_minidlna
}

log() {
    echo -e "\033[32m====================================\033[0m"
    echo -e "\033[32m$(date +%Y-%m-%d\ %H:%M:%S) $@\033[0m"
    echo -e "\033[32m====================================\033[0m"
}

check_change() {
    # 禁用文件监视则始终返回1
    [ "$watch_enable" != "true" ] && return 1
    # 已经在处理rescan信号
    [ "$is_trap_rescan" == "true" ] && return 1

    # echo $watch_filetypes 不要加双引号，这样可以去除前后空格和其它多余空格
    local types=$(echo $watch_types | tr "[:upper:]" "[:lower:]" | tr " " "|")
    local dir=$(realpath "$MINIDLNA_MEDIA_DIR")
    local cur_hash=$(find "$dir" -regextype posix-extended -iregex ".*\.($types)$" -ls | md5sum | awk '{print $1}')
    local pre_last_hash="$last_hash"
    last_hash="$cur_hash"
    [ "$pre_last_hash" != "$cur_hash" ] && return 0 || return 1
}

# 写入配置
> /etc/minidlna.conf
for v in $(set | sort | grep -e "^MINIDLNA_"); do
    name=$(echo $v | sed -r "s/MINIDLNA_(.*)=.*/\1/g")
    value=$(echo $v | sed -r "s/.*='(.*)'/\1/g")
    config_name=$(echo $name | tr '[:upper:]' '[:lower:]')
    echo "$name: $value"
    echo "$config_name=$value" >>/etc/minidlna.conf
done
echo "====="
echo "WATCH_TYPES: $watch_types"
echo "WATCH_ENABLE: $watch_enable"
echo "WATCH_INTERVAL: $watch_interval"

# rescan 信号
trap trap_rescan SIGUSR1

log "MiniDLNA will start..."
# 获取当前hash
check_change
start_minidlna

while :; do
    if check_change; then
        log "$MINIDLNA_MEDIA_DIR CHANGED. MiniDLNA will rescan..."
        start_minidlna
    fi
    is_trap_rescan=
    sleep $watch_interval &
    pid=$!
    wait $pid
    kill -9 $pid 1>/dev/null 2>&1
    sleep 1
done