# python2
# alpine 3.15后没有python2 但3.10后很多包没有预编译
FROM jinnlynn/alpine:3.10

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR

# REF: https://pip.pypa.io/en/stable/user_guide/#environment-variables
ENV PIP_INDEX_URL="${MIRROR:-https://pypi.doubanio.com/simple/}"

COPY py-release.sh /app/bin/py-release

RUN set -ex && \
    apk add --no-cache python2 py2-pip && \
    pip install --no-cache-dir -U pip

ONBUILD RUN pip install --no-cache-dir -U pip

CMD ["python"]
