# alpine

alpine 基础镜像

## 使用

不会自动构建，使用命令../build.alpine

ALPINE_VERSION="3.6 3.7 edge" ALPINE_LATEST="3.7" ../build.alpine

## 目录结构

本基础镜像会在根目录下创建app目录，一般建议将程序安装其中。

其下各目录作用分别是：

* /app
    * bin   可执行文件
    * etc   配置文件
    * local 程序运行中生成的需要保存的数据，一般需挂载到宿主机
    * log   日志
    * mnt   挂载宿主机文件夹
    * opt   可选应用软件包
    * tmp   临时目录
    * var   程序运行中其内容不断变化的文件，不需要保存到宿主机
