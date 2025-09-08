FROM node:latest

RUN set -ex && \
    DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt install -y libnss3-dev libatk-bridge2.0-0 libcups2 libdrm2 \
        libxkbcommon-dev libxcomposite-dev libxdamage-dev libxrandr-dev libgbm-dev libasound-dev && \
    npm install --global fast-cli

ENTRYPOINT ["fast"]
