ARG PYTHON_VERSION

FROM jinnlynn/python${PYTHON_VERSION:+":${PYTHON_VERSION}"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache --virtual .build build-base linux-headers && \
    pip install uwsgi && \
    apk del .build

COPY app.py /app/opt/app.py
COPY uwsgi-init.sh /app/bin/uwsgi-init

WORKDIR /app/opt

EXPOSE 8000

ENTRYPOINT ["uwsgi-init"]
