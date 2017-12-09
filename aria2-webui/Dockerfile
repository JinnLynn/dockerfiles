FROM jinnlynn/alpine

MAINTAINER JinnLynn <eatfishlin@gmail.com>

ARG URI=https://github.com/ziahamza/webui-aria2/archive/master.zip

RUN set -ex && \
    apk update && \
    apk add curl && \
    curl -SL -o /tmp/webui.zip $URI && \
    unzip -q -d /app/opt /tmp/webui.zip && \
    mv /app/opt/webui-aria2-* /app/opt/aria2-webui && \
    apk del curl && \
    rm -rf /tmp/* /var/cache/apk/*

WORKDIR /app/opt/aria2-webui

EXPOSE 80

CMD ["httpd", "-f"]
