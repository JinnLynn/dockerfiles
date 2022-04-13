FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="3.0.0-rc48"

RUN set -ex && \
    wget -O- https://github.com/google/mtail/releases/download/v${VERSION}/mtail_${VERSION}_Linux_$(xinfo --amd64 x86_64).tar.gz | \
        tar xz -C /app/bin --exclude LICENSE --exclude README.md

ENTRYPOINT [ "mtail" ]

CMD [ "--help" ]
