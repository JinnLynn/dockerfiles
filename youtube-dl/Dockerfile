FROM jinnlynn/python

MAINTAINER JinnLynn <eatfishlin@gmail.com>

RUN set -ex && \
    pip install -U --no-cache-dir pip youtube-dl && \
    apk add --no-cache ffmpeg ca-certificates

ENTRYPOINT ["youtube-dl"]

CMD ["--help"]
