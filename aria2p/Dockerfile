FROM jinnlynn/python

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="0.10.4"

RUN set -ex && \
    apk add --no-cache --virtual .build-deps \
        build-base \
        python3-dev \
        freetype-dev \
        fribidi-dev \
        harfbuzz-dev \
        jpeg-dev \
        lcms2-dev \
        openjpeg-dev \
        tcl-dev \
        tiff-dev \
        tk-dev \
        zlib-dev && \
    pip install --no-cache-dir "aria2p[tui]${VERSION:+==$VERSION}" && \
    apk del .build-deps

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["top"]
