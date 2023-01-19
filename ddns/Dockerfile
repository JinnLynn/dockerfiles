FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

COPY entrypoint.sh /app/bin/entrypoint

RUN set -ex && \
    apk add --no-cache bash libpsl curl jq && \
    entrypoint --update-psl

ENTRYPOINT ["entrypoint"]

CMD ["--help"]
