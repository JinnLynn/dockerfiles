FROM jinnlynn/alpine

MAINTAINER JinnLynn <eatfishlin@gmail.com>

RUN set -ex && \
    apk add --no-cache aria2

VOLUME /app/run

EXPOSE 6800

CMD aria2c --help
