# NOTE: 只能在ubuntu WHY?
FROM jinnlynn/ubuntu

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION

RUN set -ex && \
    DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt install -y wget && \
    wget -O- "https://github.com/alist-org/alist-proxy/releases/download/v${VERSION}/alist-proxy_${VERSION}_linux_$(xinfo).tar.gz" \
        | tar xz -C /tmp && \
    mv /tmp/alist-proxy /app/bin/ && \
    cleanup

COPY proxy.entrypoint.sh /app/bin/entrypoint

CMD ["entrypoint"]
