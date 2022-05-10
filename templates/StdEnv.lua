help([[
Description
===========
Setup your environment for module loading
]])

local arch = os.subprocess("arch")
local dist = pathJoin("${ALCOR_DIST}", arch)

setenv("ALCOR_DIST", dist)
