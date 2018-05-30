# alpine 3.7 httpd被移到busybox-extras中
# https://git.alpinelinux.org/cgit/aports/commit/main/busybox?id=23f4c6bd6c0c8c8f616facad94865e7961cdfb2d
#
FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache busybox-extras && \
    mkdir -p /app/var/www && \
    echo "it's work." >/app/var/www/index.html

COPY httpd.conf /etc/httpd.conf

WORKDIR /app/var/www

EXPOSE 80

CMD ["httpd", "-f", "-vv"]
