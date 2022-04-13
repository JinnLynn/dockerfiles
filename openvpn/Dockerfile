FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG COMMIT_ID="1228577d4598762285958ad98724ab37e7b11354"

# Testing: pamtester
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --no-cache --update openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester libqrencode && \
    ln -s /usr/share/easy-rsa/easyrsa /app/bin/ && \
    wget -O- "https://github.com/kylemanna/docker-openvpn/archive/${COMMIT_ID}.tar.gz" | tar xz -C /tmp --strip-components 1 && \
    cp /tmp/bin/* /app/bin/ && \
    cp /tmp/otp/openvpn /etc/pam.d/ && \
    chmod a+x /app/bin/*

# Needed by scripts
ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_PKI=$OPENVPN/pki

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]
