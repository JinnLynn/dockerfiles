FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="0.32.0"

RUN set -ex && \
    DLINK="https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_$(arch).tar.gz" && \
    cd /app/bin && \
    wget -O- $DLINK | tar xz --strip-components 1 --exclude */LICENSE && \
    chown root:root frp* && \
    mv *.ini /app/etc/

EXPOSE 80 443 7000 7500

CMD ["frps", "-v"]
