# py3的预编译包目前只在edge分支中
FROM jinnlynn/alpine:edge

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

# 2020-04-20
ARG COMMIT_ID=d9fa43463ba478cdcaf27a9203f6337fbab816c1

RUN set -ex && \
    apk add --no-cache supervisor nginx python3 py3-pip py3-libvirt py3-lxml py3-numpy && \
    ln -sf python3 /usr/bin/python && \
    mkdir -p /run/nginx /app/opt/webvirtcloud/data && \
    cd /app/opt/webvirtcloud && \
    wget -O- https://github.com/retspen/webvirtcloud/archive/$COMMIT_ID.tar.gz \
        | tar xz --strip-components 1 -C /app/opt/webvirtcloud && \
    sed -i '/^lxml=.*/d' conf/requirements.txt && \
    sed -i '/^libvirt-python=.*/d' conf/requirements.txt && \
    pip install --no-cache-dir -i https://pypi.doubanio.com/simple/ -r conf/requirements.txt && \
    cp webvirtcloud/settings.py.template data/settings.py && \
    SECRET_KEY=$(python3 conf/runit/secret_generator.py) && \
    sed -r "s/SECRET_KEY = ''/SECRET_KEY = '"$SECRET_KEY"'/" -i data/settings.py && \
    sed -i "s|'db.sqlite3'|'data/db.sqlite3'|" data/settings.py && \
    ln -sf ../data/settings.py webvirtcloud/settings.py

COPY httpd.conf supervisord.conf /app/etc/
COPY default.conf /etc/nginx/conf.d/
COPY entrypoint.sh /app/bin/entrypoint

VOLUME ["/app/opt/webvirtcloud/data"]

WORKDIR /app/opt/webvirtcloud

CMD ["entrypoint"]
