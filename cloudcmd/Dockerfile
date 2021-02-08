FROM jinnlynn/node

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="15.6.0"

RUN set -ex && \
    npm install -g "cloudcmd${VERSION:+@==$VERSION}"

ENTRYPOINT ["cloudcmd"]

CMD ["--version"]
