FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache chromium chromium-chromedriver && \
    pip install -U --no-cache-dir pip selenium

COPY demo.py /app/opt/

CMD ["python", "/app/opt/demo.py"]
