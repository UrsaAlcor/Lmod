#!/bin/bash

package=${1}

arch=$(arch)
dest=${2}/dist/$arch/$package
module=${2}/modules/$arch/$package

apt download $package
dpkg-deb -xv $package $dest

# things gets installed inside a usr/ folder
# Generate a module file for it 

# libsdl2-dev
