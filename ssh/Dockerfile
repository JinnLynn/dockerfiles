FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache openssh

COPY entrypoint.sh /app/bin/entrypoint
COPY ssh-shell.sh /app/bin/ssh-shell

ENTRYPOINT ["entrypoint"]
