ARG ALPINE_VERSION
FROM jinnlynn/alpine${ALPINE_VERSION:+":${ALPINE_VERSION}"}

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN apk add --no-cache --update openvpn iptables bash easy-rsa && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/bin/

COPY app /app/

ENV OPENVPN="/app/local"

ENTRYPOINT ["entrypoint"]
