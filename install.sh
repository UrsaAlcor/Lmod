#!/bin/sh

origin=$(pwd)
base=$origin/modules

arch=${1:-x86_64}

rm -rf build
meson subprojects download

version=$(cd subprojects/lua && git describe --tags --abbrev=0)
loc=$base/lua/$version/$arch

mkdir -p $loc/bin

# Setup cross compilation
cd $origin/lua/buildroot/$arch
make -C $origin/subprojects/buildroot-2021.08 V=1 O=$(pwd)
export PATH="$(pwd)/host/bin:$PATH"

cd $origin

# Standard Meson build
meson setup -Dprefix=$loc       \
            -Dbindir='bin'      \
            -Dbuildtype=minsize \
            -Db_staticpic=false \
            -Db_ndebug=true     \
            -Db_lto=true        \
            build .       

meson compile -C build
meson install -C build
