FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="0.14.50"

RUN set -ex && \
    PKG="syncthing-linux-$(arch)-v${VERSION}" && \
    DLINK="https://github.com/syncthing/syncthing/releases/download/v${VERSION}/$PKG.tar.gz" && \
    wget -O- $DLINK | tar xz --strip-component 1 -C /app/bin $PKG/syncthing
EXPOSE 8384 22000

VOLUME /app/local

#                        配置文件保存目录       强制开放gui
ENTRYPOINT ["syncthing", "--home=/app/local", "--gui-address=0.0.0.0:8384"]

CMD ["--verbose"]
