FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache build-base linux-headers python-dev && \
    pip install --no-cache-dir flask uwsgi && \
    apk del --no-cache build-base linux-headers python-dev

ADD ./app.py /app/app.py

WORKDIR /app

EXPOSE 8000 9000 9000/udp

CMD uwsgi --http 0.0.0.0:8000 --socket 0.0.0.0:9000 --module app:app
