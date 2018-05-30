# 使用方法:
# docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock jinnlynn/ctop
FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG CTOP_VER="0.7"
ARG CTOP_URL="https://github.com/bcicen/ctop/releases/download/v$CTOP_VER/ctop-$CTOP_VER-linux-amd64"

# x86_64下需要libc6-compat
RUN set -ex && \
    apk add --no-cache curl libc6-compat && \
    curl -SL -o /app/bin/ctop $CTOP_URL && \
    chmod +x /app/bin/ctop && \
    apk del --no-cache curl

CMD ["ctop"]
