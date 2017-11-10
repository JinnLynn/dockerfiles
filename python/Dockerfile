FROM jinnlynn/alpine

MAINTAINER JinnLynn <eatfishlin@gmail.com>

RUN set -ex && \
    apk add --no-cache python py2-pip

COPY pip.conf /root/.pip/pip.conf

CMD python --version

