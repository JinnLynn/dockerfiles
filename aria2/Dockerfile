FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache aria2

COPY entrypoint.sh /app/bin/entrypoint

EXPOSE 6800 6900 6900/udp 6901 6901/udp

ENTRYPOINT ["entrypoint"]
