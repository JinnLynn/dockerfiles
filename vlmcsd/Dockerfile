FROM jinnlynn/alpine as builder

ARG VERSION="svn1113"

WORKDIR /tmp

RUN apk add --no-cache git make build-base && \
    wget -O- https://github.com/Wind4/vlmcsd/archive/refs/tags/${VERSION}.tar.gz | tar xz --strip 1 && \
    make


# ===
FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

COPY --from=builder /tmp/bin/vlm* /app/bin/

EXPOSE 1688/tcp

CMD [ "vlmcsd", "-D", "-d", "-v", "-e" ]
