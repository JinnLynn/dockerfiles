FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache dnsmasq

EXPOSE 53 53/udp 67/udp

CMD ["dnsmasq", "-k", "--user=root", "--log-facility=-", "--conf-dir=/app/etc,*.conf"]
