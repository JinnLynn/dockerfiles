FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="1.18.4"
ARG RELAYSRV_VERSION="1.15.0"

RUN set -ex && \
    wget -O- https://github.com/syncthing/syncthing/releases/download/v${VERSION}/syncthing-linux-$(arch)-v${VERSION}.tar.gz \
        | tar xz --strip-components 1 -C /tmp && \
    wget -O- https://github.com/syncthing/relaysrv/releases/download/v${RELAYSRV_VERSION}/strelaysrv-linux-$(arch)-v${RELAYSRV_VERSION}.tar.gz \
        | tar xz --strip-components 1 -C /tmp && \
    mv /tmp/syncthing /tmp/strelaysrv /app/bin && \
    chmod +x /app/bin/syncthing /app/bin/strelaysrv && \
    rm -rf /tmp/*

CMD ["syncthing", "--version"]
