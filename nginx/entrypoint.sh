#!/usr/bin/env sh
. /entrypoint.common

exec_entrypoint_dir() {
    local entrypoint_dir="$1"

    [ ! -d "$entrypoint_dir" ] && return 0

    if /usr/bin/find "${entrypoint_dir}" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
        echo_msg "${entrypoint_dir} is not empty, will attempt to perform configuration"

        echo_msg "Looking for shell scripts in ${entrypoint_dir}"
        find "${entrypoint_dir}" -follow -type f -print | sort -V | while read -r f; do
            case "$f" in
                *.sh)
                    if [ -x "$f" ]; then
                        echo_msg "Launching $f";
                        "$f"
                    else
                        # warn on shell scripts without exec bit
                        echo_msg "Ignoring $f, not executable";
                    fi
                    ;;
                *) echo_msg "Ignoring $f";;
            esac
        done
    else
        echo_msg "No files found in ${entrypoint_dir}, skipping configuration"
    fi
}

if [ "$1" = "nginx" -o "$1" = "nginx-debug" ]; then
    exec_entrypoint_dir /etc/nginx/entrypoint.d
    exec_entrypoint_dir /app/etc/entrypoint.d
    echo_msg "Configuration complete; ready for start up"
fi

exec "$@"
