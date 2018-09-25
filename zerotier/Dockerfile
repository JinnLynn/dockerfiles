FROM jinnlynn/ubuntu

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update -yq && \
    apt-get install -yq wget gnupg && \
    wget -O- https://install.zerotier.com/ | bash && \
    rm -rf /var/lib/zerotier-one/*

CMD ["zerotier-one"]
