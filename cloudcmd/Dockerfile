FROM jinnlynn/node

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="14.4.0"

RUN set -ex && \
    npm install -g "cloudcmd@==${VERSION}"

ENTRYPOINT ["cloudcmd"]

CMD ["--version"]
