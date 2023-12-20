FROM jinnlynn/httpd

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="1.3.7"

RUN set -ex && \
    wget -O /tmp/ariang.zip "https://github.com/mayswind/AriaNg/releases/download/${VERSION}/AriaNg-${VERSION}.zip" && \
    unzip -o -d /app/var/www /tmp/ariang.zip && \
    rm -rf /tmp/*
