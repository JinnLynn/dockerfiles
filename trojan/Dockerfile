FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=1.15.1

RUN set -ex &&\
    cd /tmp && \
    wget -O- "https://github.com/trojan-gfw/trojan/archive/v${VERSION}.tar.gz" | tar xz && \
    apk add --no-cache --virtual .build-deps \
        build-base \
        cmake \
        boost-dev \
        openssl-dev \
        mariadb-connector-c-dev && \
    cd trojan-* && \
    cmake . && make && strip -s trojan && \
    mv trojan /app/bin/ && \
    runDeps="$( \
        scanelf --needed --nobanner /app/bin/trojan \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del --no-cache .build-deps && \
    rm -rf /tmp/*

CMD ["trojan", "--help"]
