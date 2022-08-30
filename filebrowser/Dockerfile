FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="2.22.4"

RUN set -ex && \
    wget -O- https://github.com/filebrowser/filebrowser/releases/download/v${VERSION}/linux-$(xinfo)-filebrowser.tar.gz | \
        tar xz -C /app/bin filebrowser && \
    chmod +x /app/bin/filebrowser

ENV FB_PORT=80 \
    FB_ADDRESS=0.0.0.0 \
    FB_DATABASE=/app/local/database.db \
    FB_ROOT=/app/mnt

HEALTHCHECK --start-period=2s --interval=5s --timeout=3s \
    CMD wget -O/dev/null -q http://localhost/health || exit 1

ENTRYPOINT ["filebrowser"]
