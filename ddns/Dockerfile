FROM jinnlynn/alpine:3.21

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

COPY entrypoint.sh /app/bin/entrypoint

RUN set -ex && \
    apk add --no-cache bash libpsl-utils curl jq && \
    entrypoint --update-psl

ENTRYPOINT ["entrypoint"]

CMD ["--help"]
