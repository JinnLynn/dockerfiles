#!/bin/sh

# 系统默认Python版本相关信息
case "$1" in
    # 主版本号
    --major|-m )
        python -c 'import sys; print(sys.version_info.major)'
        ;;
    # 完整版本号
    --version|-v )
        python -c 'import platform; print(platform.python_version())'
        ;;
    # 比较主版本号
    --py2|-2 )
        [ "$($0 --major)" = "2" ]
        ;;
    --py3|-3 )
        [ "$($0 --major)" = "3" ]
        ;;
    # 较短的描述: py2|py3
    --short|-s )
        echo py$($0 --major)
        ;;
    # 默认输出 完整描述：python2|python3
    * )
        echo python$($0 --major)
        ;;
esac
