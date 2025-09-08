FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache openssh

COPY ssh-init.sh /app/bin/ssh-init
COPY ssh-shell.sh /app/bin/ssh-shell

ENTRYPOINT ["ssh-init"]
