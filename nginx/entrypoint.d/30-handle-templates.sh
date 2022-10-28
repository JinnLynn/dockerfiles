#!/usr/bin/env bash
. /entrypoint.common

: ${NGINX_ENVSUBST_OUTPUT_DIR:="/etc/nginx"}
: ${NGINX_ENVSUBST_TEMPLATE_DIR:="/etc/nginx/template"}
: ${NGINX_ENVSUBST_TEMPLATE_SUFFIX:=".tpl"}
: ${NGINX_ENVSUBST_AUTOCOPY_SUFFIX:=".conf"}
: ${NGINX_ENVSUBST_ENV_PREFIX:=}

auto_envsubst() {
    local template_dir="${NGINX_ENVSUBST_TEMPLATE_DIR}"
    local suffix="${NGINX_ENVSUBST_TEMPLATE_SUFFIX}"
    local output_dir="$NGINX_ENVSUBST_OUTPUT_DIR"

    local env_prefix=$(join "$NGINX_ENVSUBST_ENV_PREFIX" "|")

    local template defined_envs relative_path output_path subdir
    defined_envs=$(printf '${%s} ' $(env | grep -E "${env_prefix:+^($env_prefix)}" | cut -d= -f1))

    echo_msg "envsubst: $defined_envs"

    find "$template_dir" -mindepth 1 -maxdepth 1 -type d -print  | while read -r template; do
        subdir=$(basename $template)
        echo_msg "Pre-Clean: $output_dir/$subdir"
        rm -rf $output_dir/$subdir/*
    done

    find "$template_dir" -follow -type f -print | while read -r template; do
        relative_path="${template#$template_dir/}"
        subdir=$(dirname "$relative_path")

        mkdir -p "$output_dir/$subdir"

        case "$template" in
            *$suffix)
                output_path="$output_dir/${relative_path%$suffix}"
                echo_msg "Running envsubst on $template to $output_path"
                envsubst "$defined_envs" < "$template" > "$output_path"
                ;;
            *$NGINX_ENVSUBST_AUTOCOPY_SUFFIX)
                output_path="$output_dir/${relative_path}"
                echo_msg "Copy $template to $output_path"
                cp "$template" "$output_path"
                ;;
            *)
                echo_msg "Ignore $template"
                ;;
        esac
    done
}

if [ ! -d "$NGINX_ENVSUBST_TEMPLATE_DIR" ]; then
    echo_msg "ERROR: $NGINX_ENVSUBST_TEMPLATE_DIR is nonexistent."
    exit 0
fi

if [ ! -w "$NGINX_ENVSUBST_OUTPUT_DIR" ]; then
    echo_msg "ERROR: $NGINX_ENVSUBST_TEMPLATE_DIR exists, but $NGINX_ENVSUBST_OUTPUT_DIR is not writable"
    exit 0
fi

auto_envsubst
exit 0
