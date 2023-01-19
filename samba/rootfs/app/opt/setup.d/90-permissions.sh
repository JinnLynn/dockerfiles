#!/usr/bin/env bash
source $SETUP_BASE_DIR/_common.sh

: ${SMB_FIXPERM_DISABLED:=0}
: ${SMB_FIXPERM_IGNORE:=/__DEFAULT_IGNORED__}

if [ "${SMB_FIXPERM_DISABLED}" == 1 ]; then
    exit 0
fi

SMB_FIXPERM_IGNORE=$(join_config "$SMB_FIXPERM_IGNORE" "|")

for p in $(testparm -s 2>/dev/null | awk -F ' = ' '/\tpath = / {print $2}'); do
    if echo "$p" | grep -Eq "^${SMB_FIXPERM_IGNORE}$"; then
        log "Fix Permissions: [SKIP] $p"
        continue
    fi
    chown -Rh smb. "$p"
    find $p -type d ! -perm 755 -exec chmod 755 {} \;
    find $p -type f ! -perm 0644 -exec chmod 0644 {} \;
    log "Fix Permissions: [DONE] $p"
done
