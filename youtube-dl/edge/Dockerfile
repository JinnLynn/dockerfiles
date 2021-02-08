FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG REPO_REMOTE="https://github.com/ytdl-org/youtube-dl.git"

COPY entrypoint.sh /app/bin/entrypoint

RUN set -ex && \
    apk add --no-cache ffmpeg ca-certificates aria2 git && \
    entrypoint --version

ENTRYPOINT ["entrypoint"]

CMD ["--version"]
