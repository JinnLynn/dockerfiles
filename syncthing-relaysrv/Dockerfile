FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="0.14.48"

RUN set -ex && \
    PKG="strelaysrv-linux-$(arch --go)-v${VERSION}" && \
    DLINK="https://github.com/syncthing/relaysrv/releases/download/v${VERSION}/${PKG}.tar.gz" && \
    wget -O- $DLINK | tar xz --strip-component 1 -C /app/bin $PKG/strelaysrv

EXPOSE 22067

ENTRYPOINT ["strelaysrv", "--pools", "", "--protocol", "tcp4", "--keys", "/app/local"]
