FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV REDIR_PORT 9528
ENV REDIR_SERVER=
ENV IPSET_GFWLIST GFWLIST

COPY entrypoint.sh /app/bin/entrypoint

RUN set -ex && \
    apk add --no-cache iptables ipset curl && \
    entrypoint cnip-download

ENTRYPOINT ["entrypoint"]

CMD ["help"]
