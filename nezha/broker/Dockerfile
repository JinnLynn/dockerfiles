FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=0.3.1

RUN set -ex && \
    wget -O /tmp/broker.zip https://github.com/uubulb/broker/releases/download/v0.3.1/broker_linux_amd64.zip && \
    unzip /tmp/broker.zip -d /app/bin/ && \
    rm -rf /tmp/*

ENTRYPOINT [ "broker" ]
