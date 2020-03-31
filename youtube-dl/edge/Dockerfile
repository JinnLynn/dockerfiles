FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV REPO_DIR="/app/opt/youtube-dl"

COPY entrypoint.sh /app/bin/entrypoint

RUN set -ex && \
    apk add --no-cache ffmpeg ca-certificates aria2 git && \
    git clone --progress --recurse-submodules --depth 1 --single-branch https://github.com/ytdl-org/youtube-dl.git ${REPO_DIR} && \
    pip install -e ${REPO_DIR}

ENTRYPOINT ["entrypoint"]

CMD ["--help"]
