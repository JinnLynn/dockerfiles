FROM jinnlynn/nginx

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache nginx-mod-stream && \
    echo -e "\nstream {\n\tinclude /etc/nginx/conf.stream.d/*.conf;\n}" >>/etc/nginx/nginx.conf && \
    mkdir -p /etc/nginx/conf.stream.d
