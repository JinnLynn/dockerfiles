FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

RUN set -ex && \
    apk add --no-cache --virtual .build-deps gcc python-dev musl-dev && \
    pip install --no-cache-dir bypy && \
    apk del --no-cache .build-deps

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]
