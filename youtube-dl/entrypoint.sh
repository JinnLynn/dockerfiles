#!/usr/bin/env sh

# 直接指定参数 调用外部下载工具多线程下载
# if [ "${1:0:1}" == '-' ]; then
#     set -- youtube-dl \
#             --external-downloader aria2c \
#             --external-downloader-args --file-allocation=none \
#             --external-downloader-args --summary-interval=60 \
#             --external-downloader-args --max-connection-per-server=16 \
#             $@
# fi

exec $@
