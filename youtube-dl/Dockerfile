FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache ffmpeg ca-certificates aria2

ARG VERSION="2020.03.24"

RUN set -ex && \
    pip install -U --no-cache-dir pip "youtube-dl${VERSION:+==}${VERSION}"

ENTRYPOINT ["youtube-dl", "--external-downloader", "aria2c", "--external-downloader-args", "--file-allocation=none --summary-interval=0 --max-connection-per-server=16"]

CMD ["--help"]
