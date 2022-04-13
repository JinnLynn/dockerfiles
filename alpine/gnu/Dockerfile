FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

# util-linux-misc => util-linux
ARG PKGS="bash coreutils findutils procps util-linux-misc grep sed acl bind-tools net-tools lsof"
ARG EXTRA_PKGS="curl wget tar"

RUN set -ex && \
    apk add --no-cache ${PKGS} ${EXTRA_PKGS}

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["/bin/bash"]
