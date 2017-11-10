FROM jinnlynn/alpine

MAINTAINER JinnLynn <eatfishlin@gmail.com>

RUN set -ex && \
    apk add --no-cache nginx && \
    mkdir -p /run/nginx && \
    rm -rf /var/www/* && \
    echo "it's work." >/var/www/index.html

COPY deps/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD nginx -g "daemon off; pid /run/nginx/nginx.pid;"
