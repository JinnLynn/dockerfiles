FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG COMMIT_ID="4d42ca1b5849518762d110f34b6ce2e03d6df9ec"

RUN set -ex && \
    DLINK="https://github.com/jech/polipo/archive/${COMMIT_ID}.tar.gz" && \
    cd /tmp && \
    apk add --no-cache --virtual .build-deps build-base openssl && \
    wget -O- "$DLINK" | tar xz --strip-components 1 && \
    make && \
    install polipo /app/bin && \
    mkdir -p /usr/share/polipo/www /var/cache/polipo && \
    apk del --no-cache .build-deps && \
    rm -rf /tmp/*

EXPOSE 8123

ENTRYPOINT ["polipo", "proxyAddress=0.0.0.0"]
