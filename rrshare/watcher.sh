#!/usr/bin/env sh

PASSWD=${RR_UNLOCK_PWD}
MAX_WAIT=${RR_MAX_WAIT:-600}
CONF_PATH=${RR_CONF_PATH:-/app/opt/rrshareweb/conf}

URL="http://127.0.0.1:$(cat $CONF_PATH/rrshare.json | jq .port)"
# URL="https://rr.me.afvisual.com"
COOKIE_FILE="/tmp/cookie.txt"
LAST_TASK_EXISTS=$(date "+%s")

log() {
    echo [$(date "+%Y-%m-%d %H:%M:%S")] "$@"
}

fetch() {
    curl -H 'Sec-Fetch-Site: same-origin' \
         -H 'Sec-Fetch-Mode: cors' \
         -H 'Sec-Fetch-Dest: empty' \
         --cookie ${COOKIE_FILE} --cookie-jar ${COOKIE_FILE} \
         --connect-timeout 2 \
         -sL \
         $URL/api/$1
}

post() {
    echo $2
    curl -H 'Sec-Fetch-Site: same-origin' \
         -H 'Sec-Fetch-Mode: cors' \
         -H 'Sec-Fetch-Dest: empty' \
         -H 'Content-Type: application/x-www-form-urlencoded' \
         --cookie ${COOKIE_FILE} --cookie-jar ${COOKIE_FILE} \
         --data "$2" \
         $URL/api/$1
}

check() {
    local ret

    supervisorctl status rrshare | grep -q RUNNING || {
        # rrshare非运行状态
        # NOTE: 刷新最后存在任务时间，防止rrshare启动后错误判断为长时间无任务运行
        LAST_TASK_EXISTS=$(date "+%s")
        return
    }

    fetch "unlock?passwd=$PASSWD" | jq -e '.code != 200' >/dev/null && {
        # 解锁失败
        log "Unlock fail."
        return
    }

    fetch workingtask | jq -e '.tasks|length > 0' >/dev/null && {
        # 有下载任务
        # log "task working..."
        LAST_TASK_EXISTS=$(date "+%s")
        return
    }

    # 没有任务在下载
    local passed=$(($(date "+%s") - LAST_TASK_EXISTS))
    [ $passed -le $MAX_WAIT ] && {
        # 无下载任务时间未到等待时间
        # log "no task working. ${passed}s"
        return
    }

    log "no task working, ${passed}s, rrshare will be stopped."

    # 删除已完成任务
    # NOTE: 现不使用接口，而在在数据库中直接删除， 见下
    # local ids
    # ret=$(fetch finishedtask | jq -r '[.tasks[].file_id]|join("\",\"")')
    # [ -n "$ret" ] && {
    #     post deletetask "ids=[\"$ret\"]&delfile=0"
    # }

    # 获取下载目录 准备删除mask文件
    # NOTE: 必须在stop rrshare前操作
    local save_path=$(fetch getsetting | jq -r .save_path)

    # sleep 2
    log $(supervisorctl stop rrshare)

    log "clean up finished task infomation."
    # 删除数据库中的任务，防止重新启动后又开始下载
    sqlite3 $CONF_PATH/rrshare.db "DELETE FROM task WHERE 1=1"
    # 删除mask
    [ -d "$save_path" ] && {
        rm -rf $save_path/mask*
    }
}

ttt() {
    PASSWD=9527
    fetch "unlock?passwd=$PASSWD" | jq -e '.code != 200' >/dev/null && {
        # 解锁失败
        log "Unlock fail."
        return
    }

    local ids
    ret=$(fetch finishedtask | jq -r '[.tasks[].file_id]|join("\",\"")')
    [ -n "$ret" ] && {
        post deletetask "ids=[\"$ret\"]&delfile=0"
    }

    local save_path=$(fetch getsetting | jq -r .save_path)
    echo $save_path
}



log "CONF PATH: $CONF_PATH"
log "URL:       $URL"
log "UNLOCK:    $PASSWD"
log "MAX WAIT:  $MAX_WAIT"

# ttt

while :; do
    check
    sleep 5
done
