FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG S6_VERSION="3.1.2.1"

RUN set -ex && \
    apk add --no-cache bash samba shadow tzdata avahi dbus && \
    DLINK=https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION} && \
    ARCH=$(xinfo --amd64 x86_64 --arm64 aarch64 --armv7 armhf --armv6 arm --armv5 arm) && \
    wget -O- $DLINK/s6-overlay-noarch.tar.xz | tar xJ -C / && \
    wget -O- $DLINK/s6-overlay-${ARCH}.tar.xz | tar xJ -C / && \
    mv /etc/samba/smb.conf /etc/samba/smb.conf.bak

COPY rootfs /

ENV SMB_UID=1000 SMB_GID=1000 \
    S6_KEEP_ENV=1 AVAHI_ENABLED=0

EXPOSE 137/udp 138/udp 139 445

HEALTHCHECK --interval=60s --timeout=15s \
            CMD smbclient -L \\localhost -U % -m SMB3

ENTRYPOINT ["/init"]
