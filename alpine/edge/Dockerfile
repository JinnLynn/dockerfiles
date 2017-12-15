FROM scratch

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV PATH=/app/bin:$PATH

ADD rootfs-x86_64.tar.xz /
COPY init-x86_64 /tmp/init

RUN set -ex && \
    /tmp/init && \
    rm -rf /tmp/*

CMD ["/bin/sh"]
