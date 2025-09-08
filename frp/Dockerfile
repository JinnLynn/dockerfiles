FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION

RUN set -ex && \
    ARCH=$(xinfo --armv7 arm --armv6 arm) && \
    wget -O- "https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_${ARCH}.tar.gz" \
        | tar xz --strip-components 1 -C /tmp && \
    mv /tmp/frpc /tmp/frps /app/bin/ && \
    apk add --no-cache ca-certificates && \
    rm -rf /tmp/*

WORKDIR /app/etc/

CMD ["frps", "-v"]
