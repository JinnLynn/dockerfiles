ARG ALPINE_VERSION
ARG VERSION

FROM jinnlynn/alpine${ALPINE_VERSION:+":${ALPINE_VERSION}"} AS alpine

FROM python:${VERSION}-alpine${ALPINE_VERSION}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MIRROR

COPY --from=alpine /etc/apk/repositories /etc/apk/
COPY --from=alpine /etc/localtime /etc/
COPY --from=alpine /app/ /app/

COPY xinfo-python.sh /app/bin/

# REF: https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPYCACHEPREFIX
#      https://pip.pypa.io/en/stable/topics/configuration/#environment-variables
ENV PATH=/app/bin:$PATH                                                        \
    PYTHONPYCACHEPREFIX="/app/tmp/pycache"                                     \
    PIP_INDEX_URL="${MIRROR:-https://pypi.tuna.tsinghua.edu.cn/simple}"        \
    PIP_ROOT_USER_ACTION=ignore                                                \
    PIP_DISABLE_PIP_VERSION_CHECK=1

ONBUILD RUN pip install --no-cache-dir -U pip

CMD ["python"]
