FROM jinnlynn/alpine:gnu

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

COPY rootfs/ /

RUN set -ex && \
    apk add --no-cache nginx gettext && \
    rm -rf /var/www/* && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

ENTRYPOINT ["nginx-init"]

CMD ["nginx", "-g", "daemon off;"]
