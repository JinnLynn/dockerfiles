ARG VERSION
FROM ubuntu${VERSION:+":$VERSION"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR="https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
ARG MIRROR_PORTS="https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/"
ARG TIMEZONE="Asia/Shanghai"
ARG APP_DIRS

# REF: https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM

ENV PATH=/app/bin:$PATH
ENV LC_ALL=C.UTF-8

COPY cleanup.sh /app/bin/cleanup
COPY xinfo.sh /app/bin/xinfo

RUN set -ex && \
    DEBIAN_FRONTEND=noninteractive && \
    xinfo check amd64 || MIRROR=${MIRROR_PORTS} && \
    cp /etc/apt/sources.list /tmp/ && \
    cat /tmp/sources.list | egrep -v "(^#|-backports|-updates)" | grep "main" | tee /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y ca-certificates && \
    cat /tmp/sources.list | egrep -v "^(#|$)" | sed -E "s#http:[^\ ]*#${MIRROR%/}/#g" | tee /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -qy tzdata && \
    rm -rf /etc/localtime && \
    cp /usr/share/zoneinfo/${TIMEZONE:-Asia/Shanghai} /etc/localtime && \
    apt-get remove -qy tzdata && \
    printf '%s\n' ${APP_DIRS:-bin etc opt mnt local log tmp var} | xargs -ri mkdir -p /app/{} && \
    cleanup

CMD ["/bin/bash"]
