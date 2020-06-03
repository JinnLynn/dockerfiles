# NOTE: PY_VERSION值有效范围只到FROM
ARG PY_VERSION
FROM jinnlynn/python${PY_VERSION:+":$PY_VERSION"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="1.1.2"

# uwsgi 通过apk安装时需使用--plugin, 但alpine 3.11后已无python2插件
# 通过pip安装无上述问题，但在arm架构下编译耗时
RUN set -ex && \
    apk add --no-cache uwsgi uwsgi-python && \
    pip install --no-cache-dir -U pip "flask${VERSION:+==$VERSION}"

COPY app.py /app/opt/app.py
COPY entrypoint.sh /app/bin/entrypoint

WORKDIR /app/opt

EXPOSE 8000

ENTRYPOINT ["entrypoint"]
