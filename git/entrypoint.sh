#!/bin/sh
user=${GIT_USER:-git}

# check host key
for k in rsa dsa ecdsa ed25519; do
    f="/etc/ssh/ssh_host_${k}_key"
    if [ ! -f "$f" ]; then
        echo "dsa host key missing, generating..."
        ssh-keygen -f $f -t $k -N ''
    fi
done

# 禁止密码登陆
sed -i s/#PasswordAuthentication.*/PasswordAuthentication\ no/ /etc/ssh/sshd_config

# git 用户
if ! cat /etc/passwd | grep -q ^$user; then
    adduser -D -s /usr/bin/git-shell $user
    rand_pwd=$(cat /proc/sys/kernel/random/uuid | awk -F '-' '{print $1}')
    echo "$user:$rand_pwd" | chpasswd
    mkdir -p /home/$user/.ssh
    ln -sf /app/etc/git-shell-commands /home/$user/git-shell-commands
    chown -R $user:$user /home/$user /home/$user/* /home/$user/.ssh
    chmod 700 /home/$user/.ssh
fi

# ssh pubkey
rm -rf /home/$user/.ssh/*
if [ -n "$(ls /app/etc/*.pub 2>/dev/null)" ]; then
    cat /app/etc/*.pub >/home/$user/.ssh/authorized_keys 2>/dev/null
fi
chown -R $user:$user /home/$user/.ssh/* 2>/dev/null
chmod -R 600 /home/$user/.ssh/* 2>/dev/null

# repo
chown -R $user:$user /app/local
ln -sf /app/local /repo

exec "$@"
