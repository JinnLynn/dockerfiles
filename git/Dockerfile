FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache git && \
    git config --global init.defaultBranch master

WORKDIR /app/local

ENTRYPOINT ["git"]

CMD ["--version"]
