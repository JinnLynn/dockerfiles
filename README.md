# dockerfiles

个人使用的dockerfile合集。

* 全部或指定构建
* 多标签支持
* 多架构平台支持: x86_64 armhf
* push manifest支持


### 构建命令

```shell
USAGE: ./build [OPTIONS] [DIR|DOCKERFILE ...]

Options:
    -h, --help            帮助
    -u, --user USER       用户名，用于生成镜像名，当值为『-』时则意味着用户名将被置空
    -p, --push            构造镜像后推送至镜像库
    -m, --manifest        使用manifest-tool构建支持多平台架构的镜像
    -f, --force           忽略.buildignore
    -d, --dry-run         仅输出运行过程
    -v, --verbose         详细输出

以build开始的参数都作用于docker build命令:

    --build-arg ARG       自定义构建参数，即docker build --build-arg ARG
    --build-proxy PROXY   构建代理，等价于
                            --build-arg http_proxy=PROXY
                            --build-arg https_proxy=PROXY
    --build-opt OPT       docker build参数，已有默认: $DEFAULT_BUILD_OPTS
    --build-quiet         安静模式，相当于:
                            --build-opt "--quite"
    --build-force         强制重建，不使用缓存，相当于:
                            --build-opt "--no-cache"
```

### 命令举例

```shell
# 构建所有
# 注意: 镜像之间有一定的依赖关系
#      当构建所有时，以下镜像将按顺序优先构建
#      alpine ubuntu httpd python flask php node
./build
# 构建youtube-dl、youtube-dl:edge
./build youtube-dl
# 指定目录或Dockerfile, 将构建youtube-dl:edge
./build youtube-dl/edge
./build youtube-dl/edge/Dockerfile

# 构建并推送到镜像库
./build -p youtube-dl
# 构建推送到镜像库并使用manifest-tool构建支持多平台架构的镜像
./build -m youtube-dl

# 忽略设置
# .buildignore可配置忽略build或push的镜像
# 当其中有『B,polipo』时，下面的构建命令将被忽略
./build polipo
# 强制构建，polipo将能成功构建
./build -f polipo
```

### 构建配置相关

#### 用户名

Docker Hub用户名用于生成镜像仓库名，通过参数`-u|--user`指定。

该无该参数时，通过以下顺序获取:

1. 环境变量DOCKER_USER
1. docker info命令中的Username值，注意: 需执行docker login登录后才有，但**Docker for Mac即使登录了也不会有该值**。

#### 镜像多标签的实现

##### 1. 使用文件目录结构

通过构建目录上下文环境目录区分不同TAG，根目录的生成标签为latest，子目录的目录名为各自Context的标签。

如: [youtube-dl](https://github.com/JinnLynn/dockerfiles/tree/master/youtube-dl)，构建后将会有youtube-dl:latest、youtube-dl:dev两个仓库镜像。

##### 2. 使用options配置文件

通过options开头的文件生成不同TAG。

如: [alpine](https://github.com/JinnLynn/dockerfiles/tree/master/alpine)，构建后将会有多个通过各个options文件中`OPT_BUILD_TAGS`的值为TAG的仓库镜像。

[options文件示例](https://github.com/JinnLynn/dockerfiles/blob/master/alpine/options)

#### 多平台架构的实现

一般情况下多平台架构使用相同的Dockerfile文件，也可以通过后缀区分，如Dockerfile.amd64
