FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="1.7.1"

RUN set -ex && \
    DLINK=http://gosspublic.alicdn.com/ossutil/${VERSION}/ossutil$(arch --amd64 64 --arm arm32) && \
    wget -O /app/bin/ossutil $DLINK && \
    chmod 755 /app/bin/ossutil

ENTRYPOINT ["ossutil"]

CMD ["help"]
