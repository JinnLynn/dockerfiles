#!/usr/bin/env bash
# dnspod token
: ${DDNS_TOKEN:=}
: ${DDNS_DOMAIN:=}

# : ${DDNS_IP_SERVICE:="http://ip.3322.net"}
: ${DDNS_IP_SERVICE:="4.ipw.cn"}

: ${DDNS_TYPE_IPV4:=1}
: ${DDNS_IPV4:=}
: ${DDNS_IPV4_SERVICE:=}

: ${DDNS_TYPE_IPV6:=0}
: ${DDNS_IPV6:=}
# : ${DDNS_IPV6_SERVICE:="https://ipv6.icanhazip.com"}
: ${DDNS_IPV6_SERVICE:="6.ipw.cn"}

: ${DDNS_CHECK_INTERVAL:=60}
: ${DDNS_HOOK:=}
: ${DDNS_PSL:="/app/var/psl.dat"}

: ${DDNS_DEBUG:=}

if [ -n "$DDNS_DEBUG" ]; then
    set -x
fi

CONNECT_TIMEOUT=5
SILENT=
REPEAT=
DISABLE_PRINT_INFO=

DEF_CURL_OPTS="-sL -X POST --connect-timeout ${CONNECT_TIMEOUT:-5}"

PSL="psl --load-psl-file $DDNS_PSL --print-reg-domain -b"

is_ipv4() {
    # REF: https://helloacm.com/how-to-valid-ipv6-addresses-using-bash-and-regex/
    [[ "$1" =~ ^([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$ ]]
}

is_ipv6() {
    # REF: https://helloacm.com/how-to-valid-ipv6-addresses-using-bash-and-regex/
    [[ "$1" =~ ^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$ ]]
}

get_ipv4() {
    [[ -f "$DDNS_HOOK" ]] && source "$DDNS_HOOK"
    # local ip=$DDNS_IPV4
    # is_ipv4 "$ip" || ip=$(curl -sL4 $DDNS_IPV4_SERVICE 2>/dev/null)
    local ip=${DDNS_IPV4:-$(curl -sL4 ${DDNS_IPV4_SERVICE:-$DDNS_IP_SERVICE} 2>/dev/null)}
    type -a on_get_ipv4 1>/dev/null 2>&1 && {
        ip=$(on_get_ipv4 "$ip")
    }
    is_ipv4 "$ip" && echo $ip
}

get_ipv6() {
    [[ -f "$DDNS_HOOK" ]] && source "$DDNS_HOOK"
    local ip=${DDNS_IPV6:-$(curl -sL6 ${DDNS_IPV6_SERVICE:-$DDNS_IP_SERVICE} 2>/dev/null)}
    type -a on_get_ipv6 1>/dev/null 2>&1 && {
        ip=$(on_get_ipv6 "$ip")
    }
    is_ipv6 "$ip" && echo $ip
}

log() {
    echo $(date +%Y-%m-%d\ %H:%M:%S) $@
}

log_err() {
    echo $(date +%Y-%m-%d\ %H:%M:%S) $@ 1>&2
}

fetch_psl_data() {
    curl -L# -o /app/tmp/psl.dat https://github.com/publicsuffix/list/raw/master/public_suffix_list.dat && \
        cp /app/tmp/psl.dat ${DDNS_PSL}
}

# post_api ACTION [PARAMS]
post_api() {
    local params="login_token=$DDNS_TOKEN&format=json&domain=$domain&sub_domain=$sub_domain"
    [[ -n "$2" ]] && params="${params}&$2"
    curl $DEF_CURL_OPTS -o $tmp https://dnsapi.cn/$1 -d "$params"
}

update_ipv4() {
    local cur_ip=$(get_ipv4)
}

update_ipv6() {
    local cur_ip=$(get_ipv6)
}

update() {
    local record_type=$(echo ${1:-A} | tr "[:lower:]" "[:upper:]")
    local cur_ip

    if [[ "$record_type" == "AAAA" ]]; then
        cur_ip=$(get_ipv6)
    else
        cur_ip=$(get_ipv4)
    fi

    [[ -z "$cur_ip" ]] && {
        log_err "Fetch Current IP[$record_type] fail."
        return 1
    }

    local tmp=$(mktemp)

    post_api Record.List "record_type=$record_type" >$tmp
    # cat $tmp | jq
    # return

    local record_id=$(cat $tmp | jq -r '.records[0].id')
    local record_value=$(cat $tmp | jq -r '.records[0].value')
    [[ "$record_id" == "null" ]] && record_id=""
    [[ "$record_value" == "null" ]] && record_value=""

    [[ -z "$record_id" ]] && {
        cat $tmp | jq -e '.status.code == "10"' >/dev/null && {
            # 记录不存在
            log "Create $record_type record."
            post_api Record.Create "record_type=$record_type&record_line=默认&value=$cur_ip" >$tmp
            return
        }
    }

    [[ -z "$record_id" ]] && {
        log_err "Get $record_type record fail."
        return 1
    }

    # 记录已经与当前IP相同
    [ "$cur_ip" == "$record_value" ] && {
        [ -z "$SILENT" ] && log "DDNS $DDNS_DOMAIN[$record_type $cur_ip] unchanged."
        return
    }


    if [[ "$record_type" == "A" ]]; then
        post_api Record.Ddns "record_id=$record_id&value=$cur_ip&record_line=默认" >$tmp
    else
        post_api Record.Modify "record_id=$record_id&value=$cur_ip&record_line=默认&record_type=AAAA" >$tmp
    fi

    # cat $tmp | jq

    cat $tmp | jq -e '.status.code == "1"' >/dev/null || {
        log_err "DDNS $DDNS_DOMAIN[$record_type] update fail:" $(cat $tmp | jq .status.message)
        return 1
    }

    log "DDNS $DDNS_DOMAIN[$record_type $cur_ip] updated."
}

try_update() {
    [[ "$DDNS_TYPE_IPV4" == 1 ]] && update a
    [[ "$DDNS_TYPE_IPV6" == 1 ]] && update aaaa
}

trap_update() {
    log "Trap update signal..."
    try_update
}

while (( ${#} )); do
    case "$1" in
        --token|-t )
            shift 1
            DDNS_TOKEN=$1
            ;;
        --domain|-d )
            shift 1
            DDNS_DOMAIN=$1
            ;;
        --ip|--ipv4 )
            shift 1
            DDNS_IPV4=$1
            is_ipv4 "$DDNS_IPV4" || {
                log_err "ipv4[$DDNS_IPV4] error."
                exit 1
            }
            ;;
        --ipv6 )
            shift 1
            DDNS_IPV6=$1
            is_ipv4 "$DDNS_IPV6" || {
                log_err "ipv6[$DDNS_IPV6] error."
                exit 1
            }
            ;;
        -4 )
            DDNS_TYPE_IPV4=1
            ;;
        -6 )
            DDNS_TYPE_IPV6=1
            ;;
        --slient|-s )
            SILENT=true
            ;;
        --repeat|-r )
            REPEAT=true
            ;;
        --hook )
            shift 1
            DDNS_HOOK=$1
            ;;
        --help|-h )
            echo "USAGE: $0 [-t|--token TOKEN] [-d|--domain DOMAIN] [--ip|-i IP] [--repeat|-r] [--slient|-s] [-6|-4]"
            exit 0
            ;;
        --update-psl )
            fetch_psl_data
            exit $?
            ;;
        --disable-print-info )
            DISABLE_PRINT_INFO=true
            ;;
        -* )
            log_err "Argument ERROR: $1"
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

