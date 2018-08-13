FROM jinnlynn/alpine:3.7

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG SS_VER=2.5.6
ARG SS_URL="https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz"

RUN set -ex && \
    cd /tmp && \
    apk update && \
    apk add --virtual .build-deps \
                    curl \
                    tar \
                    build-base \
                    autoconf \
                    linux-headers \
                    openssl-dev \
                    pcre-dev && \
    curl -SL $SS_URL | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    cd .. && \
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
