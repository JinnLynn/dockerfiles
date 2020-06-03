ARG VERSION
FROM alpine${VERSION:+":${VERSION}"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION
ARG BRANCH="${VERSION:-latest-stable}"
ARG MIRROR="https://mirrors.aliyun.com/alpine"
ARG TIMEZONE="Asia/Shanghai"
ARG APP_DIRS="bin etc opt mnt local log tmp var"

ENV PATH=/app/bin:$PATH

COPY arch.sh /app/bin/arch

RUN set -ex && \
    [ "$BRANCH" != "edge" -a "$BRANCH" != "latest-stable" ] && BRANCH="v${BRANCH}" || true && \
    echo -e "$MIRROR/$BRANCH/main\\n$MIRROR/$BRANCH/community" >/etc/apk/repositories && \
    [ "$BRANCH" == "edge" ] && echo "$MIRROR/$BRANCH/testing" >>/etc/apk/repositories || true && \
    apk add --no-cache tzdata && \
    cp "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime && \
    apk del --no-cache tzdata && \
    [ -n "$APP_DIRS" ] && for d in $APP_DIRS; do mkdir -p /app/$d; done || true && \
    cat /etc/apk/repositories

CMD ["/bin/sh"]
