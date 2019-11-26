FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="20191112"
ARG ARM="arm7"

RUN set -ex && \
    DLINK=https://github.com/xtaci/kcptun/releases/download/v${VERSION}/kcptun-linux-$(arch --arm ${ARM})-${VERSION}.tar.gz && \
    wget -O- $DLINK | tar xz -C /app/bin && \
    ln -s /app/bin/server_linux_$(arch --arm ${ARM}) /app/bin/kcptun-server && \
    ln -s /app/bin/client_linux_$(arch --arm ${ARM}) /app/bin/kcptun-client

CMD ["kcptun-server", "--help"]
