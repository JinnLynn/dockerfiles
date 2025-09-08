FROM jinnlynn/runit

ARG VERSION

RUN set -ex && \
    apk add --no-cache ca-certificates && \
    wget -O- "https://github.com/distribution/distribution/releases/download/v${VERSION}/registry_${VERSION}_linux_$(xinfo).tar.gz" \
        | tar xz -C /app/bin/ && \
    wget -O/app/bin/reg https://github.com/ttys3/reg/releases/download/v0.17.0/reg.linux-$(xinfo) && \
    chmod +x /app/bin/registry /app/bin/reg && \
    mkdir -p /var/lib/registry && \
    registry --version

COPY app /app/
