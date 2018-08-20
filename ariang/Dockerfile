FROM jinnlynn/httpd

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    DLINK="https://github.com/mayswind/AriaNg-DailyBuild/archive/master.tar.gz" && \
    mkdir -p /app/var/www && \
    wget -O- "$DLINK" | tar xz --strip-components 1 -C /app/var/www
