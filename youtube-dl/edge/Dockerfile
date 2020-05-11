FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV REPO_REMOTE="https://github.com/ytdl-org/youtube-dl.git"
ENV REPO_LOCAL="/app/opt/youtube-dl"

RUN set -ex && \
    apk add --no-cache ffmpeg ca-certificates aria2 git && \
    git clone --recurse-submodules --depth 1 --single-branch --progress ${REPO_REMOTE} ${REPO_LOCAL} && \
    pip install -e ${REPO_LOCAL}

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["--version"]
