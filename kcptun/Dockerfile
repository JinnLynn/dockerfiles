FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="20210624"
ARG ARM="arm7"

RUN set -ex && \
    DLINK=https://github.com/xtaci/kcptun/releases/download/v${VERSION}/kcptun-linux-$(arch --arm ${ARM})-${VERSION}.tar.gz && \
    wget -O- $DLINK | tar xz -C /app/bin && \
    cd /app/bin && \
    ln -sf server_linux_$(arch --arm ${ARM}) kcptun-server && \
    ln -sf client_linux_$(arch --arm ${ARM}) kcptun-client

CMD ["kcptun-server", "--help"]
