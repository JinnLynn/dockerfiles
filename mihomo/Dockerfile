FROM jinnlynn/alpine

ARG VERSION=1.19.13

RUN set -ex && \
    apk add --no-cache --virtual .dl-deps curl gzip && \
    curl -Lo- https://github.com/MetaCubeX/mihomo/releases/download/v${VERSION}/mihomo-linux-$(xinfo)-v${VERSION}.gz | \
        gzip -d >/app/bin/mihomo && \
    apk add  --no-cache  ca-certificates tzdata iptables && \
    apk del --no-cache .dl-deps && \
    chmod +x /app/bin/mihomo

CMD [ "mihomo"]
