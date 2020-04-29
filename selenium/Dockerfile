ARG PY_VERSION
FROM jinnlynn/python${PY_VERSION:+":$PY_VERSION"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache chromium chromium-chromedriver && \
    pip install --no-cache-dir -U pip selenium

COPY demo.py /app/opt/

CMD ["python", "/app/opt/demo.py"]
