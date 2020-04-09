#!/usr/bin/env sh

# 一些变量
# 代理服务器地址
REDIR_SERVER=${REDIR_SERVER:-}
# ss-redir本地端口
REDIR_PORT=${REDIR_PORT:-9528}
# iptables规则链名
REDIR_CHAIN=${REDIR_CHAIN:-GFW}
# 本地局域网IP地址 格式如192.168.1/24 多个以,区隔
REDIR_LOCAL=${REDIR_LOCAL:-10/8,172.16/12,192.168/16}

# 下面配置一般不用更改
# gfwlist ipset setname, dnsmasq也要有相同设置
IPSET_GFWLIST=${IPSET_GFWLIST:-GFWLIST}
# 中国IP ipset setname
IPSET_CNIP=${IPSET_CNIP:-CNIP}
# IP数据地址
IPDATA_URI=${IPDATA_URI:-https://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest}
# cnip数据本地文件 如果在线无法下载则使用此文件
CNIP_FILE=${CNIP_FILE:-/app/opt/cnip.txt}
TPROXY_MARK="0x2333/0x2333"

# 检查ipset是否存在 不存在创建
check_ipset_exist() {
    ipset list $IPSET_GFWLIST 1>/dev/null 2>&1 || ipset create $IPSET_GFWLIST hash:ip
    ipset list $IPSET_CNIP 1>/dev/null 2>&1 || ipset create $IPSET_CNIP hash:net
}

reset_ipset() {
    ipset destroy $IPSET_GFWLIST 1>/dev/null 2>&1
    ipset destroy $IPSET_CNIP 1>/dev/null 2>&1

    check_ipset_exist
    update_cnip
}

# 下载cnip数据，成功输出数据临时文件 失败不输出
_download_cnip_data() {
    [ -z "$IPDATA_URI" ] && return 1
    local dfile=$(mktemp)
    curl -sSL "$IPDATA_URI" | awk -F\| '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' >$dfile && echo $dfile
}

update_cnip() {
    # 强制更新: 清空set内容
    [ "$1" == "force" ] && ipset flush $IPSET_CNIP
    # 如果列表已存在条目 退出
    ipset list $IPSET_CNIP | grep -e ^[0-9] -q && return

    # 下载cnip数据
    local dfile=$(mktemp)
    curl -sSL "$IPDATA_URI" | awk -F\| '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > ${dfile} && {
        local ip_count=$(wc -l ${dfile} | awk '{print $1}')
        echo "$ip_count routes fetched."
        echo "# $(date +%Y%m%d) $ip_count routes" >${CNIP_FILE}
        cat ${dfile} >>$CNIP_FILE
        rm -rf ${dfile}
    } || echo "Download ip data fail."

    # 添加ip
    cat "$CNIP_FILE" | while read line; do
        [ "${line:0:1}" = '#' ] && continue
        ipset add $IPSET_CNIP $line
    done
}

add_pbr() {
    ip route add local 0/0 dev lo table 100
    ip rule add fwmark ${TPROXY_MARK} table 100
}

del_pbr() {
    ip rule show | grep "fwmark ${TPROXY_MARK}" | awk -F':' '{print $1}' | xargs -n1 ip rule del pref &>/dev/null
    ip route flush table 100
}

# 转发数据 实现网关
forward() {
    # 允许所有 OUTPUT 流量 系统默认就是ACCEPT
    iptables -P OUTPUT ACCEPT
    # 允许所有 INPUT 流量 系统默认就是ACCEPT
    iptables -P INPUT ACCEPT

    #! 允许转发，实现NAT !重要 系统默认是DROP
    iptables -P FORWARD ACCEPT
    # 临时有效，重启网络或系统都会失效，永久需修改/etc/sysctl.conf
    # echo 1 > /proc/sys/net/ipv4/ip_forward
    sysctl -w net.ipv4.ip_forward=1 >/dev/null
}

# 清理iptables中redir相关规则
clean_rules() {
    for table in mangle nat; do
        iptables -t $table -F $REDIR_CHAIN >/dev/null 2>&1
        for chain in PREROUTING OUTPUT; do
            # 注: 最后的tac翻转行，防止先删编号小的规则造成后面的规则序号改变
            for i in $(iptables -t $table -L $chain --line-numbers | awk '{print $1,$2}' | grep -e $REDIR_CHAIN$ | awk '{print $1}' | tac); do
                [ -n "$i" ] && iptables -t $table -D $chain $i
            done
        done
        iptables -t $table -X $REDIR_CHAIN >/dev/null 2>&1
    done
}

