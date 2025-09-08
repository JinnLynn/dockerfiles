#!/usr/bin/env sh
# REF: https://unix.stackexchange.com/a/526855

if [ -n "$SSH_ORIGINAL_COMMAND" ]; then
    # 有命令 执行
    exec /bin/sh -c "$SSH_ORIGINAL_COMMAND"
fi

# ===
# 没有命令 正常执行交换模式
# 这里禁止 仅输出信息
# alpine_ver=$(cat /etc/alpine-release)
# ssh_ver=$(ssh -V 2>&1 | awk -F, '{print $1}' | awk -F_ '{print $2}')
# ssl_ver=$(ssh -V 2>&1 | awk -F, '{print $2}' | awk '{print $2}')

cat <<EOF

Hi, Welcome to SSH Server.
You've successfully authenticated,
but this server does not provide interactive shell access.

EOF
