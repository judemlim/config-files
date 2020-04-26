#!/bin/bash

compile_cpp () {
    file_name=$1
    ext="${file_name##*.}"
    file_name="${file_name%.*}"
    if [ "${ext}" = "cpp" ]; then
        g++ -g $1  -Wall -Werror -std=c++17 -o ${file_name}
    else 
        echo "Not a cpp file"
    fi
}

function cd {
    builtin cd "$@" && ls -F
}
