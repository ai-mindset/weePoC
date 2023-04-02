#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    FILE="julia-1.9.0-linux-x86_64.tar.gz"
    UNCOMPRESSED="./julia-1.9.0"
    [[ -f ${FILE} && -d ${UNCOMPRESSED} ]] || [[ $(echo "Downloading Julia 1.9.0 for Linux" && curl -O https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.9.0-linux-x86_64.tar.gz && tar -xvzf julia-1.9.0-linux-x86_64.tar.gz) ]]
    echo "Please wait, launching Julia 1.9.0..."
    $UNCOMPRESSED/bin/julia --project src/app.jl 8001
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Downloading Julia 1.9.0 for MacOS"
    curl -O https://julialang-s3.julialang.org/bin/mac/x64/1.6/julia-1.9.0-mac64.dmg
    hdiutil attach julia-1.9.0-mac64.dmg
    echo "Launch julia from the terminal with\n$ julia --project src/app.jl 8001"
elif cat /proc/version | grep Microsoft; then
    FILE="julia-1.9.0-linux-x86_64.tar.gz"
    UNCOMPRESSED="./julia-1.9.0"
    [[ -f ${FILE} && -d ${UNCOMPRESSED} ]] || [[ $(echo "Downloading Julia 1.9.0 for WSL" && curl -O https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.9.0-linux-x86_64.tar.gz && tar -xvzf julia-1.9.0-linux-x86_64.tar.gz) ]]
    echo "Please wait, launching Julia 1.9.0..."
    $UNCOMPRESSED/bin/julia --project src/app.jl 8001
fi

