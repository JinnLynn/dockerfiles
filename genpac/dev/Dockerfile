FROM jinnlynn/python:2

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG PKG=https://github.com/JinnLynn/genpac/archive/dev.zip

RUN set -ex && \
    pip install --no-cache-dir --force-reinstall $PKG

ENTRYPOINT ["genpac"]

CMD ["-v"]
