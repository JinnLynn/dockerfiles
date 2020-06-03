ARG VERSION
FROM ubuntu${VERSION:+":$VERSION"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR="https://mirrors.aliyun.com/ubuntu/"
# Aliyun镜像站的ubuntu-ports似乎很久没更新
ARG MIRROR_PORTS="https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/"
ARG TIMEZONE="Asia/Shanghai"
ARG APP_DIRS

ENV PATH=/app/bin:$PATH
ENV LC_ALL=C.UTF-8

SHELL ["/bin/bash", "-c"]

COPY arch.sh /app/bin/arch
COPY cleanup.sh /app/bin/cleanup

RUN set -ex && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qy && \
    apt-get install -qy apt-transport-https ca-certificates tzdata && \
    cp /usr/share/zoneinfo/${TIMEZONE:-Asia/Shanghai} /etc/localtime && \
    cd /app && \
    mkdir -p ${APP_DIRS:-bin etc opt mnt local log tmp var} && \
    ARCH=$(arch) && \
    [ "${ARCH:0:3}" == "arm" ] && MIRROR=$MIRROR_PORTS || true && \
    . /etc/os-release && \
    echo "deb $MIRROR $UBUNTU_CODENAME main restricted universe multiverse" >/etc/apt/sources.list && \
    echo "deb $MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb $MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb $MIRROR $UBUNTU_CODENAME-backports main restricted universe multiverse" >>/etc/apt/sources.list && \
    apt-get update -qy && \
    apt-get upgrade -y && \
    apt-get remove -qy tzdata && \
    cleanup

CMD ["/bin/bash"]
