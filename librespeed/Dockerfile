FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=1.1.4

RUN set -ex && \
    wget -O- https://github.com/librespeed/speedtest-go/releases/download/v${VERSION}/speedtest-go_${VERSION}_linux_$(arch --arm armv7).tar.gz \
        | tar xz -C /tmp && \
    mv /tmp/speedtest-backend /app/bin/ && \
    mv /tmp/settings.toml /app/etc/ && \
    rm -rf /tmp/*

CMD [ "speedtest-backend", "-c", "/app/etc/settings.toml" ]
