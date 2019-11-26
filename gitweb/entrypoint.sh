#!/bin/sh
GITWEB_CONFIG=${GITWEB_CONFIG:-"/app/etc/gitweb.conf"}

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
fi

# := 语法: 更新已设置的值
# REF: https://redmine.lighttpd.net/projects/lighttpd/repository/revisions/367e62c1c29e143267f40e3672d4869d79bfb58d
cat <<EOF >/app/etc/lighttpd-user.conf
server.username  := "${GIT_USER}"
server.groupname := "${GIT_GROUP}"
EOF

chown -R ${GIT_USER}:${GIT_GROUP}   \
    /var/www/localhost              \
    /var/log/lighttpd               \
    /var/lib/lighttpd 2>/dev/null

exec $@
