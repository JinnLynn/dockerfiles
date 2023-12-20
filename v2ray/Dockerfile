FROM jinnlynn/alpine AS DL

# 在docker-bake.hcl文件中设定
ARG VERSION

RUN set -ex && \
    ARCH=$(xinfo --amd64 64 --arm64 arm64-v8a --armv7 arm32-v7a --armv6 arm32-v6 --386 32) && \
    DLINK="https://github.com/v2fly/v2ray-core/releases/download/v${VERSION}/v2ray-linux-${ARCH}.zip" && \
    apk add --no-cache openssl ca-certificates unzip && \
    cd /tmp && \
    wget -O v2ray.zip $DLINK && \
    unzip -q v2ray.zip

    # wget -O v2ray.zip.dgst "${DLINK}.dgst" && \
    # [ "$(openssl dgst -sha512 v2ray.zip | sed 's/([^)]*)//g' | awk '{print $2}')" == "$(cat v2ray.zip.dgst | grep 'SHA512' | head -n1 | awk '{print $2}')" ] && \
    # unzip -q v2ray.zip


FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

COPY --from=DL /tmp/v2ray /app/bin/
COPY --from=DL /tmp/geo* /usr/local/share/v2ray/
COPY --from=DL /tmp/config.json /app/etc

RUN apk add --no-cache tzdata && chmod +x /app/bin/v2ray

ENTRYPOINT [ "v2ray" ]

CMD ["run", "-c", "/app/etc/config.json"]
