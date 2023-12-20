ARG ALPINE_VERSION
FROM jinnlynn/alpine${ALPINE_VERSION:+":${ALPINE_VERSION}"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR

# REF: https://pip.pypa.io/en/stable/topics/configuration/#environment-variables
ENV PIP_INDEX_URL="${MIRROR:-https://pypi.doubanio.com/simple/}"
# REF: https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPYCACHEPREFIX
ENV PYTHONPYCACHEPREFIX="/app/tmp/pycache"
# REF: https://veronneau.org/python-311-pip-and-breaking-system-packages.html
# 使用ensurepip安装pip时不支持
ENV PIP_BREAK_SYSTEM_PACKAGES=1

COPY py-release.sh /app/bin/py-release

RUN set -ex && \
    apk add --no-cache python3 && \
    ln -sf python3 /usr/bin/python && \
    ln -sf pydoc3 /usr/bin/pydoc && \
    wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python /tmp/get-pip.py && \
    rm -rf /tmp/get-pip.py

ONBUILD RUN apk upgrade --no-cache python3 && \
    pip install --no-cache-dir -U pip

CMD ["python"]
