FROM jinnlynn/alpine

ARG VRESION=2.2.5

RUN set -ex && \
    ARCH=$(xinfo) && \
    wget -O /app/etc/ipv4.txt https://www.cloudflare-cn.com/ips-v4/ && \
    wget -O /app/etc/ipv6.txt https://www.cloudflare-cn.com/ips-v6/ && \
    wget -O- https://github.com/XIU2/CloudflareSpeedTest/releases/download/v${VRESION}/CloudflareST_linux_${ARCH}.tar.gz | \
        tar xz -C /app/tmp && \
    mv /app/tmp/CloudflareST /app/bin/ && \
    rm -rf /app/tmp/*

COPY entrypoint.sh /app/bin/entrypoint

WORKDIR /app/local

ENTRYPOINT ["entrypoint"]
