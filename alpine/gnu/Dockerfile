ARG VERSION
FROM jinnlynn/alpine${VERSION:+":${VERSION}"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG MORE_PKGS=

RUN set -ex && \
    apk add --no-cache bash coreutils util-linux-misc findutils gawk procps grep sed \
                        acl bind-tools net-tools lsof curl ${MORE_PKGS}

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["/bin/bash"]
