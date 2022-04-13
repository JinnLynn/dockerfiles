FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="1.1.1"

RUN set -ex && \
    ARCH=$(apk --print-arch) && \
    [[ "$ARCH" == "armv7" ]] && ARCH=armhf || true && \
    DLINK=https://install.speedtest.net/app/cli/ookla-speedtest-${VERSION}-linux-${ARCH}.tgz && \
    wget -O- $DLINK | tar xz -C /app/bin/ && \
    speedtest --version

ENTRYPOINT ["speedtest", "--accept-license"]
