FROM jinnlynn/git

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache openssh && \
    rm -rf /etc/ssh/ssh_host_*_key /etc/motd

COPY entrypoint.sh /app/bin/entrypoint
COPY git-shell-commands /app/etc/git-shell-commands

WORKDIR /app/local

EXPOSE 22

ENTRYPOINT ["entrypoint"]

CMD ["/usr/sbin/sshd","-D"]
