FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache php7-fpm php7-gd php7-mysqli php7-zip && \
    mv /etc/php7/php-fpm.d/www.conf /etc/php7/php-fpm.d/00-www.conf && \
    mkdir /app/var/www && \
    echo "<?php phpinfo(); ?>" >/app/var/www/index.php

COPY docker.conf /etc/php7/php-fpm.d/99-docker.conf

WORKDIR /app/var/www

EXPOSE 9000

CMD ["php-fpm7"]