# 启用gfwlist过滤的透明代理
enable_gfwlist() {
    clean_rules

    # ==========
    # TCP转发
    # 1. 新建nat/$REDIR_CHAIN链
    iptables -t nat -N $REDIR_CHAIN
    # 2. nat/$REDIR_CHAIN链规则
    #  2.1 忽略代理服务器
    iptables -t nat -A $REDIR_CHAIN -d $REDIR_SERVER -j RETURN
    #  2.2 转发在$IPSET_GFWLIST中的地址
    iptables -t nat -A $REDIR_CHAIN -p tcp -m set --match-set $IPSET_GFWLIST dst -j REDIRECT --to-port $REDIR_PORT
    # 3. 转发
    #  3.1 局域网
    iptables -t nat -A PREROUTING -p tcp -j $REDIR_CHAIN
    #  3.2 本机
    iptables -t nat -A OUTPUT -p tcp -j $REDIR_CHAIN
    # 4. 内网数据包源 NAT
    iptables -t nat -A POSTROUTING -s $REDIR_LOCAL -j MASQUERADE

    # # ==========
    # # UDP转发(注: 本机UDP数据是无法转发的)
    # # 1. 新建mangle/$REDIR_CHAIN链
    # iptables -t mangle -N $REDIR_CHAIN
    # # 2. 在mangle/$REDIR_CHAIN链添加规则
    # #  2.1
    # # iptables -t mangle -A $REDIR_CHAIN -p udp --dport 53 -j RETURN
    # # iptables -t mangle -A $REDIR_CHAIN -p udp -m addrtype --dst-type LOCAL -j RETURN
    # #  2.2 重定向match-set $IPSET_GFWLIST的udp数据包至$REDIR_PORT端口
    # iptables -t mangle -A $REDIR_CHAIN -p udp -m set --match-set $IPSET_GFWLIST dst -j TPROXY --tproxy-mark $TPROXY_MARK --on-ip 127.0.0.1 --on-port $REDIR_PORT
    # # 3. 内网udp数据包流经$REDIR_CHAIN链
    # # iptables -t mangle -A PREROUTING -p udp -s $REDIR_LOCAL -j $REDIR_CHAIN
    # # iptables -t mangle -A PREROUTING -p udp -m addrtype --src-type LOCAL -j $REDIR_CHAIN
    # iptables -t mangle -A PREROUTING -p udp -j $REDIR_CHAIN
    # # iptables -t mangle -A PREROUTING -p udp -s 172.16/12 -j $REDIR_CHAIN
    # # iptables -t mangle -A PREROUTING -p udp -s 192.168/16 -j $REDIR_CHAIN
}

# 启用全代理
enable_all() {
    clean_rules

    special_addr=0/8,127/8,224/4,240/4,169.254/16,10/8,172.16/12,192.168/16

    # ===============
    # TCP转发
    # 1. 新建nat/$REDIR_CHAIN链
    iptables -t nat -N $REDIR_CHAIN
    # 2. 添加nat/$REDIR_CHAIN链规则
    #  2.1 忽略特殊地址
    iptables -t nat -A $REDIR_CHAIN -d $special_addr -j RETURN
    #  2.2 忽略代理服务器
    iptables -t nat -A $REDIR_CHAIN -d $REDIR_SERVER -j RETURN
    #  2.3 其它地址转发
    iptables -t nat -A $REDIR_CHAIN -p tcp -j REDIRECT --to-port $REDIR_PORT
    # 3. 转发到$REDIR_CHAIN
    #  3.1 局域网
    iptables -t nat -A PREROUTING -p tcp -j $REDIR_CHAIN
    #  3.2 本机
    iptables -t nat -A OUTPUT -p tcp -j $REDIR_CHAIN
    # 4. 内网数据包源 NAT
    iptables -t nat -A POSTROUTING -s $REDIR_LOCAL -j MASQUERADE

    # # ==========
    # # UDP转发
    # # 1. 新建mangle/$REDIR_CHAIN链
    # iptables -t mangle -N $REDIR_CHAIN
    # # 2. 添加mangle/$REDIR_CHAIN链规则
    # #  2.1 忽略特殊地址
    # iptables -t mangle -A $REDIR_CHAIN -d $special_addr -j RETURN
    # #  2.2 忽略代理服务器
    # iptables -t mangle -A $REDIR_CHAIN -d $REDIR_SERVER -j RETURN
    # #  2.3 忽略中国IP
    # iptables -t mangle -A $REDIR_CHAIN -m set --match-set $IPSET_CNIP dst -j RETURN
    # #  2.4 其它地址转发到$REDIR_PORT
    # iptables -t mangle -A $REDIR_CHAIN -p udp -j TPROXY --tproxy-mark $TPROXY_MARK --on-port $REDIR_PORT
    # # 3. 内网数据转发到$REDIR_CHAIN
    # iptables -t mangle -A PREROUTING -p udp -s $REDIR_LOCAL -j $REDIR_CHAIN
}

