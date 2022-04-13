help([[
Description
===========
Load lua to your path
]])


local name = "lua"
local version = "v5.4.3"
local arch = subprocess ("arch"):gsub("\n[^\n]*(\n?)$", "%1")
local modpath = os.getenv("MODULEPATH_ROOT")


local path = pathJoin(modpath, name, version, arch)

prepend_path("PATH", pathJoin(path, "bin"))

