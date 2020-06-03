FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION=1.6.7

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

RUN set -ex && \
    pip install --no-cache-dir "bypy${VERSION:+==$VERSION}"

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]
