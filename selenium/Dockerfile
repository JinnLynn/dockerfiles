# Alpine ARMHF 没有 chromium
FROM jinnlynn/ubuntu

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y python-selenium && \
    cleanup

COPY demo.py /app/opt/

CMD ["python", "/app/opt/demo.py"]
