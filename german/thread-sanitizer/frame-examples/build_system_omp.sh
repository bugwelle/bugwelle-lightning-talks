#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

cd "$( cd "$(dirname "$0")"; pwd -P )"
DIR=$(pwd)

export CXX=clang++
export CC=clang

###########################################################

echo "Create Project"
cd ${DIR}

export LD_LIBRARY_PATH=${DIR}/llvm-openmp-tsan/lib

mkdir -p system
$CC -g -O2 -fno-omit-frame-pointer -fsanitize=thread -fopenmp openmp_error.c    -o system/openmp_error
$CC -g -O2 -fno-omit-frame-pointer -fsanitize=thread -fopenmp openmp_no_error.c -o system/openmp_no_error
$CC -g -O2 -fno-omit-frame-pointer -fsanitize=thread -fopenmp pthread_error.c   -o system/pthread_error

echo "Done"
