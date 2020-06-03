FROM --platform=amd64 golang:alpine AS builder

ARG VERSION=2.1.2.0120

ARG TARGETOS
ARG TARGETARCH

RUN set -ex && \
    DLINK=https://github.com/xteve-project/xTeVe/archive/${VERSION}.tar.gz && \
    apk add --no-cache git && \
    cd /tmp && \
    wget -O- ${DLINK} | tar xz --strip-components 1 && \
    go get github.com/koron/go-ssdp && \
    go get github.com/gorilla/websocket && \
    go get github.com/kardianos/osext && \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build xteve.go

# =====
FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

COPY --from=builder /tmp/xteve /app/bin/

CMD ["xteve"]
