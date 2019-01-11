FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=1.23.2

RUN set -ex && \
    pip install -U --no-cache-dir pip "docker-compose${VERSION:+==}${VERSION}"

# 1.90.0后run和exec需要通过docker执行，通过设置环境变量COMPOSE_INTERACTIVE_NO_CLI可忽略
# REF: https://github.com/docker/compose/blob/master/CHANGELOG.md#1190-2018-02-07
ENV COMPOSE_INTERACTIVE_NO_CLI=true

ENTRYPOINT ["docker-compose"]

CMD ["version"]
