FROM jinnlynn/httpd

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=1.1.4

RUN set -ex && \
    DLINK="https://github.com/mayswind/AriaNg/releases/download/${VERSION}/AriaNg-${VERSION}.zip" && \
    wget -O /tmp/ariang.zip "$DLINK" && \
    unzip -o -d /app/var/www /tmp/ariang.zip && \
    rm -rf /tmp/*
