FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache uwsgi-python3

COPY app.py /app/opt/app.py
COPY entrypoint.sh /app/bin/entrypoint

WORKDIR /app/opt

EXPOSE 8000

ENTRYPOINT ["entrypoint"]
