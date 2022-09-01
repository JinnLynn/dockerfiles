FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=3.1.2.1

RUN set -ex && \
    DLINK=https://github.com/just-containers/s6-overlay/releases/download/v${VERSION} && \
    ARCH=$(xinfo --amd64 x86_64 --arm64 aarch64 --armv7 armhf --armv6 arm --armv5 arm ) && \
    wget -O- $DLINK/s6-overlay-noarch.tar.xz | tar xJ -C / && \
    wget -O- $DLINK/s6-overlay-${ARCH}.tar.xz | tar xJ -C /

ENTRYPOINT ["init"]
