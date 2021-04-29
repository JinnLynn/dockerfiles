FROM jinnlynn/flask

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG COMMIT_HASH="f8ec666"
#

RUN set -ex && \
    apk add --no-cache --virtual .build-deps build-base linux-headers $(py-release)-dev libffi-dev && \
    pip install --no-cache-dir "https://github.com/postmanlabs/httpbin/tarball/${COMMIT_HASH}#httpbin" && \
    apk del --no-cache .build-deps

ENV UWSGI_MOUNT="/=httpbin:app"
