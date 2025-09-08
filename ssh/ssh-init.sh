#!/usr/bin/env sh

: ${SSH_PASSWORD:=$(cat '/proc/sys/kernel/random/uuid' | awk -F '-' '{print $5}')}
: ${SSH_PASSWORD_AUTH:=0}
: ${SSH_INTERACTIVE:=0}
: ${SSH_FORWARDING:=0}
: ${SSH_SFTP:=0}

: ${SSH_PUBLIC_KEY:=}
: ${SSH_EXTRA_PKG:=}

# ===
# NOTE: 不要使用Banner配置

SSHD_CONF="/app/etc/sshd.conf"

# ===
# multi_config ENV_PREFIX | while read -r var; do; echo $var; done
multi_config() {
    set | \
        awk '/^'$1'[0-9_]*=/ {sub (/^[^=]*=/, "", $0); print}' | \
        sed "s/^['\"]//; s/['\"]$//g"
}

# ===

(
    . /etc/os-release
    ssh_ver=$(ssh -V 2>&1 | awk -F, '{print $1}' | awk -F_ '{print $2}')
    ssl_ver=$(ssh -V 2>&1 | awk -F, '{print $2}' | awk '{print $2}')
    cat <<EOF >/etc/motd
Welcome to SSH Server!
$PRETTY_NAME $(uname -m)
OpenSSH_${ssh_ver} OpenSSL_${ssl_ver}
EOF
)

# 安装包
if [ -n "$SSH_EXTRA_PKG" ]; then
    echo "$SSH_EXTRA_PKG" | xargs -n1 echo | while read -r pkg; do
        apk info -e "$pkg" &>/dev/null || {
            echo "[INFO] Install PKG: $pkg"
            apk add --no-cache --quiet $pkg
        }
    done
fi

# PUB KEYS
rm -rf ~/.ssh
mkdir -p ~/.ssh
chmod 700 ~/.ssh
(
    if [ -n "$SSH_PUBLIC_KEY" ]; then
        if [ -f "$SSH_PUBLIC_KEY" ]; then
            cat "$SSH_PUBLIC_KEY"
        else
            echo "$SSH_PUBLIC_KEY"
        fi
    fi

    cat /app/etc/keys/*.pub
) >~/.ssh/authorized_keys 2>/dev/null
chmod 600 ~/.ssh/authorized_keys 2>/dev/null

# 更改密码
echo "root:${SSH_PASSWORD}" | chpasswd &>/dev/null

# 检查服务端key
_HOST_KEYS="/app/etc/host-keys"
if [ -d "$_HOST_KEYS" ]; then
    find $_HOST_KEYS -name "ssh_host_*_key*" -print0 | xargs -0 -I {} cp {} /etc/ssh/
    for k in rsa dsa ecdsa ed25519; do
        f="/etc/ssh/ssh_host_${k}_key"
        if [ ! -f "$f" ]; then
            ssh-keygen -q -f $f -t $k -N ''
        fi
        chmod 644 ${f}.pub
        chmod 600 ${f}
    done
fi

cat <<EOF >$SSHD_CONF
# 只有root用户 允许其登录 后面通过PasswordAuthentication控制是否允许密码登录
# 默认 prohibit-password 禁止密码
PermitRootLogin yes

# 默认是 .ssh/authorized_keys .ssh/authorized_keys2
AuthorizedKeysFile	.ssh/authorized_keys
EOF

# 转发 sshd中默认是yes
if [ "$SSH_FORWARDING" != "1" ]; then
    cat <<EOF >>$SSHD_CONF
AllowAgentForwarding no
AllowStreamLocalForwarding no
AllowTcpForwarding no
DisableForwarding yes
EOF
fi

# 禁止密码登陆 sshd默认yes
if [ "$SSH_PASSWORD_AUTH" != "1" ]; then
    echo "PasswordAuthentication no" >>$SSHD_CONF
fi

# 禁止交互登录 sshd默认yes
if [ "$SSH_INTERACTIVE" != "1" ]; then
    # echo "PermitTTY no" >>$SSHD_CONF
    echo "ForceCommand /app/bin/ssh-shell"  >>$SSHD_CONF
    :
fi

# SFTP
if [ "$SSH_SFTP" == "1" ]; then
    echo "Subsystem sftp internal-sftp" >>$SSHD_CONF
fi

cat <<EOF
===
USR:            $(whoami)
PWD:            $SSH_PASSWORD
PASSWORD_AUTH:  $SSH_PASSWORD_AUTH
INTERACTIVE:    $SSH_INTERACTIVE
FORWARDING:     $SSH_FORWARDING
SFTP:           $SSH_SFTP
EXTRA PKG:      $SSH_EXTRA_PKG
EXTRA CONFIG:
EOF

multi_config SSH_EXTRA_CONFIG | while read -r var; do
    echo "                $var"
    echo $var >>$SSHD_CONF
done

echo "==="

# ===
if [ $# -eq 0 ]; then
    set -- /usr/sbin/sshd -D -f $SSHD_CONF
fi

exec "$@"
