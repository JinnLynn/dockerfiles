ARG VERSION
FROM alpine${VERSION:+":${VERSION}"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR="https://mirrors.aliyun.com/alpine"
ARG TIMEZONE="Asia/Shanghai"
ARG APP_DIRS
# REF: https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM

RUN set -ex && \
    sed -ri "s#^.*/alpine#${MIRROR%/}#g" /etc/apk/repositories && \
    grep -q "/edge/" /etc/apk/repositories && echo "${MIRROR%/}/edge/testing" >>/etc/apk/repositories || true && \
    apk add --no-cache -u ca-certificates tzdata && \
    cp "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime && \
    apk del --quiet tzdata && \
    printf '%s\n' ${APP_DIRS:-bin etc opt mnt local log tmp var} | xargs -ri mkdir -p /app/{}

COPY xinfo.sh /app/bin/xinfo

ENV PATH=/app/bin:$PATH

# HACK: armv6
RUN xinfo check arm v6 && touch /.armv6 || true

CMD ["/bin/sh"]
