help([[
Description
===========
Load lua to your path
]])

local name = "lua"
local version = "${LUA_VERSION}"
local dist = os.getenv("ALCOR_DIST")

local path = pathJoin(dist, name, version)

prepend_path("PATH", pathJoin(path, "bin"))

