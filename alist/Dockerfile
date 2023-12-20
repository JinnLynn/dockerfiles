FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION

RUN set -ex && \
    ARCH=$(xinfo --armv7 arm-7 --armv6 arm-6) && \
    DLINK=https://github.com/alist-org/alist/releases/download/v${VERSION}/alist-linux-${ARCH}.tar.gz && \
    wget -O- $DLINK | tar xz -C /app/bin

CMD ["alist", "server", "--data=/app/local"]
