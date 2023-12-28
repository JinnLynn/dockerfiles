ARG ALPINE_VERSION
ARG NODEJS_VERSION

FROM jinnlynn/alpine${ALPINE_VERSION:+":${ALPINE_VERSION}"} AS alpine

FROM node:${NODEJS_VERSION}-alpine${ALPINE_VERSION}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR="https://registry.npmmirror.com"

COPY --from=alpine /etc/apk/repositories /etc/apk/
COPY --from=alpine /etc/localtime /etc/
COPY --from=alpine /app/ /app/

ENV PATH=/app/bin:$PATH

COPY xinfo-node.sh /app/bin/

RUN set -ex && \
    [ -n "${MIRROR}" ] && npm config set registry ${MIRROR} || true

ENTRYPOINT []

CMD [ "node" ]
