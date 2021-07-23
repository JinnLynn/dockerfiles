FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

RUN set -ex && \
    apk add --no-cache iperf3

EXPOSE 5201/tcp 5201/udp

ENTRYPOINT ["iperf3"]

CMD ["-h"]
