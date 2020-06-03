FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache redis 'su-exec>=0.2' tzdata

COPY entrypoint.sh /app/bin/entrypoint

VOLUME /app/local
WORKDIR /app/local

EXPOSE 6379

ENTRYPOINT ["entrypoint"]

CMD ["redis-server"]
