help([[
Description
===========
Attempt to load a apt package as a module

This may or may not work! This entirely depends on the package
own setup which is beyond our control.
]])

local name = "${package}"
local version = "${version}"
local dist = os.getenv("ALCOR_DIST")

local path = pathJoin(dist, name, version)
local triplet = "x86_64-linux-gnu"

-- Binary folder
prepend_path("PATH", pathJoin(path, "usr", "bin"))

-- Static Library folders
prepend_path("LIBRARY_PATH", pathJoin(path, "usr", "lib"))
prepend_path("LIBRARY_PATH", pathJoin(path, "usr", "lib", triplet))

-- Dynamic Library folders
prepend_path("LD_LIBRARY_PATH", pathJoin(path, "usr", "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(path, "usr", "lib", triplet))

-- Man Pages
prepend_path("MANPATH", pathJoin(path, "usr", "share", "man"))

-- Includes for consistency
prepend_path("CPATH", pathJoin(path, "usr", "include"))
prepend_path("CPATH", pathJoin(path, "usr", "include", triplet))

-- Package configuration
prepend_path("PKG_CONFIG_PATH", pathJoin(path, "lib", "pkgconfig"))
