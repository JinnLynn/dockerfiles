FROM scratch

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR
ARG TIMEZONE
ENV PATH=/app/bin:$PATH

ADD rootfs-__ARCH__.tar.xz /
COPY init-__ARCH__ /tmp/init

RUN set -ex && \
    /tmp/init && \
    rm -rf /tmp/*

CMD ["/bin/sh"]
