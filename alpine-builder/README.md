# alpine-builder

**已弃用，见alpine**

alpine Dockerfile生成工具

## 使用

docker run --rm -ti -v ALPINE_DOCKERFILE_PATH:/app/local jinnlynn/alpine-builder

## 可用变量

ALPINE_RELEASE 输出版本，默认: 3.6 3.7 edge

ALPINE_ARCH 输出平台, 默认: x86_64 armhf

ALPINE_LATEST 生成dockerfile的默认最新版本，默认: 3.7

ALPINE_MIRROR 软件库镜像，默认: https://mirrors.ustc.edu.cn/alpine/

ALPINE_OUTPUT 输出路径(docker镜像中的路径)，默认: /app/local

**注意：** alpine版本前面不要加v
