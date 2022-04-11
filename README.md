Lua
===

Standalone lua installation engineered for a multi arch Lmod installation.

Features
--------

* Statically include
    * lfs
    * lpeg
    * luaposix

* build using alpine linux 
    * statically linked against musl (no dependency on any system libraries)

* Cross compiled
    * x86_64
    * ppc64le
    * riscv64
    * aarch64
