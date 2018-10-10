FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=18.06.0
ARG MIRROR

RUN set -ex && \
    ARCH=$(arch --amd64 x86_64 --arm armhf --arm64 aarch64) && \
    DLINK="${MIRROR:-https://mirrors.ustc.edu.cn/docker-ce}/linux/static/stable/${ARCH}/docker-${VERSION}-ce.tgz" && \
    wget -O- $DLINK | tar xz --strip-components 1 -C /app/bin

# 运行时需挂载 /var/run/docker.sock
ENTRYPOINT ["docker"]

CMD ["version"]
