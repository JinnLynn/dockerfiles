#!/usr/bin/env sh

# REF: https://github.com/aperezdc/ngx-fancyindex

# 根目录
export FI_ROOT=${FI_ROOT:-"/app/mnt"}

# 主题
export FI_THEME=${FI_THEME:-light}
# 默认排序 name | size | date | name_desc | size_desc | date_desc
export FI_DEFAULT_SORT=${FI_DEFAULT_SORT:-name}
# 文件夹优先 on | off
export FI_DIRECTORIES_FIRST=${FI_DIRECTORIES_FIRST:-on}
# 外链样式表
export FI_CSS_HREF=${FI_DIRECTORIES_FIRST:-""}
# 精确显示文件大小 on | off
export FI_EXACT_SIZE=${FI_EXACT_SIZE:-off}
# 文件名长度 50
export FI_NAME_LENGTH=${FI_NAME_LENGTH:-255}
# 页头 页尾
export FI_FOOTER=${FI_FOOTER:-"/Nginx-Fancyindex-Theme/${FI_THEME}/footer.html"}
export FI_HEADER=${FI_HEADER:-"/Nginx-Fancyindex-Theme/${FI_THEME}/header.html"}
# 显示路径 on | off
export FI_SHOW_PATH=${FI_SHOW_PATH:-on}
# 显示.文件 on | off
export FI_SHOW_DOTFILES=${FI_SHOW_DOTFILES:-off}
# 忽略文件 注: 值不能为空
export FI_IGNORE=${FI_IGNORE:-"$(cat /proc/sys/kernel/random/uuid)"}
# 隐藏软链接 on | off
export FI_HIDE_SYMLINKS=${FI_HIDE_SYMLINKS:-off}
# 隐藏父目录 on | off
export FI_HIDE_PARENT_DIR=${FI_HIDE_PARENT_DIR:-off}

# 显示本地时间 on | off
export FI_LOCALTIME=${FI_LOCALTIME:-on}
# 时间格式
export FI_TIME_FORMAT=${FI_TIME_FORMAT:-"%Y-%m-%d %H:%M:%S"}

envsubst "$(printf '${%s} ' $(env | cut -d= -f1 | grep -e ^FI_))" </app/etc/fancyindex-tpl.conf >/etc/nginx/http.d/fancyindex.conf

if [ -z "$@" ]; then
    exec nginx -g "daemon off;"
fi

exec $@
