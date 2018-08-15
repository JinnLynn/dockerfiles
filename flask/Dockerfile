FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk update && \
    apk add --virtual .build-deps build-base linux-headers python-dev && \
    pip install --no-cache-dir -U pip flask uwsgi && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*

COPY app.py /app/opt/app.py

WORKDIR /app/opt

EXPOSE 8000
# 直接作为web服务器
# CMD ["uwsgi", "--http", ":8000", "--module", "app:app"]
# 作为不支持uwsgi仅支持http的反向代理服务器的上游服务器
# CMD ["uwsgi", "--http-socket", ":8000", "--module", "app:app"]
# 作为反向代理服务器(如：nginx)的上游服务器
CMD ["uwsgi", "--socket", ":8000", "--module", "app:app"]
