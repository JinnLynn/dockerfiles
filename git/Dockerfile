FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache git

WORKDIR /app/local

ENTRYPOINT ["git"]

CMD ["--version"]
