FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="3.3.1"
ARG PLUGIN_V2RAY_VERSION="1.1.0"

RUN set -ex && \
    DLINK=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v${VERSION}/shadowsocks-libev-${VERSION}.tar.gz && \
    cd /tmp && \
    apk add --no-cache --virtual .build-deps \
                    build-base \
                    autoconf \
                    automake \
                    linux-headers \
                    libev-dev \
                    libsodium-dev \
                    mbedtls-dev \
                    pcre-dev \
                    c-ares-dev \
                    libtool \
                    zlib-dev \
                    openssl \
                    libpcre32 \
                    git && \
    mkdir shadowsocks && \
    cd shadowsocks && \
    wget -O- $DLINK | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    cd /tmp && \
    git clone --depth 1 --recurse-submodules https://github.com/shadowsocks/simple-obfs.git && \
    cd simple-obfs && \
    ./autogen.sh && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* /usr/bin/obfs-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    DLINK=https://github.com/shadowsocks/v2ray-plugin/releases/download/v${PLUGIN_V2RAY_VERSION}/v2ray-plugin-linux-$(arch)-v${PLUGIN_V2RAY_VERSION}.tar.gz && \
    cd /tmp && \
    wget -O- $DLINK | tar xz && \
    mv v2ray-plugin_linux_$(arch --arm arm7) /usr/bin/v2ray-plugin && \
    rm -rf /tmp/*

CMD ["ss-local", "-h"]
