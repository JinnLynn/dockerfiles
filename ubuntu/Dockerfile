ARG BASE
FROM ${BASE}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR="https://mirrors.aliyun.com/ubuntu/"
# Aliyun镜像站的ubuntu-ports似乎很久没更新
ARG MIRROR_PORTS="https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/"
ARG TIMEZONE="Asia/Shanghai"
ARG APP_DIRS="bin etc opt mnt local log tmp var"

ENV PATH=/app/bin:$PATH

SHELL ["/bin/bash", "-c"]

COPY arch.sh cleanup.sh /tmp/

RUN set -ex && \
    DEBIAN_FRONTEND=noninteractive && \
    cd /tmp && \
    [ -n "$APP_DIRS" ] && for d in $APP_DIRS; do mkdir -p /app/$d; done || true && \
    mv arch.sh /app/bin/arch && \
    mv cleanup.sh /app/bin/cleanup && \
    chmod +x /app/bin/arch /app/bin/cleanup && \
    apt-get update -qy && \
    apt-get install -qy apt-transport-https ca-certificates tzdata && \
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo "$TIMEZONE" >/etc/timezone && \
    apt-get remove -qy tzdata && \
    ARCH=$(arch) && \
    [ "${ARCH:0:3}" == "arm" ] && MIRROR=$MIRROR_PORTS || true && \
    . /etc/os-release && \
    echo "deb $MIRROR $UBUNTU_CODENAME main restricted universe multiverse" >/etc/apt/sources.list && \
    echo "deb $MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb $MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb $MIRROR $UBUNTU_CODENAME-backports main restricted universe multiverse" >>/etc/apt/sources.list && \
    apt-get update -qy && \
    apt-get upgrade -y && \
    cleanup

CMD ["/bin/bash"]
