FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR="https://mirrors.ustc.edu.cn/pypi/web/simple"

RUN set -ex && \
    apk add --no-cache python py2-pip && \
    mkdir -p /root/.pip && \
    echo -e "[global]\nindex-url = $MIRROR" >/root/.pip/pip.conf

CMD python --version

