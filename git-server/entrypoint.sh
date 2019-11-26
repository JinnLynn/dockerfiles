#!/bin/sh
GIT_USER=${GIT_USER:-git}
GIT_USER_ID=${GIT_USER_ID:-1000}
GIT_GROUP=${GIT_GROUP:-git}
GIT_GROUP_ID=${GIT_GROUP_ID:-1000}

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
for k in rsa dsa ecdsa ed25519; do
    f="/etc/ssh/ssh_host_${k}_key"
    if [ ! -f "$f" ]; then
        echo "${k} host key missing, generating..."
        ssh-keygen -f $f -t $k -N ''
    fi
done

# 禁止密码登陆
sed -i s/#PasswordAuthentication.*/PasswordAuthentication\ no/ /etc/ssh/sshd_config

cd /home/${GIT_USER}

ln -sf /app/etc/git-shell-commands/ .

# ssh pubkey
rm -rf .ssh/*
if [ -n "$(ls /app/etc/*.pub 2>/dev/null)" ]; then
    cat /app/etc/*.pub >.ssh/authorized_keys 2>/dev/null
    chown ${GIT_USER}:${GIT_GROUP} .ssh/authorized_keys 2>/dev/null
    chmod 600 .ssh/authorized_keys 2>/dev/null
fi

# repo
ln -sf /app/local/ /repo
chown ${GIT_USER}:${GIT_GROUP} /repo

exec "$@"
