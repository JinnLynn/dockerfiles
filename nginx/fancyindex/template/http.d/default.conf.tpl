server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/;
    index index.html;

    location /Nginx-Fancyindex-Theme {
        index index.html;
    }

    location / {
        include mime.types;
        default_type text/plain;

        root ${FI_ROOT};

        fancyindex                      on;
        fancyindex_default_sort         ${FI_DEFAULT_SORT};
        fancyindex_directories_first    ${FI_DIRECTORIES_FIRST};
        fancyindex_css_href             "${FI_CSS_HREF}";
        fancyindex_exact_size           ${FI_EXACT_SIZE};
        fancyindex_name_length          ${FI_NAME_LENGTH};
        fancyindex_header               "/Nginx-Fancyindex-Theme/${FI_THEME}/header.html";
        fancyindex_footer               "/Nginx-Fancyindex-Theme/${FI_THEME}/footer.html";
        fancyindex_show_path            "${FI_SHOW_PATH}";
        fancyindex_show_dotfiles        ${FI_SHOW_DOTFILES};
        fancyindex_ignore               "${FI_IGNORE}"; # 值不能为空
        fancyindex_hide_symlinks        ${FI_HIDE_SYMLINKS};
        fancyindex_hide_parent_dir      ${FI_HIDE_PARENT_DIR};
        fancyindex_localtime            ${FI_LOCALTIME};
        fancyindex_time_format          "${FI_TIME_FORMAT}";
    }
}
