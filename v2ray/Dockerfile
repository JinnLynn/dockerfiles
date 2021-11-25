FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="4.43.0"

RUN set -ex && \
    ARCH=$(arch --amd64 64 --arm64 arm64-v8a --arm arm32-v7a --386 32) && \
    DLINK="https://github.com/v2fly/v2ray-core/releases/download/v${VERSION}/v2ray-linux-${ARCH}.zip" && \
    echo $DLINK && \
    apk add --no-cache --virtual .build-deps openssl ca-certificates unzip && \
    apk add tzdata && \
    cd /tmp && \
    wget -O v2ray.zip $DLINK && \
    wget -O v2ray.zip.dgst ${DLINK}.dgst && \
    [ "$(openssl dgst -sha512 v2ray.zip | sed 's/([^)]*)//g')" == "$(cat v2ray.zip.dgst | grep 'SHA512' | head -n1)" ] && \
    unzip -q v2ray.zip && \
    chmod +x v2ray v2ctl && \
    mv v2ray v2ctl /app/bin && \
    mv geo*.dat /app/var && \
    mv config.json /app/etc && \
    rm -rf * && \
    apk del .build-deps

ENV V2RAY_LOCATION_ASSET=/app/var

CMD ["v2ray", "-h"]


