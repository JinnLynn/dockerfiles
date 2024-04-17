#!/bin/bash

if [ -n "$@" ]; then
    exec "$@"
fi

: ${GIT_USER:=git}
: ${GIT_USER_ID:=1000}
: ${GIT_GROUP:=git}
: ${GIT_GROUP_ID:=1000}

# 是否允许密码登录
: ${GIT_PWD_AUTH:=}
# 授权证书 在/app/etc/authorized-keys下查找
# 如果为空 则为该目录下所有*.pub文件
: ${GIT_AUTHORIZED_KEYS:=}

# Check if user exists
if ! id -u ${GIT_USER} > /dev/null 2>&1; then
    echo "The user ${GIT_USER} does not exist, creating..."
    addgroup -g ${GIT_GROUP_ID} ${GIT_GROUP}
    adduser -u ${GIT_USER_ID} -G ${GIT_GROUP} -D -s /usr/bin/git-shell ${GIT_USER}
    rand_pwd=$(cat /proc/sys/kernel/random/uuid | awk -F '-' '{print $1}')
    echo "${GIT_USER}:$rand_pwd" | chpasswd 2>/dev/null

    mkdir -p /home/${GIT_USER}/.ssh
    chmod 700 /home/${GIT_USER}/.ssh
    chown -R ${GIT_USER}:${GIT_GROUP} /home/${GIT_USER}/.ssh
fi

# check host key
_HOST_KEYS="/app/etc/host-keys"
[ ! -d "$_HOST_KEYS" ] && mkdir -p "$_HOST_KEYS"
if [ -w "$_HOST_KEYS" ]; then
    for k in rsa dsa ecdsa ed25519; do
        f="${_HOST_KEYS}/ssh_host_${k}_key"
        if [ ! -f "$f" ]; then
            echo "${k} host key missing, generating..."
            ssh-keygen -f $f -t $k -N ''
        fi
    done
fi
find $_HOST_KEYS -name "ssh_host_*_key" -print0 | xargs -0 -I {} ln -sf {} /etc/ssh/

#
pushd /home/${GIT_USER} >/dev/null

# authorized keys
_AUTHORIZED_KEYS="/app/etc/authorized-keys"
[ ! -d "$_AUTHORIZED_KEYS" ] && mkdir -p "$_AUTHORIZED_KEYS"
rm -rf .ssh/*
touch .ssh/authorized_keys
if [ -n "$GIT_AUTHORIZED_KEYS" ]; then
    for k in $GIT_AUTHORIZED_KEYS; do
        _kf=${_AUTHORIZED_KEYS}/${k}
        if [ -f "$_kf" ]; then
            cat "$_kf" >>.ssh/authorized_keys
            echo "Authorized Key $k added."
        else
            echo "Authorized Key $k missing."
        fi
    done
else
    [ -n "$(ls $_AUTHORIZED_KEYS/*.pub 2>/dev/null)" ] && \
        cat $_AUTHORIZED_KEYS/*.pub >.ssh/authorized_keys
fi
chown ${GIT_USER}:${GIT_GROUP} .ssh/authorized_keys
chmod 600 .ssh/authorized_keys

ln -sf /app/etc/git-shell-commands .

popd >/dev/null

# repo
chown -R ${GIT_USER}:${GIT_GROUP} /app/local
ln -sf /app/local /repo

rm -rf /etc/motd

# 禁止密码登陆
# sed -i "s/#PasswordAuthentication.*/PasswordAuthentication\ no/" /etc/ssh/sshd_config
if [ -n "$GIT_PWD_AUTH" ]; then
    set -- -o "PasswordAuthentication=yes"
else
    set -- -o "PasswordAuthentication=no"
fi

exec /usr/sbin/sshd -D "$@"
