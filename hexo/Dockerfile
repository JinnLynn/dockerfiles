FROM jinnlynn/node

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache openrc git && \
    npm install -g hexo-cli hexo-server

ENTRYPOINT ["hexo"]

CMD ["version"]
