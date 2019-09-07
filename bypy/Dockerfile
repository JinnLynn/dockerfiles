FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

# 安装版本 >= 此设置
ARG VERSION=1.6.6

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

RUN set -ex && \
    apk add --no-cache --virtual .build-deps gcc python-dev musl-dev && \
    pip install --no-cache-dir "bypy${VERSION:+>=}${VERSION}" && \
    apk del --no-cache .build-deps

RUN set -ex && mkdir /.bypy

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]
