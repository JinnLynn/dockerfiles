FROM jinnlynn/php

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="4.6.1"

RUN set -ex && \
    DLINK="https://github.com/adolfintel/speedtest/archive/${VERSION}.tar.gz" && \
    cd /app/var/www && \
    wget -O- "$DLINK" | tar xz --strip-components 1 && \
    cp example-gauges.html index.html
