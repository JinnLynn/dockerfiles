FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ARG VERSION="5.0.4"

# REF: https://github.com/docker-library/redis/tree/master/5.0/alpine
RUN set -ex && \
    DLINK=http://download.redis.io/releases/redis-${VERSION}.tar.gz && \
    addgroup -S redis && adduser -S -G redis redis && \
    cd /tmp && \
    apk add --no-cache 'su-exec>=0.2' tzdata && \
	apk add --no-cache --virtual .build-deps \
		    coreutils \
		    gcc \
		    linux-headers \
		    make \
		    musl-dev && \
    mkdir redis && \
    cd redis && \
    wget -O- $DLINK | tar xz --strip 1 && \
    ls -alh && \
	grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 1$' src/server.h && \
	sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' src/server.h && \
	grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 0$' src/server.h && \
	make -j "$(nproc)" && \
	make install && \
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" && \
	apk add --virtual .redis-rundeps $runDeps && \
	apk del .build-deps && \
	cd /tmp && \
    rm -rf * && \
	redis-server --version && \
    chown redis:redis /app/local

VOLUME /app/local
WORKDIR /app/local

COPY entrypoint.sh /app/bin/entrypoint
ENTRYPOINT ["entrypoint"]

EXPOSE 6379
CMD ["redis-server"]
