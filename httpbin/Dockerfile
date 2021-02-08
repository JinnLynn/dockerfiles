FROM jinnlynn/flask

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="0.7.0"

RUN set -ex && \
    apk add --no-cache --virtual .build-deps build-base linux-headers $(py-release)-dev libffi-dev && \
    pip install --no-cache-dir "httpbin${VERSION:+==$VERSION}" && \
    apk del --no-cache .build-deps

ENV UWSGI_MOUNT="/=httpbin:app"
