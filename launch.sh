#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Downloading Julia 1.6.0 for Linux"
    curl -O https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.0-linux-x86_64.tar.gz
    tar -xvzf julia-1.6.0-linux-x86_64.tar.gz
    echo "Please wait, launching Julia 1.6.0..."
    ./julia-1.6.0/bin/julia --project app.jl 8081
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Downloading Julia 1.6.0 for MacOS"
    curl -O https://julialang-s3.julialang.org/bin/mac/x64/1.6/julia-1.6.0-mac64.dmg
    hdiutil attach julia-1.6.0-mac64.dmg
    echo "Launch julia from the terminal with\n$ julia --project app.jl 8081"
elif [[ "$OSTYPE" == "win32" ]]; then
    echo "Downloading Julia 1.6.0 for Windows"
    wget https://julialang-s3.julialang.org/bin/winnt/x64/1.6/julia-1.6.0-win64.exe
    echo "Launch julia from the command line with\n> julia --project app.jl 8081"
fi

