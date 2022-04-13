ARG VERSION
FROM alpine${VERSION:+":${VERSION}"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION
ARG BRANCH="${VERSION:-latest-stable}"
ARG MIRROR="https://mirrors.cloud.tencent.com/alpine"
ARG TIMEZONE="Asia/Shanghai"
ARG APP_DIRS

# REF: https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM

ENV PATH=/app/bin:$PATH

COPY arch.sh /app/bin/arch
COPY xinfo.sh /app/bin/xinfo

RUN set -ex && \
    [ "${BRANCH:0:1}" -gt 0 ] 2>/dev/null && BRANCH="v${BRANCH}" || true && \
    echo -e "$MIRROR/$BRANCH/main\\n$MIRROR/$BRANCH/community" >/etc/apk/repositories && \
    [ "$BRANCH" == "edge" ] && echo "$MIRROR/$BRANCH/testing" >>/etc/apk/repositories || true && \
    apk add --no-cache tzdata && \
    mkdir -p "/etc/zoneinfo/$(dirname $TIMEZONE)" && \
    cp "/usr/share/zoneinfo/$TIMEZONE" "/etc/zoneinfo/$TIMEZONE" && \
    ln -sf /etc/zoneinfo/$TIMEZONE /etc/localtime && \
    apk del --no-cache tzdata && \
    xinfo check arm v6 && touch /.armv6 || true && \
    for d in ${APP_DIRS:-bin etc opt mnt local log tmp var}; do mkdir -p /app/$d; done

CMD ["/bin/sh"]
