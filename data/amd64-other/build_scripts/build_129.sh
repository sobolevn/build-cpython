#!/bin/bash
set -x
set -e
# print OS version
cat /etc/os-release
# print current env
env
rm /usr/bin/ld
ln -s /usr/bin/ld.lld /usr/bin/ld
export CC=clang
export CXX=clang++
export CFLAGS="-g -fsanitize=address"
export CCFLAGS="-g -fsanitize=address"
export CXXFLAGS="-g -fsanitize=address"
export CPPFLAGS="-g -fsanitize=address"
export LDFLAGS="-fsanitize=address"
export ASAN_OPTIONS="detect_leaks=0:allocator_may_return_null=1:handle_segv=0"
export LD_PRELOAD="/usr/lib/llvm-18/lib/clang/18/lib/linux/libclang_rt.asan-x86_64.so"
cd /src/Python-3.12.4
set +e
if ! ./configure --with-assertions --with-pydebug; then
    cat config.log
    exit 1
else
    make
    ./python -m test -uall
fi
