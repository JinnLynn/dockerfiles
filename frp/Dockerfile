FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG FRP_VERSION="0.20.0"

RUN set -ex && \
    DLINK="https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_$(arch --go).tar.gz" && \
    cd /tmp && \
    apk add --no-cache curl && \
    curl -SL $DLINK | tar xz && \
    cd frp_* && \
    cp frpc frps /app/bin && \
    cp *.ini /app/etc && \
    apk del --no-cache curl && \
    cd / && \
    rm -rf /tmp/*

EXPOSE 80 443 7000 7500

CMD frps -v