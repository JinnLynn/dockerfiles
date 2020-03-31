FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=1.25.0

RUN set -ex && \
    apk add --no-cache --virtual .build-deps build-base linux-headers $(py_release)-dev libffi-dev openssl-dev && \
    pip install -U --no-cache-dir pip "docker-compose${VERSION:+==}${VERSION}" && \
    apk del --no-cache .build-deps && \
    docker-compose version

# 1.90.0后run和exec需要通过docker执行，通过设置环境变量COMPOSE_INTERACTIVE_NO_CLI可忽略
# REF: https://github.com/docker/compose/blob/master/CHANGELOG.md#1190-2018-02-07
ENV COMPOSE_INTERACTIVE_NO_CLI=true

ENTRYPOINT ["docker-compose"]

CMD ["version"]
