# dockerfiles

个人使用的dockerfile合集。

## 多架构支持

在不同的架构下均可构建并均可正常使用。

已测试: x86_64 armhf

## alpine基础镜像

所有的镜像均基于alpine，但它不会被自动构建

构建命令: ./build.alpine

默认构建edge版本

构建多个版本:

ALPINE_VERSION="3.7 3.8 edge" ALPINE_LATEST="3.8" ./build.alpine

即构建了alpine 3.7 3.8 edge，并指定镜像latest为3.8

## 依赖

1. alpine
2. httpd python python3
3. flask
4. ...
