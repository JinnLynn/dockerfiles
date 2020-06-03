FROM jinnlynn/git

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV GITWEB_CONFIG=/app/etc/gitweb.conf  \
    GIT_USER=git GIT_USER_ID=1000       \
    GIT_GROUP=git GIT_GROUP_ID=1000

RUN set -ex && \
    apk add git-gitweb lighttpd lighttpd-mod_auth highlight perl-cgi apache2-utils && \
    wget -O- https://github.com/kogakure/gitweb-theme/archive/master.tar.gz | tar xz \
        -C /usr/share/gitweb/static --strip-components 1                             \
        --exclude */.gitignore --exclude */README.* --exclude */setup && \
    echo 'include "/app/etc/lighttpd.conf"' >>/etc/lighttpd/lighttpd.conf

COPY entrypoint.sh /app/bin/entrypoint
COPY gitweb.conf /etc/
COPY lighttpd.conf /app/etc/

EXPOSE 80

ENTRYPOINT [ "entrypoint" ]

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
