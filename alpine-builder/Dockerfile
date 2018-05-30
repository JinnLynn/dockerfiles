FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV ALPINE_RELEASE="3.6 3.7 edge"
ENV ALPINE_LATEST="3.7"
ENV ALPINE_ARCH="x86_64 armhf"
ENV ALPINE_MIRROR="https://mirrors.ustc.edu.cn/alpine/"
ENV ALPINE_OUTPUT="/app/local"

RUN set -ex && \
    apk add --no-cache bash curl

COPY Dockerfile.tpl init.tpl /app/etc/
COPY mkrootfs.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]
