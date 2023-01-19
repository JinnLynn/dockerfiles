FROM jinnlynn/alpine:gnu

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="2.7.0"

RUN set -ex && \
    wget -O /app/bin/script_exporter https://github.com/ricoberger/script_exporter/releases/download/v${VERSION}/script_exporter-linux-$(xinfo) && \
    chmod +x /app//bin/script_exporter && \
    ln -sf /dev/stdout /var/log/script-exporter.log

ENTRYPOINT [ "script_exporter" ]
