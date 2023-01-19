FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache ffmpeg

ENTRYPOINT ["ffmpeg"]

CMD ["-h"]
