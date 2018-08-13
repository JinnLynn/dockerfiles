# dockerfiles

## 更新 alpine Dockerfile

1. 创建alpine-builder镜像 或忽略此命令直接使用docker hub上的镜像

./build alpine-builder

2. 执行生成

docker run --rm -ti -v $(pwd)/alpine:/app/local jinnlynn/alpine-builder


## 依赖

1. alpine
2. httpd python python3
3. flask
4. ...
