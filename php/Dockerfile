FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache php7-apache2 php7-gd php7-json php7-mysqli php7-zip \
                                    php7-openssl php7-mcrypt php7-mbstring && \
    sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf && \
    sed -i "s#^DocumentRoot \".*#DocumentRoot \"/app/var/www\"#g" /etc/apache2/httpd.conf && \
    sed -i "s#/var/www/localhost/htdocs#/app/var/www#" /etc/apache2/httpd.conf && \
    printf "\n<Directory \"/app/var/www\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf && \
    sed -i "s/#ServerName www.example.com:80/ServerName 0.0.0.0/" /etc/apache2/httpd.conf && \
    mkdir -p /run/apache2 /app/var/www && \
    echo "<?php phpinfo(); ?>" >/app/var/www/index.php && \
    ln -sfT /dev/stderr /var/log/apache2/error.log && \
    ln -sfT /dev/stdout /var/log/apache2/access.log

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]
