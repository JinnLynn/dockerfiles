FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR
ARG VERSION=3

# REF: https://pip.pypa.io/en/stable/user_guide/#environment-variables
ENV PIP_INDEX_URL="${MIRROR:-https://pypi.doubanio.com/simple/}"

COPY py-release.sh /app/bin/py-release

RUN set -ex && \
    apk add --no-cache python${VERSION:-3} && \
    ln -sf python${VERSION:-3} /usr/bin/python && \
    wget -O- https://bootstrap.pypa.io/get-pip.py | python

CMD ["python"]
