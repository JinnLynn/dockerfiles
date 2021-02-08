FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache ffmpeg ca-certificates aria2

ARG VERSION="2021.02.04.1"

RUN set -ex && \
    pip install -U --no-cache-dir pip "youtube-dl${VERSION:+==$VERSION}"

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["--version"]
