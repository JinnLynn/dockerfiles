FROM jinnlynn/flask

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache --virtual .build-deps build-base linux-headers $(py-release)-dev libffi-dev && \
    pip install -U --no-cache-dir httpbin && \
    apk del --no-cache .build-deps

ENV UWSGI_MOUNT="/=httpbin:app"
