FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="1.55.1"

RUN set -ex && \
    apk --no-cache add ca-certificates fuse tzdata && \
    echo "user_allow_other" >> /etc/fuse.conf && \
    ARCH=$(arch) && \
    [ $(arch -r) == "armv7" ] && ARCH="arm-v7" || true && \
    DLINK="https://github.com/rclone/rclone/releases/download/v1.55.0/rclone-v${VERSION}-linux-${ARCH}.zip" && \
    wget -O /tmp/rclone.zip "$DLINK" && \
    unzip -o -d /tmp /tmp/rclone.zip && \
    mv /tmp/rclone-*/rclone /app/bin/ && \
    rm -rf /tmp/*

# 配置默认存放目录
ENV XDG_CONFIG_HOME="/app/etc"

ENTRYPOINT ["rclone"]

CMD ["version"]
