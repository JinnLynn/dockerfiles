FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="20231012"

RUN set -ex && \
    ARCH=$(xinfo --armv7 arm7 --armv6 arm6 --armv5 arm5) && \
    DLINK=https://github.com/xtaci/kcptun/releases/download/v${VERSION}/kcptun-linux-${ARCH}-${VERSION}.tar.gz && \
    wget -O- $DLINK | tar xz -C /app/bin && \
    cd /app/bin && \
    ln -sf server_linux_${ARCH} kcptun-server && \
    ln -sf client_linux_${ARCH} kcptun-client

CMD ["kcptun-server", "--help"]
