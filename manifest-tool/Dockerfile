FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=1.0.1

RUN set -ex && \
    apk add --no-cache ca-certificates && \
    DLINK="https://github.com/estesp/manifest-tool/releases/download/v${VERSION}/manifest-tool-linux-$(arch --arm armv7)" && \
    wget -O /app/bin/manifest-tool $DLINK && \
    chmod +x /app/bin/manifest-tool

ENTRYPOINT ["manifest-tool"]

CMD ["-v"]
