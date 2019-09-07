FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR="https://registry.npm.taobao.org/"

RUN set -ex && \
    apk add --no-cache nodejs npm && \
    [ -n "${MIRROR}" ] && npm config set registry ${MIRROR} || true && \
    node --version

CMD ["node", "--version"]