domain=$($PSL $DDNS_DOMAIN)
sub_domain=${DDNS_DOMAIN%.$domain}

[[ "$DDNS_TYPE_IPV4" != 1 ]] && [[ "$DDNS_TYPE_IPV6" != 1 ]] && DDNS_TYPE_IPV4=1

if [[ -z "$DISABLE_PRINT_INFO" ]]; then
    echo "====="
    echo "Domain:   $DDNS_DOMAIN($sub_domain $domain)"
    echo "Token:    $DDNS_TOKEN"
    [[ -n "$REPEAT" ]] && \
        echo "INTERVAL: $DDNS_CHECK_INTERVAL"
    [[ "$DDNS_TYPE_IPV4" == 1 ]] && {
        echo "IPv4:     ${DDNS_IPV4:-${DDNS_IPV4_SERVICE:-$DDNS_IP_SERVICE}}"
    }
    [[ "$DDNS_TYPE_IPV6" == 1 ]] && {
        echo "IPv6:     ${DDNS_IPV6:-${DDNS_IPV6_SERVICE:-$DDNS_IP_SERVICE}}"
    }
    echo "====="
    echo
fi

trap trap_update SIGUSR1
trap exit SIGINT

while :; do
    try_update "$domain" "$sub_domain"
    [[ -z "$REPEAT" ]] && exit
    sleep $DDNS_CHECK_INTERVAL &
    pid=$!
    wait $pid
    kill -9 $pid >/dev/null 2>&1
    sleep 1
done
