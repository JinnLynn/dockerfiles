FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache ffmpeg ca-certificates aria2 git

COPY entrypoint.sh /app/bin/entrypoint

ENV REPO_REMOTE="https://github.com/ytdl-org/youtube-dl.git"

ENTRYPOINT ["entrypoint"]

CMD ["version"]
