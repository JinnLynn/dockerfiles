FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="1.1.2"

RUN set -ex && \
    apk add --no-cache uwsgi-python3 && \
    pip install --no-cache-dir "flask${VERSION:+==$VERSION}"

COPY app.py /app/opt/app.py
COPY entrypoint.sh /app/bin/entrypoint

WORKDIR /app/opt

EXPOSE 8000

ENTRYPOINT ["entrypoint"]
