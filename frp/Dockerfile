FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="0.37.0"

RUN set -ex && \
    DLINK="https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_$(arch).tar.gz" && \
    cd /tmp && \
    wget -O- $DLINK | tar xz --strip-components 1 && \
    mv frpc frps /app/bin/ && \
    rm -rf /tmp/*

WORKDIR /app/etc/

CMD ["frps", "-v"]
