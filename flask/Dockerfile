FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="1.0.2"

RUN set -ex && \
    apk add --no-cache --virtual .build-deps build-base linux-headers python-dev && \
    pip install --no-cache-dir -U pip "flask${VERSION:+==}${VERSION}" uwsgi && \
    apk del --no-cache .build-deps

COPY app.py /app/opt/app.py

WORKDIR /app/opt

EXPOSE 8000

# 直接作为web服务器
# CMD ["uwsgi", "--http", ":8000", "--module", "app:app"]
# 作为不支持uwsgi仅支持http的反向代理服务器的上游服务器
# CMD ["uwsgi", "--http-socket", ":8000", "--module", "app:app"]
# 作为反向代理服务器(如：nginx)的上游服务器
CMD ["uwsgi", "--socket", ":8000", "--module", "app:app"]
