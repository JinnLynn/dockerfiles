FROM jinnlynn/httpd

ARG VERSION="1.94.1"

RUN set -ex && \
    wget -O /tmp/zashboard.zip https://github.com/Zephyruso/zashboard/releases/download/v${VERSION}/dist.zip && \
    unzip -o -d /tmp/ /tmp/zashboard.zip && \
    mv /tmp/dist/* /app/var/www/ && \
    rm -rf /tmp/*
