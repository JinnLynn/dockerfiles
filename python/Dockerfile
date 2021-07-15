FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR

# REF: https://pip.pypa.io/en/stable/user_guide/#environment-variables
ENV PIP_INDEX_URL="${MIRROR:-https://pypi.doubanio.com/simple/}"
# REF: https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPYCACHEPREFIX
ENV PYTHONPYCACHEPREFIX="/app/tmp/pycache"

COPY py-release.sh /app/bin/py-release

RUN set -ex && \
    apk add --no-cache python3 py3-pip && \
    ln -sf python3 /usr/bin/python && \
    ln -sf pydoc3 /usr/bin/pydoc && \
    pip install --no-cache-dir -U pip

ONBUILD RUN pip install --no-cache-dir -U pip

CMD ["python"]
