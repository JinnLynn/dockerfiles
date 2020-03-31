#!/bin/sh

# Python版本相关信息
case "$1" in
    --major|-m )
        python -c 'import sys; print(sys.version_info.major)'
        ;;
    --version|-v )
        python -c 'import platform; print(platform.python_version())'
        ;;
    --py2|-2 )
        [ "$($0 --major)" = "2" ]
        ;;
    --py3|-3 )
        [ "$($0 --major)" = "3" ]
        ;;
    * )
        echo python$($0 --major)
        ;;
esac
