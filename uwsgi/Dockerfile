ARG PYTHON_VERSION

FROM jinnlynn/python${PYTHON_VERSION:+":${PYTHON_VERSION}"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache --virtual .build build-base linux-headers && \
    pip install uwsgi && \
    apk del .build

COPY rootfs/ /

WORKDIR /app/opt

ENTRYPOINT ["uwsgi-init"]
