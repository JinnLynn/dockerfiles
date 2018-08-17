FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR

# REF: https://pip.pypa.io/en/stable/user_guide/#environment-variables
ENV PIP_INDEX_URL="${MIRROR:-https://mirrors.ustc.edu.cn/pypi/web/simple}"

RUN set -ex && \
    apk add --no-cache python && \
    wget -O- https://bootstrap.pypa.io/get-pip.py | python

CMD ["python", "--version"]
