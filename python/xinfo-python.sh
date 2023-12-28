#!/bin/sh

if ! command -v python >/dev/null; then
    echo "ERROR: Python NOT FOUND." 2>&1
    exit 1
fi

PYTHON_VERSION=$(python -c 'import platform; print(platform.python_version())')
PYTHON_VERSION_MAJOR=$(python -c 'import sys; print(sys.version_info.major)')
PIP_VERSION=$(python -c 'import pip; print(pip.__version__)')

_version_check() {
    if [ -x "$XINFO_EXEC" ]; then
        $XINFO_EXEC version-compare "$1" "$2"
    else
        echo "ERROR: xinfo missing." 2>&1
        exit -1
    fi
}

# 系统默认Python版本相关信息
case "$1" in
    # 完整版本号
    --version|-v )
        echo $PYTHON_VERSION
        ;;
    # 主版本号
    --major|-m )
        echo $PYTHON_VERSION_MAJOR
        ;;
    --check|-c )
        _version_check "$PYTHON_VERSION" "$2"
        ;;
    # 比较主版本号
    --py2|-2 )
        [ "$PYTHON_VERSION_MAJOR" = "2" ]
        ;;
    --py3|-3 )
        [ "$PYTHON_VERSION_MAJOR" = "3" ]
        ;;
    # 较短的描述: py2|py3
    --short|-s )
        echo py${PYTHON_VERSION_MAJOR}
        ;;
    --pip-version )
        echo $PIP_VERSION
        ;;
    --pip-version-check )
        _version_check "$PIP_VERSION" "$2"
        ;;
    # ==
    --xinfo-help )
        echo "About Python"
        ;;
    # 默认输出 完整描述：python2|python3
    * )
        echo python${PYTHON_VERSION_MAJOR}
        ;;
esac
