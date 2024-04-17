ARG VERSION
FROM alpine${VERSION:+":${VERSION}"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR="https://mirrors.tuna.tsinghua.edu.cn/alpine"
ARG TIMEZONE="Asia/Shanghai"
ARG APP_DIRS
# REF: https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM

ENV PATH=/app/bin:$PATH

COPY xinfo.sh /app/bin/xinfo

RUN set -ex && \
    [ -z "$MIRROR" ] || { \
        sed -ri "s#^.*/alpine#${MIRROR%/}#g" /etc/apk/repositories && \
        ! grep -q "/edge/" /etc/apk/repositories || echo "${MIRROR%/}/edge/testing" >>/etc/apk/repositories; \
    } && \
    apk add --no-cache tzdata && \
    cp "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime && \
    apk del --quiet tzdata && \
    printf '%s\n' ${APP_DIRS:-bin etc opt mnt local log run tmp var} | xargs -ri mkdir -p /app/{} && \
    xinfo check arm v6 && touch /.armv6 || true

WORKDIR /app

ONBUILD ARG APK_MIRROR=
ONBUILD RUN set -ex && \
        [ -z "$APK_MIRROR" ] || sed -ri "s#^.*/alpine#${APK_MIRROR%/}#g" /etc/apk/repositories

# HACK: armv6
# RUN xinfo check arm v6 && touch /.armv6 || true

CMD ["/bin/sh"]
