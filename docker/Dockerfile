FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG DOCKER_VERSION=18.03.1
ARG MIRROR=https://mirrors.ustc.edu.cn/docker-ce

RUN set -ex && \
    DLINK="$MIRROR/linux/static/stable/$(arch)/docker-$DOCKER_VERSION-ce.tgz" && \
    cd /tmp && \
    apk add --no-cache curl tar && \
    curl -fL -o docker.tgz $DLINK && \
    tar --extract \
        --file docker.tgz \
        --strip-components 1 \
        --directory /app/bin/ && \
    apk del --no-cache curl tar && \
    rm -rf /tmp/*

# 运行时需挂载 /var/run/docker.sock
ENTRYPOINT ["docker"]

CMD ["version"]
