#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

cd "$( cd "$(dirname "$0")"; pwd -P )"
DIR=$(pwd)

export CXX=clang++
export CC=clang

###########################################################

if [ ! -d llvm-openmp-tsan ]; then
	echo "Install OpenMP with TSan support"

	git clone -b release_60 https://github.com/llvm-mirror/openmp.git
	cd openmp
	mkdir build && cd $_
	cmake -DLIBOMP_TSAN_SUPPORT=ON \
		-DCMAKE_INSTALL_PREFIX=${DIR}/llvm-openmp-tsan ..
	make -j$(nproc) install
fi

###########################################################

echo "Create Project"
cd ${DIR}

mkdir -p custom

export LD_LIBRARY_PATH=${DIR}/llvm-openmp-tsan/lib

$CC -g -O0 -fno-omit-frame-pointer -fsanitize=thread -isystem ${DIR}/llvm-openmp-tsan/include -L ${DIR}/llvm-openmp-tsan/lib -fopenmp openmp_error.c    -o custom/openmp_error
$CC -g -O0 -fno-omit-frame-pointer -fsanitize=thread -isystem ${DIR}/llvm-openmp-tsan/include -L ${DIR}/llvm-openmp-tsan/lib -fopenmp openmp_no_error.c -o custom/openmp_no_error
$CC -g -O0 -fno-omit-frame-pointer -fsanitize=thread -isystem ${DIR}/llvm-openmp-tsan/include -L ${DIR}/llvm-openmp-tsan/lib -fopenmp pthread_error.c   -o custom/pthread_error

echo "Done. Make sure that following environment variable is set:"
echo ""
echo "    export LD_LIBRARY_PATH=${DIR}/llvm-openmp-tsan/lib"
echo ""

./custom/openmp_error
./custom/openmp_no_error
./custom/pthread_error
