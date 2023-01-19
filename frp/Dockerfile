FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION

RUN set -ex && \
    wget -O- "https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_$(xinfo arch).tar.gz" \
        | tar xz --strip-components 1 -C /tmp && \
    mv /tmp/frpc /tmp/frps /app/bin/ && \
    rm -rf /tmp/*

WORKDIR /app/etc/

CMD ["frps", "-v"]
