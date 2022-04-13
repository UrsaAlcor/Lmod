Lmod
====

Standalone lmod installation engineered for heterogeneous cluster 
(CPU/GPU & multi arch).

Features
--------

* Statically include
    * lfs
    * lpeg
    * luaposix

* Build using alpine linux 
    * statically linked against musl (no dependency on any system libraries)

* Cross compiled
    * x86_64
    * ppc64le
    * riscv64
    * aarch64


Module Installation
-------------------


You can use the install script in this repository.
For multi arch installation you can install multiple releases at the same location.

.. code-block::

   bash install.sh <version> <arch> <dest>


.. code-block:: bash

   lmod/
   ├── 8.5.23
   ├── lmod                            # Points to the current version of lmod
   ├── config                          # Default config of lmod
   └── modules
       ├── <package>/<version>/<arch>/
       └── lua/                        # lua used by lmod, also a valid module for testing
           ├── v5.4.3.lua
           └── v5.4.3
               ├── noarch/bin
               ├── aarch64/bin
               ├── ppc64le/bin
               ├── riscv64/bin
               └── x86_64/bin


Project Layout
---------------

.. code-block:: bash

   lmod/
   ├── build/
   ├── modules/lua/<version>/<arch>/bin/lua 
   ├── config               # Standard Lmod files
   ├── lua/                                     
   │   ├── buildroot        # Rules to compile lua on different arch
   |   |   ├── aarch64
   |   |   ├── ppc64le
   |   |   ├── riscv64
   |   |   └── x86_64
   │   └── meson.build      # Compiles the final lua executable
   ├── subprojects/         # Dependencies used to compile lua
   │   ├── buildroot        # Cross compilation tool chain
   |   ├── lfs              # Lua fs module
   |   ├── lmod             # Lmod
   |   ├── lpeg             # Lua parsing module
   |   ├── lua              # Compiles lua as a static library
   │   └── luaposix         # Lua posix modulee
   └── meson.build


Compilation Steps
-----------------

#. Compile subprojects

   #. lfs
   #. lpeg
   #. lua

      * A single static library with both lua & luac mains
      * Dynamic module loading is patched to expect statically linked modules
      * No more reliance on DSO (dynamic shared object)

   #. luaposix

#. Link Lua

   * Lua is linked into an executable with all LMod required modules
     linked statically

#. Lua is moved to its final module location
#. Lmod is configured
#. ``modules/`` is packaged and released


Installation from source
------------------------

.. code-block::

   bash setup.sh <arch> <intall_path>
