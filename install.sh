
base=$(pwd)/modules

mkdir -p $base/lua/bin

rm -rf build
meson subprojects download

meson setup -Dprefix=$base/lua     \
            -Dbindir='bin'         \
            -Dbuildtype=minsize    \
            -Db_staticpic=false    \
            -Db_ndebug=true        \
            -Db_lto=true           \
            build .       

meson compile -C build
meson install -C build
