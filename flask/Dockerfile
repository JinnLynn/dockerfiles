ARG PY_VERSION
FROM jinnlynn/python${PY_VERSION:+":${PY_VERSION}"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="2.0.1"

RUN set -ex && \
    apk add --no-cache uwsgi-python$(py-release -3 && echo 3) && \
    pip install --no-cache-dir "flask${VERSION:+==$VERSION}"

COPY app.py /app/opt/app.py
COPY entrypoint.sh /app/bin/entrypoint

WORKDIR /app/opt

EXPOSE 8000

ENTRYPOINT ["entrypoint"]
