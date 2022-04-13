Lmod
====

Standalone lua installation engineered for a multi arch Lmod installation.

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

.. code-block::

   # Fetch release
   version=v0.0.0
   wget https://github.com/UrsaAlcor/Lmod/releases/download/$version/lmod_x86_64 -O lmod_x86_64.zip

   # Install lmod to the desired location
   dest="/opt/modules"
   unzip lmod_x86_64

   ## Move modules to their final destination
   ./lmod_x86_64/modules/admin/relocate.sh $(pwd)/lmod_x86_64/modules $dest

   ## Patch shell profiles to automatically enable lmod
   $dest/modules/admin/patch.sh 

   ## Try that the installation was successful
   # Lua is not accesible by default
   which lua

   # Lua is now set
   module load lua/v5.4.3
   which lua
   /home/newton/work/Alcor/modules/lua/v5.4.3/x86_64/bin/lua


You can simply download our lmod release and unzip to the desired location.
You will need to update lmod to use the new location using 'move.sh'


.. code-block:: bash

   lmod/
   ├── 8.5.23/..
   ├── config
   └── modules
       ├── <package>/<version>/<arch>/
       └── lua/
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

   setup.sh
