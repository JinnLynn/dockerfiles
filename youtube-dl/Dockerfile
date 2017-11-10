FROM jinnlynn/python

MAINTAINER JinnLynn <eatfishlin@gmail.com>

RUN set -ex && \
    pip install -U pip youtube-dl && \
    apk add --no-cache ffmpeg ca-certificates aria2

ENTRYPOINT ["youtube-dl"]

CMD ["--help"]
