#!/bin/sh

if ! command -v node >/dev/null; then
    echo "ERROR: NodeJS NOT FOUND." 2>&1
    exit 1
fi

NODE_VERSION=$(node --version)
NODE_VERSION=${NODE_VERSION/v/}

_version_check() {
    if [ -x "$XINFO_EXEC" ]; then
        $XINFO_EXEC version-compare "$1" "$2"
    else
        echo "ERROR: xinfo missing." 2>&1
        exit -1
    fi
}

case "$1" in
    # 完整版本号
    --version|-v )
        echo $NODE_VERSION
        ;;
    # 主版本号
    --major|-m )
        echo $(echo $NODE_VERSION | awk -F. '{print $1}')
        ;;
    --check|-c )
        _version_check "$NODE_VERSION" "$2"
        ;;
    --npm-version )
        npm --version
        ;;
    --npm-version-check )
        _version_check "$(npm --version)" "$2"
        ;;
    # ===
    --xinfo-help )
        echo "About Node"
        ;;
    * )
        echo "node$($0 -m)"
        ;;
esac
