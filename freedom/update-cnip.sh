#!/usr/bin/env sh
IPDATA_URI=${IPDATA_URI:-https://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest}

dfile=$(mktemp)

dst_file="cnip.txt"

curl -sSL "$IPDATA_URI" | awk -F\| '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' >$dfile && {
    echo "# $(date +%Y%m%d) $(wc -l $dfile | awk '{print $1}') routes" >$dst_file
    cat $dfile >>$dst_file
} || echo "Download ip data fail."
