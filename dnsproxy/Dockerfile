FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION

RUN set -ex && \
    ARCH="$(xinfo --armv6 arm6 --armv7 arm6)" && \
    wget -O- https://github.com/AdguardTeam/dnsproxy/releases/download/v${VERSION}/dnsproxy-linux-${ARCH}-v${VERSION}.tar.gz