enable_cnip() {
    # 0. 创建中国IP的ipset
    update_cnip

    # 1. 让所有流量通过代理
    enable_all
    # 2. TCP转发
    #  2.1 在nat/$REDIR_CHAIN链转发数据前插入规则：忽略中国IP
    last_rule_num=$(iptables -t nat -L $REDIR_CHAIN -n --line-numbers 2>/dev/null | tail -n 1 | awk '{print $1}')
    [ -n "$last_rule_num" ] && {
        iptables -t nat -I $REDIR_CHAIN $last_rule_num -m set --match-set $IPSET_CNIP dst -j RETURN
    }
    # 3. UDP转发
}

# 禁用代理
disable_proxy() {
    clean_rules
}

mode() {
    # 没有规则 direct
    iptables -t nat -S $REDIR_CHAIN 1>/dev/null 2>&1 || {
        echo "direct"
        return
    }

    # 有setname $IPSET_GFWLIST: gfwlist
    iptables -t nat -S $REDIR_CHAIN | grep -q "match-set $IPSET_GFWLIST" && {
        echo "gfwlist"
        return
    }

    # 有setname $IPSET_CNIP: cnip
    iptables -t nat -S $REDIR_CHAIN | grep -q "match-set $IPSET_CNIP" && {
        echo "cnip"
        return
    }

    # 否则 all
    echo "all"
}

usage() {
        cat <<EOF
USAGE: $0 [COMMAND]

Commands:
  help          帮助
  gfwlist       对gfwlist中的网站使用代理
  cnip          对非中国IP使用代理
  all           所有流量通过代理
  direct        不使用透明代理
  reset-ipset   重置ipset list
  update-cnip   更新cnip
EOF
}

prepare() {
    # 启用数据转发
    forward

    # 检查环境变量
    [ -z "$REDIR_PORT" ] && echo "Oops, \$REDIR_PORT unsetted." && exit 1
    [ -z "$REDIR_CHAIN" ] && echo "Oops, \$REDIR_CHAIN unsetted." && exit 1
    [ -z "$REDIR_SERVER" ] && echo "Oops, \$REDIR_SERVER unsetted." && exit 1
    [ -z "$IPSET_GFWLIST" ] && echo "Oops, \$IPSET_GFWLIST unsetted." && exit 1
    [ -z "$IPSET_CNIP" ] && echo "Oops, \$IPSET_CNIP unsetted." && exit 1

    # 检查ipset
    check_ipset_exist

    # del_pbr
    # add_pbr
}

prepare

case "$1" in
    gfwlist )
        enable_gfwlist
        echo "REDIR mode: gfwlist"
        ;;
    cnip )
        enable_cnip
        echo "REDIR mode: cnip"
        ;;
    all )
        enable_all
        echo "REDIR mode: all"
        ;;
    direct )
        disable_proxy
        echo "REDIR mode: direct"
        ;;
    mode )
        mode
        ;;
    reset-ipset )
        reset_ipset
        ;;
    update-cnip )
        update_cnip force
        ;;
    ip-data )
        cat $CNIP_FILE
        ;;
    help )
        usage
        ;;
    * )
        echo "错误的命令: $1" >&2
        exit 1
        ;;
esac

[ "$2" == "keep-alive" ] && {
    while [[ true ]]; do
        sleep 1
    done
}

