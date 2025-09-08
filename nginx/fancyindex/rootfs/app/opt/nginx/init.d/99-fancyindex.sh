#!/usr/bin/env sh

# REF: https://github.com/aperezdc/ngx-fancyindex



# 根目录
: ${FI_ROOT:="/app/mnt"}

# 主题根目录
: ${FI_THEME_ROOT:="/app/opt/nginx/Nginx-Fancyindex-Theme"}

# 主题
: ${FI_THEME:=default}
# 默认排序 name | size | date | name_desc | size_desc | date_desc
: ${FI_DEFAULT_SORT:=name}
# 文件夹优先 on | off
: ${FI_DIRECTORIES_FIRST:=on}
# 外链样式表
: ${FI_CSS_HREF:=""}
# 精确显示文件大小 on | off
: ${FI_EXACT_SIZE:=off}
# 文件名长度 50
: ${FI_NAME_LENGTH:=255}
# 页头 页尾
: ${FI_HEADER:="/Nginx-Fancyindex-Theme/${FI_THEME}/header.html"}
: ${FI_FOOTER:="/Nginx-Fancyindex-Theme/${FI_THEME}/footer.html"}
# 显示路径 on | off
: ${FI_SHOW_PATH:=on}
# 显示.文件 on | off
: ${FI_SHOW_DOTFILES:=off}
# 忽略文件 注: 值不能为空
: ${FI_IGNORE:="$(cat /proc/sys/kernel/random/uuid)"}
# 隐藏软链接 on | off
: ${FI_HIDE_SYMLINKS:=off}
# 隐藏父目录 on | off
: ${FI_HIDE_PARENT_DIR:=off}

# 显示本地时间 on | off
: ${FI_LOCALTIME:=on}
# 时间格式
: ${FI_TIME_FORMAT:="%Y-%m-%d %H:%M:%S"}


cat <<EOF >/etc/nginx/fancyindex_params
fancyindex                      on;
fancyindex_default_sort         ${FI_DEFAULT_SORT};
fancyindex_directories_first    ${FI_DIRECTORIES_FIRST};
fancyindex_css_href             "${FI_CSS_HREF}";
fancyindex_exact_size           ${FI_EXACT_SIZE};
fancyindex_name_length          ${FI_NAME_LENGTH};
fancyindex_header               "${FI_HEADER}";
fancyindex_footer               "${FI_FOOTER}";
fancyindex_show_path            "${FI_SHOW_PATH}";
fancyindex_show_dotfiles        ${FI_SHOW_DOTFILES};
fancyindex_ignore               "${FI_IGNORE}"; # 值不能为空
fancyindex_hide_symlinks        ${FI_HIDE_SYMLINKS};
fancyindex_hide_parent_dir      ${FI_HIDE_PARENT_DIR};
fancyindex_localtime            ${FI_LOCALTIME};
fancyindex_time_format          "${FI_TIME_FORMAT}";
EOF

cat << EOF >/etc/nginx/fancyindex_server
location /Nginx-Fancyindex-Theme {
    alias ${FI_THEME_ROOT};
}

location / {
    root ${FI_ROOT};

    include mime.types;
    default_type text/plain;

    include fancyindex_params;
}
EOF
