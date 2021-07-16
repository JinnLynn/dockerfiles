FROM jinnlynn/node

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="15.9.7"

RUN set -ex && \
    apk add --no-cache --virtual .build-deps python3 build-base autoconf automake && \
    npm install -g "cloudcmd${VERSION:+@==$VERSION}" && \
    apk del --no-cache .build-deps

ENTRYPOINT ["cloudcmd"]

CMD ["--version"]
