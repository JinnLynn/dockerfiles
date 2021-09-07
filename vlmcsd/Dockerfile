FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="svn1113"

RUN set -ex && \
    apk add --no-cache --virtual .build-deps make build-base && \
    cd /tmp && \
    wget -O- https://github.com/Wind4/vlmcsd/archive/refs/tags/${VERSION}.tar.gz | tar xz --strip 1 && \
    make && \
    cp bin/vlm* /app/bin/ && \
    apk del --no-cache .build-deps

EXPOSE 1688/tcp

CMD [ "vlmcsd", "-D", "-d", "-v", "-e" ]
