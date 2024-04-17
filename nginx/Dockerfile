FROM jinnlynn/alpine:gnu

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache nginx gettext && \
    rm -rf /var/www/* && \
    echo "it's work." >/var/www/index.html && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY default.conf /etc/nginx/http.d/
COPY entrypoint.common.sh /entrypoint.common
COPY entrypoint.d/ /etc/nginx/entrypoint.d/
COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
