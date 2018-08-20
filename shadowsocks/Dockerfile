FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="3.2.0"

RUN set -ex && \
    DLINK=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v${VERSION}/shadowsocks-libev-${VERSION}.tar.gz && \
    cd /tmp && \
    apk update && \
    apk add --virtual .build-deps \
                    build-base \
                    autoconf \
                    linux-headers \
                    libev-dev \
                    libsodium-dev \
                    mbedtls-dev \
                    pcre-dev \
                    c-ares-dev && \
    wget -O- $DLINK | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    rm -rf /tmp/* /var/cache/apk/*

CMD ["ss-local", "-h"]
