# 使用方法:
# docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock jinnlynn/ctop
FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="0.7.6"

# x86_64下需要libc6-compat
RUN set -ex && \
    wget -O /app/bin/ctop "https://github.com/bcicen/ctop/releases/download/${VERSION}/ctop-${VERSION}-linux-$(xinfo arch)" && \
    chmod +x /app/bin/ctop

CMD ["ctop"]
