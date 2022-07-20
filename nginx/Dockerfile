FROM jinnlynn/alpine:gnu

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache nginx gettext && \
    # 启用conf.d目录 alpine 3.15将默认启用
    # REF: https://git.alpinelinux.org/aports/tree/main/nginx/nginx.conf?h=3.14-stable#n17
    sed -i "s/^#\(include .*\/conf.d\/\*.conf;\)/\1/g" /etc/nginx/nginx.conf && \
    mkdir -p /etc/nginx/conf.d/ /run/nginx/ && \
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
