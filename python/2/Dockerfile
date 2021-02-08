# alpine 3.10后 python2不再被支持 很多包没有预编译
FROM jinnlynn/alpine:3.10

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR

# REF: https://pip.pypa.io/en/stable/user_guide/#environment-variables
ENV PIP_INDEX_URL="${MIRROR:-https://pypi.doubanio.com/simple/}"

COPY py-release.sh /app/bin/py-release

RUN set -ex && \
    apk add --no-cache python2 && \
    wget -O- https://bootstrap.pypa.io/2.7/get-pip.py | python

ONBUILD RUN pip install --no-cache-dir -U pip

CMD ["python"]
