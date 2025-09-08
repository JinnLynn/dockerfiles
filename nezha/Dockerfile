FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=0.19.13

RUN set -ex && \
    wget -O /tmp/nezha.zip https://github.com/naiba/nezha/releases/download/v${VERSION}/dashboard-linux-amd64.zip && \
    unzip /tmp/nezha.zip -d /tmp && \
    mv /tmp/dashboard-* /app/bin/nezha && \
    rm -rf /tmp/*

WORKDIR /app/local

VOLUME ["/app/local/data"]

ENTRYPOINT ["nezha"]
