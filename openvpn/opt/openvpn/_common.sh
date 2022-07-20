set -e
[[ "$DEBUG" == "1" ]] && set -x

: ${OPENVPN:="/app/local"}
: ${OPENVPN_ENV:="/app/etc/openvpn.sh"}
: ${OPENVPN_CCD:="/app/etc/ccd"}

# TODO: 如果定义了OPENVPN_CONFIG 将直接使用不自动生成
# : ${OPENVPN_CONFIG:=}

: ${EASYRSA:="/usr/share/easy-rsa"}
: ${EASYRSA_PKI:="${OPENVPN}/pki"}
: ${EASYRSA_CRL_DAYS:=3650}

export OPENVPN ${!OPENVPN_*} EASYRSA ${!EASYRSA_*}

# ===
# NOTE: 如果通过docker环境变量设置 OVPN_ 相关变量 这里会被复写
#       如何让环境变量的优先级更高？ !!!
if [[ -f "$OPENVPN_ENV" ]]; then
    source "${OPENVPN_ENV}"
fi

: ${OVPN_SERVER_NET:="10.68.76.0/24"}

# Server name is in the form "udp://vpn.example.com:1194"
if [[ "${OVPN_SERVER_URI:-}" =~ ^((udp|tcp|udp6|tcp6)://)?([0-9a-zA-Z\.\-]+)(:([0-9]+))?$ ]]; then
    OVPN_PROTO=${BASH_REMATCH[2]};
    OVPN_CN=${BASH_REMATCH[3]};
    OVPN_PORT=${BASH_REMATCH[5]};
else
    : ${OVPN_PROTO:="tcp"}
    : ${OVPN_PORT:="1194"}
    : ${OVPN_CN:="localhost"}
fi

: ${OVPN_DEVICE:="tun"}
: ${OVPN_DEVICE_NUM:=0}

: ${OVPN_KEEPALIVE:="10 120"}

# REF: https://community.openvpn.net/openvpn/wiki/CipherNegotiation
: ${OVPN_DATA_CIPHERS:="CHACHA20-POLY1305:AES-256-GCM:AES-128-GCM:AES-256-CBC:BF-CBC"}
: ${OVPN_DATA_CIPHERS_FALLBACK:="AES-256-CBC"}

: ${OVPN_NAT:=1}
: ${OVPN_NAT_DEVICE:=eth0}
: ${OVPN_ALL_TRAFFIC:=1}

: ${OVPN_CLIENT_TO_CLIENT:=0}

: ${OVPN_PUSH_BLOCK_DNS:=0}
: ${OVPN_DNS:=0}
: ${OVPN_DNS_SERVER:="8.8.8.8"}
: ${OVPN_DNS_SERVER_1:="8.8.4.4"}

: ${OVPN_VERB:=3}

: ${OVPN_ROUTE:=}

: ${OVPN_TOPOLOGY:=subnet}
: ${OVPN_DUPLICATE_CN:=0}

export ${!OVPN_*}

# ===================
OPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

print_info() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $@" 1>&2
}

# $1 CONFIG_NAME ENV prefix
multi_config() {
    set | \
        awk '/^'$1'[0-9_]*=/ {sub (/^[^=]*=/, "", $0); print}' | \
        sed "s/^['\"]//; s/['\"]$//g"
}

# Convert 1.2.3.4/24 -> 255.255.255.0
cidr2mask()
{
    local i
    local subnetmask=""
    local cidr=${1#*/}
    local full_octets=$(($cidr/8))
    local partial_octet=$(($cidr%8))

    for ((i=0;i<4;i+=1)); do
        if [ $i -lt $full_octets ]; then
            subnetmask+=255
        elif [ $i -eq $full_octets ]; then
            subnetmask+=$((256 - 2**(8-$partial_octet)))
        else
            subnetmask+=0
        fi
        [ $i -lt 3 ] && subnetmask+=.
    done
    echo $subnetmask
}


trim() {
    echo $@ | xargs
}


# $1=1 $2=foo => "foo"
# $1= $2=foo => ""
cfg_on() {
    [[ "$1" != "1" ]] && return
    echo "$2" | xargs
}

# $1=bar $2=foo => "foo bar"
# $1=bar $2==> "bar"
# $1= $2=foo => ""
cfg_value() {
    [[ -z "$1" ]] && return
    echo "$2 $1" | xargs
}

cfg_info() {
    [[ -n "$@" ]] && echo "# $@" || echo
}

