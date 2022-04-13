FROM jinnlynn/ssh

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache autossh bash lsof

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT [ "entrypoint" ]
