FROM jinnlynn/alpine:gnu

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV GIT_USER=git GIT_USER_ID=1000 \
    GIT_GROUP=git GIT_GROUP_ID=1000

RUN set -ex && \
    apk add --no-cache git openssh util-linux

COPY entrypoint.sh /app/bin/entrypoint
COPY git-shell-commands /app/etc/git-shell-commands

WORKDIR /app/local

EXPOSE 22

ENTRYPOINT ["entrypoint"]
