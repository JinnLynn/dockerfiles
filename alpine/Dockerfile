FROM alpine AS builder

ARG BRANCH="latest-stable"
ARG MIRROR="https://mirrors.aliyun.com/alpine"
ARG TIMEZONE="Asia/Shanghai"
ARG APP_DIRS="bin etc opt mnt local log tmp var"
ARG REBUILD_HASH=

COPY arch.sh /tmp/arch

RUN set -ex && \
    echo $REBUILD_HASH 1>/dev/null && \
    cd /tmp && \
    chmod +x arch && \
    ARCH=$(/tmp/arch --raw) && \
    RELEASE_URI="$MIRROR/$BRANCH/releases/$ARCH" && \
    echo -e "$MIRROR/$BRANCH/main\\n$MIRROR/$BRANCH/community" >/etc/apk/repositories && \
    apk add --no-cache tzdata curl && \
    rootfs_file=$(curl -sSL $RELEASE_URI/latest-releases.yaml | grep "flavor: alpine-minirootfs" -C 6 | grep file: | awk '{print $2}') && \
    mkdir -p /tmp/rootfs && \
    cd /tmp/rootfs && \
    curl -SL $RELEASE_URI/$rootfs_file | tar xz && \
    cp "/usr/share/zoneinfo/$TIMEZONE" etc/localtime && \
    cat /etc/apk/repositories >etc/apk/repositories && \
    [ "$BRANCH" == "edge" ] && echo "$MIRROR/$BRANCH/testing" >>etc/apk/repositories || true && \
    [ -n "$APP_DIRS" ] && for d in $APP_DIRS; do mkdir -p app/$d; done || true && \
    cp /tmp/arch app/bin/arch

# =================
FROM scratch

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV PATH=/app/bin:$PATH

COPY --from=builder /tmp/rootfs/ /

CMD ["/bin/sh"]
