#!/usr/bin/env bash
source $SETUP_BASE_DIR/_common.sh

[[ "$SMB_UID" =~ ^[0-9]+$ ]] || SMB_UID=1000
[[ "$SMB_GID" =~ ^[0-9]+$ ]] || SMB_GID=1000


check_user() {
    local usr="$1" passwd="$2" uid="${3:-""}" group="${4:-""}" gid="${5:-""}"
    log "CHECK USER: USR: $usr PWD: *** UID: ${uid:--} GROUP: ${group:--} GID: ${gid:--}"
    if [[ -n "$group" ]]; then
        if ! grep -q "^$group:" /etc/group; then
            log "ADD Group: $group ${gid:+:$gid}"
            addgroup ${gid:+--gid $gid} "$group"
        fi
    fi
    if ! grep -q "^$usr:" /etc/passwd; then
        log "ADD USER: $usr ${uid:+:$uid}"
        adduser -DH ${group:+-G $group} ${uid:+-u $uid} "$usr"
    fi
    if [[ -n "$passwd" ]]; then
        log "Update Samba User password."
        echo -e "$passwd\n$passwd" | smbpasswd -sa "$usr"
    fi
}


# check force user
check_user smb
[[ "$SMB_UID" -eq $(id -u smb) ]] || usermod -ou $SMB_UID smb
[[ "$SMB_GID" -eq $(id -g smb) ]] || usermod -og $SMB_GID smb

# check defined user
# SMB_USER USERNAME,PASSWORD[,UID,GROUP,GID]
multi_config SMB_USER | while read -r var; do
    check_user $(join_config "$var")
done
