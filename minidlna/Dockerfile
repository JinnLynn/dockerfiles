FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache minidlna findutils

COPY entrypoint.sh /app/bin/entrypoint

EXPOSE 1900/udp 8200

CMD ["entrypoint"]
