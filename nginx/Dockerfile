FROM jinnlynn/alpine:gnu

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

COPY rootfs/ /

RUN set -ex && \
    apk add --no-cache nginx gettext && \
    rm -rf /var/www/* && \
    echo "it's work." >/var/www/index.html && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /app/opt/nginx/nginx.rc /nginx.rc

# COPY default.conf /etc/nginx/http.d/
# COPY entrypoint.rc.sh /entrypoint.rc
# COPY entrypoint.d/ /app/opt/entrypoint.d/
# COPY entrypoint.sh /app/bin/entrypoint

EXPOSE 80 443

ENTRYPOINT ["nginx-init"]

CMD ["nginx", "-g", "daemon off;"]
