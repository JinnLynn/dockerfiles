FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="1.29.2"

# Docker 1.90.0后run和exec需要通过docker执行, 设置环境变量可忽略
# REF: https://github.com/docker/compose/blob/master/CHANGELOG.md#1190-2018-02-07
ENV COMPOSE_INTERACTIVE_NO_CLI=true

RUN set -ex && \
    apk add --no-cache py3-pynacl py3-bcrypt py3-cryptography && \
    pip install --no-cache-dir "docker-compose${VERSION:+==$VERSION}" && \
    docker-compose

ENTRYPOINT ["docker-compose"]

CMD ["version"]
