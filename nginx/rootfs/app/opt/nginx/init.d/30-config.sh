#!/usr/bin/env bash
. /nginx.rc

# set -x

: ${NGINX_CONFIG_SOURCE_DIR:="/app/etc/nginx"}
: ${NGINX_CONFIG_ENVSUBST_SUFFIX:=".conf"}
: ${NGINX_CONFIG_ENVSUBST_ENV_PREFIX:=}
: ${NGINX_CONFIG_COPY_DIRS:="init.d"}

NGINX_DEST_DIR="/etc/nginx"


# 处理过程
# 1. 清理/etc/nginx中与NGINX_CONFIG_SOURCE_DIR相同的文件夹
# 2. 直接拷贝 NGINX_CONFIG_COPY_DIRS 的文件夹到 NGINX_DEST_DIR
# 3. 拷贝其它文件 保持目录结构
#   3.1 后缀是 NGINX_CONFIG_ENVSUBST_SUFFIX 执行变量替换envsubst
#   3.2 其它 直接拷贝

auto_envsubst() {
    local source_dir="$NGINX_CONFIG_SOURCE_DIR"
    local dest_dir="$NGINX_DEST_DIR"
    local suffix=$(join "$NGINX_CONFIG_ENVSUBST_SUFFIX" "|")
    local env_prefix=$(join "$NGINX_CONFIG_ENVSUBST_ENV_PREFIX" "|")
    local copy_dirs=$(join "$NGINX_CONFIG_COPY_DIRS" "|")

    echo_msg "suffix=${suffix} copy_dirs=${copy_dirs}"

    local source defined_envs relative_path dest_path subdir
    defined_envs=$(printf '${%s} ' $(env | grep -E "${env_prefix:+^($env_prefix)}" | cut -d= -f1))

    echo_msg "envsubst: $defined_envs"

    find "$source_dir" -mindepth 1 -maxdepth 1 -type d -print  | while read -r source; do
        subdir=$(basename $source)
        echo_msg "Pre-Clean: $dest_dir/$subdir"
        rm -rf $dest_dir/$subdir
        if [ -n "$copy_dirs" ]; then
            if echo "$subdir" | grep -Eq "${copy_dirs:+^($copy_dirs)$}"; then
                echo_msg "Copy Dir: $source to $dest_dir/"
                cp -r $source $dest_dir/
            fi
        fi
    done

    find "$source_dir" -follow -type f -print | while read -r source; do
        # echo_msg "DEBUG $source"
        relative_path="${source#$source_dir/}"
        subdir=$(dirname "$relative_path")

        mkdir -p "$dest_dir/$subdir"
        dest_path="$dest_dir/${relative_path}"

        # echo_msg "subdir: $subdir $relative_path"

        if echo "$subdir" | grep -Eq "${copy_dirs:+^($copy_dirs)$}"; then
            continue
        fi

        if echo "$source" | grep -Eq "${suffix:+($suffix)$}"; then
            # echo_msg "$relative_path"
            echo_msg "Running envsubst on $source to $dest_path"
            envsubst "$defined_envs" < "$source" > "$dest_path"
        else
            echo_msg "Copy $source to $dest_path"
            cp "$source" "$dest_path"
        fi

        # case "$template" in
        #     $suffix)
        #         output_path="$output_dir/${relative_path}"
        #         # echo_msg "$relative_path"
        #         echo_msg "Running envsubst on $template to $output_path"
        #         envsubst "$defined_envs" < "$template" > "$output_path"
        #         ;;
        #     *)
        #         output_path="$output_dir/${relative_path}"
        #         echo_msg "Copy $template to $output_path"
        #         cp "$template" "$output_path"
        #         ;;
        #     # *)
        #     #     echo_msg "Ignore $template"
        #     #     ;;
        # esac
    done
}

# : ${NGINX_ENVSUBST_OUTPUT_DIR:="/etc/nginx"}
# : ${NGINX_ENVSUBST_TEMPLATE_DIR:="/etc/nginx/template"}
# : ${NGINX_ENVSUBST_TEMPLATE_SUFFIX:=".tpl"}
# : ${NGINX_ENVSUBST_AUTOCOPY_SUFFIX:=".conf"}
# : ${NGINX_ENVSUBST_ENV_PREFIX:=}

# auto_envsubst() {
#     local template_dir="${NGINX_ENVSUBST_TEMPLATE_DIR}"
#     local suffix="${NGINX_ENVSUBST_TEMPLATE_SUFFIX}"
#     local output_dir="$NGINX_ENVSUBST_OUTPUT_DIR"

#     local env_prefix=$(join "$NGINX_ENVSUBST_ENV_PREFIX" "|")

#     local template defined_envs relative_path output_path subdir
#     defined_envs=$(printf '${%s} ' $(env | grep -E "${env_prefix:+^($env_prefix)}" | cut -d= -f1))

#     echo_msg "envsubst: $defined_envs"

#     find "$template_dir" -mindepth 1 -maxdepth 1 -type d -print  | while read -r template; do
#         subdir=$(basename $template)
#         echo_msg "Pre-Clean: $output_dir/$subdir"
#         rm -rf $output_dir/$subdir/*
#     done

#     find "$template_dir" -follow -type f -print | while read -r template; do
#         relative_path="${template#$template_dir/}"
#         subdir=$(dirname "$relative_path")

#         mkdir -p "$output_dir/$subdir"

#         case "$template" in
#             *$suffix)
#                 output_path="$output_dir/${relative_path%$suffix}"
#                 echo_msg "Running envsubst on $template to $output_path"
#                 envsubst "$defined_envs" < "$template" > "$output_path"
#                 ;;
#             *$NGINX_ENVSUBST_AUTOCOPY_SUFFIX)
#                 output_path="$output_dir/${relative_path}"
#                 echo_msg "Copy $template to $output_path"
#                 cp "$template" "$output_path"
#                 ;;
#             *)
#                 echo_msg "Ignore $template"
#                 ;;
#         esac
#     done
# }

if [ ! -d "$NGINX_CONFIG_SOURCE_DIR" ]; then
    echo_msg "ERROR: $NGINX_CONFIG_SOURCE_DIR is nonexistent."
    exit 0
fi

if [ ! -w "$NGINX_DEST_DIR" ]; then
    echo_msg "ERROR: $NGINX_DEST_DIR exists, but $NGINX_DEST_DIR is not writable"
    exit 0
fi

auto_envsubst
exit 0
