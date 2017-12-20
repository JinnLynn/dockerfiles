FROM jinnlynn/httpd

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG URI=https://github.com/ziahamza/webui-aria2/archive/master.zip

RUN set -ex && \
    apk add --no-cache curl && \
    cd /tmp && \
    curl -SL -o t.zip $URI && \
    unzip -qo t.zip && \
    mv webui-aria2-*/* /app/var/www/ && \
    apk del --no-cache curl && \
    rm -rf /tmp/*
