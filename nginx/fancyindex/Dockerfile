FROM jinnlynn/nginx

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache nginx-mod-http-fancyindex gettext && \
    rm -rf /etc/nginx/http.d/default.conf && \
    mkdir -p /var/www/Nginx-Fancyindex-Theme/

COPY theme/ /var/www/Nginx-Fancyindex-Theme/
COPY fancyindex-tpl.conf /app/etc/
COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]
