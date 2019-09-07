#!/bin/sh
# 必须export 否则envsubst无法获取值
export GITWEB_CONFIG=${GITWEB_CONFIG:-"/app/etc/gitweb.conf"}

export PROJECT_ROOT=${PROJECT_ROOT:-"/app/mnt/repo"}
export FEATURE_SEARCH=${FEATURE_SEARCH:-1}
export FEATURE_HIGHLIGHT=${FEATURE_HIGHLIGHT:-1}
export FEATURE_AVATAR=${FEATURE_AVATAR:-gravatar}
export FEATURE_BLAME=${FEATURE_BLAME:-0}
export FEATURE_SNAPSHOT=${FEATURE_SNAPSHOT:-none}

envsubst '$PROJECT_ROOT $FEATURE_SEARCH $FEATURE_BLAME $FEATURE_HIGHLIGHT $FEATURE_AVATAR $FEATURE_SNAPSHOT' \
    </app/etc/gitweb.conf.tpl >$GITWEB_CONFIG

cat $GITWEB_CONFIG

echo $@

exec $@
