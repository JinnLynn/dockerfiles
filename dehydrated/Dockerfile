FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=0.6.2

# alpine中的awk, grep等命令为busybox版本不适合dehydrated，需另外安装
RUN set -ex && \
    DLINK="https://github.com/lukas2511/dehydrated/releases/download/v$VERSION/dehydrated-$VERSION.tar.gz" && \
    apk add --no-cache bash curl jq openssl gawk sed grep diffutils && \
    curl -SL $DLINK | tar xz -C /app/bin --strip-components 1 dehydrated-$VERSION/dehydrated && \
    chmod +x /app/bin/dehydrated

ENTRYPOINT ["dehydrated"]

CMD ["-h"]
