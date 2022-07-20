FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN apk add --no-cache --update openvpn iptables bash easy-rsa && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/bin/

COPY bin/entrypoint /bin/ovpn /app/bin/
COPY opt/ /app/opt/

ENV OPENVPN="/app/local"

ENTRYPOINT ["entrypoint"]
