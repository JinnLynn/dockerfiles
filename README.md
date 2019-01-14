# dockerfiles

个人使用的dockerfile合集。

### 多架构支持

在不同的架构下均可创建并均可正常使用。

已测试: x86_64 armhf

### Alpine基础镜像

所有的镜像均基于[Alpine](https://alpinelinux.org/), 但它**不会被自动创建**, 需手动创建: `./build.alpine`。

默认创建alpine edge版本，可同时创建多个版本，如创建版本3.7 3.8 edge，并指定镜像latest为3.8

```
ALPINE_VERSION="3.7 3.8 edge" ALPINE_LATEST="3.8" ./build.alpine
```

### 创建命令

除了Alpine基础镜像, 其它均可用`./build`创建。

```shell
USAGE: ./build [OPTIONS] [DOCKERFILE ...]

Options:
  -h, --help        帮助
  -u, --user USER   Docker hub用户名，可为空，不指定默认通过docker info获取
  -x, --proxy       代理，在docker build中添加代理相关参数
  --quiet           安静模式，在docker build中添加--quiet参数
  --build-arg       自定义创建参数，添加到docker build命令中
  -p, --push        构造镜像后推送至镜像库
  -f, --force       强制重建，不使用缓存
  -d, --dry-run     仅输出运行过程
  -v, --verbose     详细输出
```

命令举例:

```shell
# 创建所有
./build
# 只创建python, 将创建python、python:3两个镜像
./build python
# 指定Dockerfile, 见创建python:3镜像
./build python/3/Dockerfile
```

### 依赖及创建顺序

镜像之间有一定的依赖关系，如果要创建所有镜像，应按如下顺序进行

1. alpine
2. httpd python python3
3. flask
4. 其它镜像...

最优创建所有镜像命令:

```shell
# 创建基础镜像alpine
ALPINE_LATEST="3.8" ./build.alpine
# 顺序创建可能被其它镜像依赖的httpd python python3 flask
./build httpd python python3 flask
# 创建所有, 前面已创建的将会被忽略
./build
```
