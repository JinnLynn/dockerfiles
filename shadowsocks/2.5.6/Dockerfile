FROM jinnlynn/alpine

MAINTAINER JinnLynn <eatfishlin@gmail.com>

ARG SS_VER=2.5.6
ARG SS_URL="https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz"

ENV SS_ADDR     0.0.0.0
ENV SS_PORT     8388
ENV SS_PWD      ss_default_password
ENV SS_METHOD   aes-256-cfb
ENV SS_ARGS     -t 30 -d 8.8.8.8 --fast-open -u -A -v

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

EXPOSE $SS_PORT/tcp $SS_PORT/udp

CMD SS_VER=$(ss-server -h | head -n 2 | grep shadowsocks-libev | awk '{print $2}') \
    && SS_PWD=${SS_PWD:-$(head -n 5 /dev/urandom | md5sum | head -c 8)} \
    && echo "===============================================" \
    && echo "Shadowsocks is now ready for use!              " \
    && echo "                                               " \
    && echo "VERSION:   $SS_VER                             " \
    && echo "SERVER IP: $SS_ADDR                            " \
    && echo "PORT:      $SS_PORT                            " \
    && echo "PASSWORD:  $SS_PWD                             " \
    && echo "METHOD:    $SS_METHOD                          " \
    && echo "EXTRA ARGS:$SS_ARGS                            " \
    && echo "===============================================" \
    && ss-server -s $SS_ADDR \
                 -p $SS_PORT \
                 -k $SS_PWD \
                 -m $SS_METHOD \
                 $SS_ARGS
