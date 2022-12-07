#!/usr/bin/env bash

export SETUP_BASE_DIR=$(dirname $(realpath $0))
source $SETUP_BASE_DIR/_common.sh

find "$SETUP_BASE_DIR/setup.d" -mindepth 1 -maxdepth 1 -follow -type f -print | sort -V | while read -r f; do
    case "$f" in
        *.sh)
            if [ -x "$f" ]; then
                log "Launching $f";
                "$f"
            else
                # warn on shell scripts without exec bit
                log "Ignoring $f, not executable";
            fi
            ;;
        *)
            log "Ignoring $f"
            ;;
    esac
done
