#!/cvmfs/config.mila.quebec/lmod/lua/lua5.4
unistd = require 'posix.unistd'
lfs    = require 'lfs'
xarg           = {}
explicitrpaths = {}
rpaths         = {}
libpaths       = {}
libs           = {}
static         = {false}
output         = nil
soname         = nil
i              = 1


--[[
Skip injection logic.
--]]
LD_LUA_BACKEND = os.getenv('LD_LUA_BACKEND') or 'x86_64-linux-gnu-ld.orig'
LD_LUA_BYPASS  = os.getenv('LD_LUA_BYPASS')  or ''
LD_LUA_EXTRA   = os.getenv('LD_LUA_EXTRA')   or ''
LD_LUA_LOGNAME = os.getenv('LD_LUA_LOGNAME')
if LD_LUA_BYPASS ~= '' and LD_LUA_BYPASS ~= '0' then
  unistd.execp(LD_LUA_BACKEND, arg)
end


--[[
Search through arguments list and collect libraries and directories for which
rpath injection may be required.
--]]
while arg[i] do
  if     arg[i]          == '-L' then
    i=i+1
    if arg[i] then
      table.insert(libpaths, (arg[i]:gsub('/+','/')));
    end
  elseif arg[i]:sub(1,3) == '-L/' then
    table.insert(libpaths, (arg[i]:sub(3):gsub('/+','/')))
  elseif arg[i]          == '-l' then
    i=i+1
    if not static[1] and arg[i] then
      table.insert(libs, arg[i])
    end
  elseif arg[i]:sub(1,2) == '-l' then
    if not static[1] then
      table.insert(libs, arg[i]:sub(3))
    end
  elseif arg[i] == '-Bstatic' then
    static[1]=true
  elseif arg[i] == '-Bdynamic' then
    static[1]=false
  elseif arg[i] == '--push-state' then
    table.insert(static, 1, static[1])
  elseif arg[i] == '--pop-state' then
    table.remove(static, 1)
  elseif arg[i] == '-dynamic-linker' then
    i=i+1 -- Ignore the dynamic linker
  elseif arg[i] == '-rpath' then
    i=i+1 -- Explicit rpath, record for deduplication
    if arg[i] then
      local v = arg[i]
      v = v:gsub('/+','/')
      v = v:gsub('%f[\0/]/+$','')
      explicitrpaths[v] = true
    end
  elseif arg[i] == '-o' then
    i=i+1
    output = arg[i]
  elseif arg[i] == '--output' then
    i=i+1
    output = arg[i]
  elseif arg[i]:sub(1,9) == '--output=' then
    output = arg[i]:sub(10)
  elseif arg[i] == '-soname' then
    i=i+1
    soname = arg[i]
  elseif arg[i]:match('[^/]+%.so[^/]*$') then
    bn = arg[i]:match('[^/]+%.so[^/]*$')
    if arg[i] ~= bn then  -- Not just a raw library name
      table.insert(rpaths, arg[i]:sub(1, -1-#bn))
    end
  end
  i = i+1 -- Move to next argument
end


--[[
Now, trim the candidate paths to only those that are apparently useful:
That is, they exist and contain a library on the link line.
--]]
founddirs = {}
foundlist = {}
for k,v in pairs(rpaths) do
  if lfs.attributes(v, 'mode') == 'directory' then
    founddirs[v] = true
    table.insert(foundlist, v)
  end
end

foundlibs = {}
for k,v in pairs(libpaths) do
  if lfs.attributes(v, 'mode') == 'directory' then
    for q,name in pairs(libs) do
      if lfs.attributes(v..'/lib'..name..'.so', 'mode') == 'file' then
        foundlibs[name] = true
        if not founddirs[v] then
          founddirs[v] = true
          table.insert(foundlist, v)
        end
      end
    end
  end
end


--[[
Filter the list for whitelisted paths, create the additional -rpath flags
required, and exec the real linker.

There are a few blacklisted paths, mostly pointing to NVIDIA "stubs".
Obviously, these should *never* be used at runtime, so adding them as
-rpath is severely counter-productive.

We normalize paths and check against user-given explicit rpaths to avoid
pointless duplicates.
--]]
for k,v in pairs(foundlist) do
  v = v:gsub('/+','/')
  v = v:gsub('%f[\0/]/+$','')
  if not explicitrpaths[v] then
    if v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/lz4/') or
       v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/lzma/') or
       v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/zstd/') or
       v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/lmdb/') or
       v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/fftw/') or
       v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/cuda/') or
       v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/cudnn/') or
       v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/nccl/') or
       v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/magma/') or
       v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/oneapi/') or
       v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/openblas/') or
       LD_LUA_EXTRA:match('%f[^:\0]'..v) then
      if not v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/cuda/.+/stubs/*$') and
         not v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/tensorrt/.+/stubs/*$') then
        table.insert(xarg, '-rpath')
        table.insert(xarg, v)
        explicitrpaths[v] = true
      end
    end
  end
end
arg = table.move(xarg, 1, #xarg, #arg+1, arg)


--[[
Finishing hack: The libfftw3f?_*.so.* libraries (but not libfftw3f?.so.* itself)
bake into themselves an absolute path to their install location, to find
libfftw3.so.*. Punch out and replace such paths with $ORIGIN, making them
relocatable.
--]]
if soname and soname:match('^libfftw3f?_.+%.so%.%d+$') then
  i=1
  while arg[i] do
    if arg[i] == '-rpath' and
       arg[i+1]           and
       arg[i+1]:match('^/cvmfs/ai.mila.quebec/.+/fftw/+[^/]+/+lib') then
      arg[i+1] = '$ORIGIN'
      i = i+2
    else
      i = i+1
    end
  end
end


-- Execute linker.
if LD_LUA_LOGNAME then
  local s = LD_LUA_BACKEND..' '..table.concat(arg, ' ')..'\n'
  local f <close> = io.open(LD_LUA_LOGNAME, 'a+')
  f:write(s) -- In one atomic write, append.
  f:flush()
end
unistd.execp(LD_LUA_BACKEND, arg)
