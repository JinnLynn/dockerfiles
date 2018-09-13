FROM jinnlynn/ubuntu

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="2.6.0"

RUN set -ex && \
    ARCH=$(arch --386 i386 --amd64 x64 --arm armhf) && \
    DLINK="https://download-cdn.resilio.com/${VERSION}/linux-${ARCH}/resilio-sync_${ARCH}.tar.gz" && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qy && \
    apt-get install -qy wget && \
    wget -q -O- $DLINK | tar xz --exclude=LICENSE.TXT -C /app/bin && \
    apt-get purge -qy wget && \
    rm -rf /var/lib/apt

CMD ["rslsync", "--help"]
