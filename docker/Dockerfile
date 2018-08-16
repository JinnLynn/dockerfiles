FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=18.06.0
ARG MIRROR=

RUN set -ex && \
    DLINK="${MIRROR:-https://mirrors.ustc.edu.cn/docker-ce}/linux/static/stable/$(arch)/docker-${VERSION}-ce.tgz" && \
    apk add --no-cache curl && \
    curl -SL $DLINK | tar xz --strip-components 1 -C /app/bin && \
    apk del --no-cache curl

# 运行时需挂载 /var/run/docker.sock
ENTRYPOINT ["docker"]

CMD ["version"]
