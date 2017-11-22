FROM jinnlynn/shadowsocks:2.5.6

MAINTAINER JinnLynn <eatfishlin@gmail.com>

ARG KCPTUN_VER=20171021
ARG KCPTUN_FILE=kcptun-linux-amd64-$KCPTUN_VER.tar.gz
ARG KCPTUN_URL=https://github.com/xtaci/kcptun/releases/download/v$KCPTUN_VER/$KCPTUN_FILE

ENV KCPTUN_PORT     29900
ENV KCPTUN_ARGS     --mode fast2 --crypt none --mtu 1200 --nocomp --dscp 46

RUN set -ex && \
    cd /tmp && \
    apk add --no-cache curl supervisor && \
    curl -SL $KCPTUN_URL | tar xz -C /usr/local/bin && \
    apk del --no-cache curl && \
    rm -rf /tmp/* /var/cache/apk/*

ADD supervisord.conf /app/etc/supervisord.conf

EXPOSE $SS_PORT/tcp $SS_PORT/udp $KCPTUN_PORT/udp

CMD ["supervisord", "-n", "-c", "/app/etc/supervisord.conf"]
