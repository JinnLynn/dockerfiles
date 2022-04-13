#!/usr/bin/env sh

: ${LOCAL_SERVER=}
: ${LOCAL_SERVER_NAME:="Local SpeedTest"}
: ${LOCAL_DL_URL:="garbage.php"}
: ${LOCAL_UL_URL:="empty.php"}
: ${LOCAL_PING_URL:="empty.php"}
: ${LOCAL_GETIP_URL:="getIP.php"}

# envsubst "$(printf '${%s} ' $(env | grep -e "^LOCAL_" | cut -d= -f1))"

if [ -n "$LOCAL_SERVER" ]; then
    cat >/app/etc/local.json <<EOF
[
    {
        "id": 1,
        "name": "${LOCAL_SERVER_NAME}",
        "server": "${LOCAL_SERVER}",
        "dlURL": "${LOCAL_DL_URL}",
        "ulURL": "${LOCAL_UL_URL}",
        "pingURL": "${LOCAL_PING_URL}",
        "getIpURL": "${LOCAL_GETIP_URL}"
    }
]
EOF
fi

if [ -z "$@" ]; then
    if [ -f /app/etc/local.json ]; then
        set -- librespeed-cli --local-json /app/etc/local.json
    else
        set -- librespeed-cli
    fi
fi

exec "$@"
