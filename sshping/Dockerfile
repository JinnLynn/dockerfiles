FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG COMMIT_ID="22854b6229ae1a5f15685e9dcdb8de207148d154"

RUN set -ex && \
    DLINK=https://github.com/spook/sshping/archive/${COMMIT_ID}.tar.gz && \
    wget -O- ${DLINK} | tar xz --strip-components 1 -C /tmp && \
    cd /tmp && \
    apk add --no-cache --virtual .build-deps build-base libssh-dev && \
    make && \
    cp bin/sshping /app/bin/ && \
    RUN_DEPS="$( \
        scanelf --needed --nobanner /app/bin/sshping \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $RUN_DEPS && \
    apk del --no-cache .build-deps && \
    rm -rf /tmp/*

WORKDIR /app/etc

ENTRYPOINT ["sshping"]

CMD ["--help"]
