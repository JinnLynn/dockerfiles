FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG PKG=https://github.com/JinnLynn/genpac/archive/master.zip

RUN set -ex && \
    cd /tmp && \
    pip install --no-cache-dir $PKG && \
    rm -rf /tmp/*

ENTRYPOINT ["genpac"]

CMD ["-h"]
