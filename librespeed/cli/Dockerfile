FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=1.0.9

RUN set -ex && \
    wget -O- https://github.com/librespeed/speedtest-cli/releases/download/v${VERSION}/librespeed-cli_${VERSION}_linux_$(arch --arm armv7).tar.gz \
        | tar xz -C /app/bin/ --exclude LICENSE

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]
