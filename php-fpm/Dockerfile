FROM jinnlynn/alpine

MAINTAINER JinnLynn <eatfishlin@gmail.com>

RUN set -ex && \
    apk add --no-cache php7-fpm php7-gd php7-mysqli php7-zlib && \
    mv /etc/php7/php-fpm.d/www.conf /etc/php7/php-fpm.d/00-www.conf

COPY deps/docker.conf /etc/php7/php-fpm.d/99-docker.conf

EXPOSE 9000

CMD ["php-fpm7"]
