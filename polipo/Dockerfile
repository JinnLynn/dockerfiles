FROM jinnlynn/alpine

MAINTAINER JinnLynn <eatfishlin@gmail.com>

ARG SC_URL=https://github.com/jech/polipo/archive/master.zip

RUN set -ex && \
    cd /tmp && \
    apk add --no-cache --virtual .build-deps curl build-base openssl && \
    curl -SL -o polipo.zip $SC_URL && \
    unzip -q polipo.zip && \
    cd polipo-master && \
    make && \
    install polipo /usr/local/bin/ && \
    cd .. &&\
    mkdir -p /usr/share/polipo/www /var/cache/polipo && \
    rm -rf /tmp/* && \
    apk del .build-deps

EXPOSE 8123

CMD polipo proxyAddress=0.0.0.0

