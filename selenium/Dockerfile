ARG PY_VERSION
FROM jinnlynn/python${PY_VERSION:+":${PY_VERSION}"}


LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="3.141.0"

RUN set -ex && \
    apk add --no-cache chromium chromium-chromedriver && \
    pip install --no-cache-dir "selenium${VERSION:+==$VERSION}"

COPY demo.py /app/opt/

CMD ["python", "/app/opt/demo.py"]
