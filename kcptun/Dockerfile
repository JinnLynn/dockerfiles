FROM jinnlynn/alpine

MAINTAINER JinnLynn <eatfishlin@gmail.com>

ARG KCPTUN_VER=20171021
ARG KCPTUN_FILE=kcptun-linux-amd64-$KCPTUN_VER.tar.gz
ARG KCPTUN_URL=https://github.com/xtaci/kcptun/releases/download/v$KCPTUN_VER/$KCPTUN_FILE

RUN set -ex && \
    apk add --no-cache curl && \
    curl -SL $KCPTUN_URL | tar xz -C /app/bin && \
    apk del --no-cache curl

CMD ["server_linux_amd64", "--help"]
