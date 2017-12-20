FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk update && \
    apk add --virtual .build-deps build-base linux-headers python-dev && \
    pip install --no-cache-dir flask uwsgi && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*

COPY app.py /app/opt/app.py

WORKDIR /app/opt

EXPOSE 8000 9000 9000/udp

CMD ["uwsgi", "--http", "0.0.0.0:8000", "--socket", "0.0.0.0:9000", "--module", "app:app"]
