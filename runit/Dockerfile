ARG BASE_IMAGE
FROM ${BASE_IMAGE:-jinnlynn/alpine}

COPY rootfs /

RUN set -ex && ln -sf ../opt/runit/bin/runit-init /app/bin/

ENV SVDIR=/app/opt/service.d

ENTRYPOINT [ "runit-init" ]
