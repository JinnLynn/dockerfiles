FROM jinnlynn/httpd

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    DLINK="https://github.com/mayswind/AriaNg-DailyBuild/archive/master.tar.gz" && \
    apk add --no-cache curl && \
    mkdir -p /app/var/www && \
    curl -SL "$DLINK" | tar xz --strip-components 1 -C /app/var/www && \
    apk del --no-cache curl
