FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=1.21.2
ARG URL=https://github.com/docker/compose/archive/$VERSION.tar.gz

# python setup.py 安装依赖包时无法使用国内源，易失败，预先使用pip install -r requirements.txt安装依赖
RUN set -ex && \
    cd /tmp && \
    apk add --no-cache curl && \
    curl -SL $URL | tar xz --strip 1 && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    python setup.py install && \
    apk del --no-cache curl && \
    rm -rf /tmp/*

ENTRYPOINT ["docker-compose"]

CMD ["--help"]
