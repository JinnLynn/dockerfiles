FROM jinnlynn/node

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="14.5.1"

RUN set -ex && \
    npm install -g "cloudcmd${VERSION:+@==$VERSION}"

ENTRYPOINT ["cloudcmd"]

CMD ["--version"]
