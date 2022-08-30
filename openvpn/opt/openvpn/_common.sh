set -e
[[ "$DEBUG" == "1" ]] && set -x

export SCRIPT_DIR="$(cd $(dirname ${BASH_SOURCE[0]}); pwd)"
source ${SCRIPT_DIR}/_common_functions.sh

# ==================
# 初始化处理
: ${OPENVPN:="/app/local"}
: ${OPENVPN_ENV:="/app/etc/openvpn.sh"}
: ${OPENVPN_CCD:="/app/etc/ccd"}

# TODO: 如果定义了OPENVPN_CONFIG 将直接使用不自动生成
# : ${OPENVPN_CONFIG:=}

: ${EASYRSA:="/usr/share/easy-rsa"}
: ${EASYRSA_PKI:="${OPENVPN}/pki"}
: ${EASYRSA_CRL_DAYS:=3650}

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

: ${OVPN_KEEPALIVE:="10 60"}

# REF: https://community.openvpn.net/openvpn/wiki/CipherNegotiation
: ${OVPN_DATA_CIPHERS:="CHACHA20-POLY1305:AES-256-GCM:AES-128-GCM:AES-256-CBC:BF-CBC"}
: ${OVPN_DATA_CIPHERS_FALLBACK:="AES-256-CBC"}

: ${OVPN_NAT:=1}
: ${OVPN_NAT_DEVICE:=eth0}
: ${OVPN_ALL_TRAFFIC:=1}

: ${OVPN_CLIENT_TO_CLIENT:=0}

: ${OVPN_PUSH_BLOCK_DNS:=0}
: ${OVPN_DNS:=0}
: ${OVPN_DNS_SERVER:=8.8.8.8}
: ${OVPN_DNS_SERVER_1:=8.8.4.4}

: ${OVPN_VERB:=3}

: ${OVPN_TOPOLOGY:=subnet}
: ${OVPN_DUPLICATE_CN:=0}

# ==================
# 导出
export OPENVPN ${!OPENVPN_*}
export EASYRSA ${!EASYRSA_*}
export ${!OVPN_*}
