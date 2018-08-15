FROM jinnlynn/flask

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache --virtual .build-deps build-base linux-headers python-dev libffi-dev && \
    pip install -U --no-cache-dir httpbin && \
    apk del --no-cache .build-deps

CMD ["uwsgi", "--socket", ":8000", "--module", "httpbin:app"]
