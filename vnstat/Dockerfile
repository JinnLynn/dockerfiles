FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex \
    && apk --no-cache add vnstat \
    && sed -i '/UseLogging/s/2/0/' /etc/vnstat.conf \
    && sed -i '/RateUnit/s/1/0/' /etc/vnstat.conf

CMD ["vnstatd", "-n", "-t"]
