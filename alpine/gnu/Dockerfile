FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

# some useful packages
# acl: getfacl setfacl chacl
# bind-tools: dig nslookup
# net-tools: ifconfig arp route hostname
ARG MORE_PKGS="acl bind-tools net-tools lsof curl"

RUN set -ex && \
    GNU_PKGS="bash coreutils findutils gawk procps grep sed" && \
    apk add --no-cache ${GNU_PKGS} ${MORE_PKGS}

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["/bin/bash"]
