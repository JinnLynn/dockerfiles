FROM jinnlynn/alpine as tools

ARG VERSION
FROM ubuntu${VERSION:+":$VERSION"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR="http://mirrors.aliyun.com/ubuntu/"
ARG MIRROR_PORTS="http://mirrors.aliyun.com/ubuntu-ports/"
ARG TIMEZONE="Asia/Shanghai"
ARG APP_DIRS

ENV PATH=/app/bin:$PATH
ENV LC_ALL=C.UTF-8

COPY --from=tools /app/bin/arch /app/bin/xinfo /app/bin/
COPY cleanup.sh /app/bin/cleanup

# REF: https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM

RUN set -ex && \
    DEBIAN_FRONTEND=noninteractive && \
    ARCH=$(arch) && \
    xinfo check amd64 || MIRROR=$MIRROR_PORTS && \
    . /etc/os-release && \
    echo "deb $MIRROR $UBUNTU_CODENAME main restricted universe multiverse" >/etc/apt/sources.list && \
    echo "deb $MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb $MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse" >>/etc/apt/sources.list && \
    mkdir -p /app && \
    cd /app && \
    mkdir -p ${APP_DIRS:-bin etc opt mnt local log tmp var} && \
    apt-get update -qy && \
    apt-get install -qy tzdata && \
    rm -rf /etc/localtime && \
    cp /usr/share/zoneinfo/${TIMEZONE:-Asia/Shanghai} /etc/localtime && \
    apt-get upgrade -y && \
    apt-get remove -qy tzdata && \
    cleanup

CMD ["/bin/bash"]
