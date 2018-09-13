FROM ubuntu:18.04

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR="https://mirrors.ustc.edu.cn/ubuntu/"
ARG MIRROR_PORTS="https://mirrors.ustc.edu.cn/ubuntu-ports/"
ARG TIMEZONE="Asia/Shanghai"
ARG APP_DIRS="bin etc opt mnt local log tmp var"

RUN set -ex && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qy && \
    apt-get install -qy apt-transport-https ca-certificates tzdata && \
    rm /etc/localtime && \
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo "$TIMEZONE" >/etc/timezone && \
    apt-get remove -qy tzdata && \
    rm -rf /var/lib/apt && \
    ARCH=$(dpkg --print-architecture) && \
    [ "$ARCH" != "i386" -a "$ARCH" != "amd64" ] && MIRROR=$MIRROR_PORTS || true && \
    . /etc/os-release && \
    echo "deb $MIRROR $UBUNTU_CODENAME main restricted universe multiverse" >/etc/apt/sources.list && \
    echo "deb $MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb $MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb $MIRROR $UBUNTU_CODENAME-backports main restricted universe multiverse" >>/etc/apt/sources.list && \
    [ -n "$APP_DIRS" ] && for d in $APP_DIRS; do mkdir -p /app/$d; done || true

COPY arch.sh /app/bin/arch

ENV PATH=/app/bin:$PATH

CMD ["/bin/bash"]
