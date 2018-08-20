FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="0.20.0"

RUN set -ex && \
    DLINK="https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_$(arch --go).tar.gz" && \
    wget -O- $DLINK | tar xz --strip-components 1 --exclude */LICENSE -C /app/bin

EXPOSE 80 443 7000 7500

CMD ["frps", "-v"]
