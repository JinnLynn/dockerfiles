FROM jinnlynn/alpine AS BUILDER

ARG VERSION="0.73"

RUN set -ex && \
    apk add --no-cache build-base autoconf automake && \
    wget -O- "https://github.com/samhocevar/rinetd/releases/download/v${VERSION}/rinetd-${VERSION}.tar.gz" | \
        tar xz -C /tmp --strip-components 1 && \
    cd /tmp && \
    ./bootstrap && \
    ./configure --prefix=/usr && \
    make -j $(nproc)

# ===
FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

COPY --from=BUILDER /tmp/rinetd /app/bin/
COPY --from=BUILDER /tmp/rinetd.conf /app/etc/
COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT /app/bin/entrypoint
