Lmod
====

Standalone lmod installation engineered for heterogeneous cluster 
(CPU/GPU & multi arch).

Features
--------

* Statically linked against (i.e squashed dependencies)
    * lfs
    * lpeg
    * luaposix

* Built using alpine linux 
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
   ├── modules
   |   ├── <arch>/<package>/<version>/
   |   ├── aarch64/lua/v5.4.3.lua
   |   ├── ppc64le/lua/v5.4.3.lua
   |   ├── riscv64/lua/v5.4.3.lua
   |   └── x86_64/lua/v5.4.3.lua
   └── dist/<arch>/<package>/<version>
       ├── aarch64/lua/bin/lua
       ├── ppc64le/lua/bin/lua
       ├── riscv64/lua/bin/lua
       └── x86_64/lua/bin/lua


* Arch is the first folder because

  * Not all modules will support all archs;
    Having each arch with their own modulefiles
    means that only supported modules will showup 

  * Some packages will have different dependencies 
    depending on the arch, so they will require a different module files.

  * Not all versions will work for a given arch

* The dist folder can be relocated

Setup
~~~~~

For a personnal setup you can simply activate the system system by sourcing the 
appropriate files like what ``activate.sh`` does.

In a cluster you will want users to get access to the modules when login-in;
you can add files from ``templates/config``.


Project Layout
---------------

.. code-block:: bash

   lmod/
   ├── build/
   ├── modules/<arch>/lua/<version>/bin/lua 
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


Creating modules
----------------


.. code-block::

   $ apt download nginx
   $ ar x <file>
   $ ls
   control.tar.zst
   data.tar.zst
   debian-binary

   $ dpkg-deb -xv <file>