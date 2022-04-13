FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="2.21.1"

RUN set -ex && \
    DLINK=https://github.com/filebrowser/filebrowser/releases/download/v${VERSION}/linux-$(xinfo)-filebrowser.tar.gz && \
    wget -O- $DLINK | tar xz -C /tmp && \
    mv /tmp/filebrowser /app/bin/ && \
    chmod +x /app/bin/filebrowser && \
    rm -rf /tmp/*

ENV FB_PORT=80 \
    FB_ADDRESS=0.0.0.0 \
    FB_DATABASE=/app/local/database.dd \
    FB_ROOT=/app/mnt

HEALTHCHECK --start-period=2s --interval=5s --timeout=3s \
    CMD wget -O/dev/null -q http://localhost/health || exit 1

ENTRYPOINT ["filebrowser"]
