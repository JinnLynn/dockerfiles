FROM jinnlynn/alpine AS builder

ARG VERSION=1.17.1

# rm /usr/include/sys/inotify.h && \
RUN apk add --no-cache autoconf alpine-sdk && \
    wget -O- https://github.com/emcrisostomo/fswatch/releases/download/${VERSION}/fswatch-${VERSION}.tar.gz | tar xz -C /tmp && \
    cd /tmp/fswatch-${VERSION}/ && \
    ./configure && \
    make && \
    make install

FROM jinnlynn/alpine
COPY --from=builder /usr/local/bin/fswatch /usr/local/bin/fswatch
COPY --from=builder /usr/local/lib/libfswatch.so* /usr/local/lib/
