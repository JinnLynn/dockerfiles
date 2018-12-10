FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

# pip将安装 >= $VERSION 的版本
ARG VERSION="2018.12.09"

RUN set -ex && \
    pip install -U --no-cache-dir pip "youtube-dl${VERSION:+>=}${VERSION}" && \
    apk add --no-cache ffmpeg ca-certificates aria2

ENTRYPOINT ["youtube-dl", "--external-downloader", "aria2c", "--external-downloader-args", "--file-allocation=none --summary-interval=0"]

CMD ["--help"]
