FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache socat

ENTRYPOINT ["socat"]

CMD ["-V"]
