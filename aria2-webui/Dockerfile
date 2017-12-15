FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG URI=https://github.com/ziahamza/webui-aria2/archive/master.zip

# alpine 3.7 httpd被移到busybox-extras中
# https://git.alpinelinux.org/cgit/aports/commit/main/busybox?id=23f4c6bd6c0c8c8f616facad94865e7961cdfb2d
RUN set -ex && \
    apk update && \
    apk add curl busybox-extras && \
    curl -SL -o /tmp/webui.zip $URI && \
    unzip -q -d /app/opt /tmp/webui.zip && \
    mv /app/opt/webui-aria2-* /app/opt/aria2-webui && \
    apk del curl && \
    echo -e "A:*\n.js:application/javascript" >/app/etc/httpd.conf && \
    rm -rf /tmp/* /var/cache/apk/*

WORKDIR /app/opt/aria2-webui

EXPOSE 80

CMD ["httpd", "-f", "-c", "/app/etc/httpd.conf"]
