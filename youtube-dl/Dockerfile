FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    pip install -U --no-cache-dir pip youtube-dl && \
    apk add --no-cache ffmpeg ca-certificates aria2

ENTRYPOINT ["youtube-dl", "--external-downloader", "aria2c", "--external-downloader-args", "--file-allocation=none --summary-interval=0"]

CMD ["--help"]
