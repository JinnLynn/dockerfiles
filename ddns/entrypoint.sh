#!/usr/bin/env bash
# dnspod token
DDNS_TOKEN=${DDNS_TOKEN:-}
DDNS_DOMAIN=${DDNS_DOMAIN:-}
DDNS_IP_SERVICE=${DDNS_IP_SERVICE:-http://ip.3322.net}
DDNS_CHECK_INTERVAL=${DDNS_CHECK_INTERVAL:-60}

DDNS_IP=${DDNS_IP:-}

CONNECT_TIMEOUT=5
SILENT=false
REPEAT=false

is_ip() {
    # [ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ] && return 0 || return 1
    return 0
}

get_ip() {
    local ip=$1
    [ -n "$ip" ] && {
        is_ip $ip || {
            log_err "Invalid IP address: $ip"
            return 1
        }
    } || {
        ip=$(curl -s $DDNS_IP_SERVICE)
        is_ip $ip || {
            log_err "fetch current ip fail."
            return 1
        }
    }
    echo $ip
}

log() {
    echo $(date +%Y-%m-%d\ %H:%M:%S) $@
}

log_err() {
    log $@ 1>&2
}

jq_parse() {
    echo "$1" | jq -r "$2" 2>/dev/null
}

try_update() {
    sub_domain=$(echo $DDNS_DOMAIN | cut -d '.' -f 1)
    domain=$(echo $DDNS_DOMAIN | cut -d '.' -f 2-)
    common_params="login_token=$DDNS_TOKEN&format=json&domain=$domain&sub_domain=$sub_domain"

    curl_opt="-s -X POST --connect-timeout ${CONNECT_TIMEOUT:-5}"
    # ddns ip
    ip=$(get_ip $DDNS_IP)
    [ -z "$ip" ] && return 1

    # 获取sub_domain record id
    res=$(curl $curl_opt https://dnsapi.cn/Record.List -d "$common_params")
    code=$(jq_parse "$res" ".status.code | tonumber")
    [ "$code" != 1 ] && {
        log_err "Fetch host info fail:" $(jq_parse "$res" .status.message)
        return 1
    }

    record_ip=$(jq_parse "$res" ".records[0].value")
    record_id=$(jq_parse "$res" ".records[0].id | tonumber")

    # 记录已经与当前IP相同
    [ "$ip" == "$record_ip" ] && {
        [ "$SILENT" == false ] && log "DDNS domain $DDNS_DOMAIN[$ip] unchanged."
        return
    }

    # 更新
    res=$(curl $curl_opt "https://dnsapi.cn/Record.Ddns" -d "$common_params&record_id=$record_id&value=$ip&record_line=默认")
    code=$(jq_parse "$res" ".status.code | tonumber")
    [ "$code" != 1 ] && {
        log_err "Update DDNS Hostname $DDNS_DOMAIN fail:" $(jq_parse "$res" .status.message)
        return 1
    }

    log "DDNS Hostname $DDNS_DOMAIN[$ip] updated."
}

trap_update() {
    log "Trap update signal..."
    try_update
}

while (( ${#} )); do
    case "$1" in
        --token|-t )
            shift 1
            DDNS_TOKEN=${1:-}
            ;;
        --domain|-d )
            shift 1
            DDNS_DOMAIN=${1:-}
            ;;
        --ip )
            shift 1
            DDNS_IP=${1:-}
            ;;
        --slient )
            SILENT=true
            ;;
        --repeat )
            REPEAT=true
            ;;
        --help|-h )
            echo "USAGE: $0 [-t|--token TOKEN] [-d|--domain DOMAIN] [--ip IP] [--repeat] [--slient]"
            exit 0
            ;;
        -* )
            log_err "错误的选项: $1"
            ;;
        * )
            # 参数结束
            break
            ;;
    esac
    shift 1
done

[ -z "$DDNS_TOKEN" ] && log_err "DNSPOD login token missing." && exit 1
[ -z "$DDNS_DOMAIN" ] && log_err "DDNS domain missing." && exit 1

echo "====="
echo "DOMAIN:   $DDNS_DOMAIN"
echo "TOKEN:    $DDNS_TOKEN"
echo "IP_SRV:   $DDNS_IP_SERVICE"
echo "INTERVAL: $DDNS_CHECK_INTERVAL"
[ -n "$DDNS_IP" ] && echo "IP:       $DDNS_IP"
echo "====="
echo

trap trap_update SIGUSR1
trap exit SIGINT

while :; do
    try_update
    [ "$REPEAT" != "true" ] && exit
    sleep $DDNS_CHECK_INTERVAL &
    pid=$!
    wait $pid
    kill -9 $pid >/dev/null 2>&1
    sleep 1
done
