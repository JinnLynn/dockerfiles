FROM jinnlynn/python:3

# 总是最新版本
RUN set -ex && \
    wget -O /app/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp && \
    chmod +x /app/bin/yt-dlp && \
    apk add --no-cache ffmpeg && \
    mkdir /.cache && chmod 777 /.cache

ENTRYPOINT ["yt-dlp"]

CMD ["--version"]
