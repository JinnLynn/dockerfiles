FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV DDNS_IP_SERVICE=http://ip.3322.net
ENV DDNS_TOKEN=

RUN set -ex && \
    apk add --no-cache bash libpsl curl jq && \
    curl -L# -o /app/etc/psl.dat https://github.com/publicsuffix/list/raw/master/public_suffix_list.dat

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["--help"]
