FROM jinnlynn/alpine

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

ENV REDIR_PORT 9528
ENV REDIR_SERVER=
ENV IPSET_GFWLIST GFWLIST

ENV IPDATA_URI=https://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest
ENV CNIP_FILE=/app/opt/cnip.txt

RUN set -ex && \
    apk add --no-cache iptables ipset curl && \
    DFILE=$(mktemp) && \
    curl -sSL "$IPDATA_URI" | awk -F\| '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > ${DFILE} && \
    echo "# $(date +%Y%m%d) $(wc -l ${DFILE} | awk '{print $1}') routes" >${CNIP_FILE} && \
    cat ${DFILE} >>${CNIP_FILE} && \
    rm -rf ${DFILE}

COPY entrypoint.sh /app/bin/entrypoint

ENTRYPOINT ["entrypoint"]
