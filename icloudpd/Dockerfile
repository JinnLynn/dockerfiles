FROM jinnlynn/python:3.13

ARG VERSION

RUN set -ex && \
    pip install icloudpd==${VERSION}

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT [ "entrypoint" ]
