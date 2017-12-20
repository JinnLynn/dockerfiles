FROM jinnlynn/httpd

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG URI=https://github.com/mayswind/AriaNg-DailyBuild/archive/master.zip

RUN set -ex && \
    apk add --no-cache curl && \
    cd /tmp && \
    curl -SL -o t.zip "$URI" && \
    unzip -qo t.zip && \
    mv AriaNg-*/* /app/var/www/ && \
    apk del --no-cache curl && \
    rm -rf /tmp/*
