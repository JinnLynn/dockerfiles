FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache ffmpeg ca-certificates aria2

ARG VERSION="2021.12.17"

RUN set -ex && \
    pip install --no-cache-dir "youtube-dl${VERSION:+==$VERSION}"

ENTRYPOINT ["youtube-dl"]

CMD ["--version"]
