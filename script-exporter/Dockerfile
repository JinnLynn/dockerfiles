FROM jinnlynn/alpine:gnu

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="2.14.1"

RUN set -ex && \
    wget -O /app/bin/script_exporter https://github.com/ricoberger/script_exporter/releases/download/v${VERSION}/script_exporter-linux-$(xinfo) && \
    chmod +x /app//bin/script_exporter

ENTRYPOINT [ "script_exporter" ]
