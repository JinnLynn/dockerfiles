FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV GITWEB_CONFIG=/app/etc/gitweb.conf

RUN set -ex && \
    apk add git-gitweb lighttpd highlight perl-cgi gettext && \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    wget -O- https://github.com/kogakure/gitweb-theme/archive/master.tar.gz | tar xz -C /usr/share/gitweb/static --strip-components 1 --exclude */.gitignore --exclude */README.* --exclude */setup && \
    apk del gettext

COPY entrypoint.sh /app/bin/entrypoint
COPY gitweb.conf.tpl /app/etc/
COPY lighttpd.conf /etc/lighttpd/

EXPOSE 80

ENTRYPOINT [ "entrypoint" ]

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
