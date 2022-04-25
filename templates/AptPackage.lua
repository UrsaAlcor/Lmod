help([[
Description
===========
Attempt to load a apt package as a module
]])

local name = "${package}"
local version = "${version}"
local dist = os.getenv("ALCOR_DIST")

local path = pathJoin(dist, name, version)
local triplet = "x86_64-linux-gnu"

-- Binary folder
prepend_path("PATH", pathJoin(path, "usr", "bin"))

-- Library folders
prepend_path("LIBRARY_PATH", pathJoin(path, "usr", "lib"))
prepend_path("LIBRARY_PATH", pathJoin(path, "usr", "lib", triplet))

-- Man Pages
prepend_path("MANPATH", pathJoin(path, "usr", "share", "man", "man1"))

-- Includes for consistency
prepend_path("INCLUDE_PATH", pathJoin(path, "usr", "include"))
prepend_path("INCLUDE_PATH", pathJoin(path, "usr", "include", triplet))

