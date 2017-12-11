#!/bin/sh
# set -eo pipefail
# shopt -s nullglob

# if command starts with an option, prepend dnsmasq
if [ "${1:0:1}" = '-' ]; then
    set -- dnsmasq "$@"
fi

# 允许所有的 OUTPUT 流量 系统默认就是ACCEPT
iptables -P OUTPUT ACCEPT
# 允许所有 INPUT 流量 系统默认就是ACCEPT
iptables -P INPUT ACCEPT

#! 允许转发，实现NAT !重要 系统默认是DROP
iptables -P FORWARD ACCEPT
# 临时有效，重启网络或系统都会失效，永久需修改/etc/sysctl.conf
# echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1

# 创建IPSet list
ipset list $REDIR_SET 1>/dev/null 2>&1 || ipset create $REDIR_SET hash:ip

# 路由表 转发
iptables -t nat -S | grep -q $REDIR_SET && true || {
    #            它机        本机
    for chain in PREROUTING OUTPUT; do
        iptables -t nat -A $chain -p tcp -m set --match-set $REDIR_SET dst -j REDIRECT --to-port $REDIR_PORT
    done
}

exec $@
