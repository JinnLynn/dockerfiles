FROM jinnlynn/nginx

LABEL maintainer="JinnLynn <eatfishlin@gmail.com>"

COPY theme/ /var/www/Nginx-Fancyindex-Theme/
COPY template/ /etc/nginx/template/

RUN set -ex && apk add --no-cache nginx-mod-http-fancyindex

# 配置
# 根目录
ENV FI_ROOT="/app/mnt"
# 主题
ENV FI_THEME="default"
# 默认排序 name | size | date | name_desc | size_desc | date_desc
ENV FI_DEFAULT_SORT="name"
# 文件夹优先 on | off
ENV FI_DIRECTORIES_FIRST="on"
# 外链样式表
ENV FI_CSS_HREF=""
# 精确显示文件大小 on | off
ENV FI_EXACT_SIZE="off"
# 文件名长度 50
ENV FI_NAME_LENGTH="255"
# 显示路径 on | off
ENV FI_SHOW_PATH="on"
# 显示.文件 on | off
ENV FI_SHOW_DOTFILES="off"
# 忽略文件 注: 值不能为空
ENV FI_IGNORE="/dev/null"
# 隐藏软链接 on | off
ENV FI_HIDE_SYMLINKS="off"
# 隐藏父目录 on | off
ENV FI_HIDE_PARENT_DIR="off"

# 显示本地时间 on | off
ENV FI_LOCALTIME="on"
# 时间格式
ENV FI_TIME_FORMAT="%Y-%m-%d %H:%M:%S"
