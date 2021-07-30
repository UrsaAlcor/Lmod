#!/cvmfs/config.mila.quebec/lmod/lua/lua5.4
unistd   = require 'posix.unistd'
lfs      = require 'lfs'
xarg     = {}
rpaths   = {}
libpaths = {}
libs     = {}
static   = false
i        = 1


--[[
Skip injection logic.
--]]
LD_LUA_BACKEND = os.getenv('LD_LUA_BACKEND') or 'x86_64-linux-gnu-ld.orig'
LD_LUA_BYPASS  = os.getenv('LD_LUA_BYPASS')  or ''
LD_LUA_EXTRA   = os.getenv('LD_LUA_EXTRA')   or ''
if LD_LUA_BYPASS ~= '' and LD_LUA_BYPASS ~= '0' then
  unistd.execp(LD_LUA_BACKEND, arg)
end


--[[
Search through arguments list and collect libraries and directories for which
rpath injection may be required.
--]]
while arg[i] do
  if     arg[i]          == '-L' then
    table.insert(libpaths, (arg[i+1]:gsub('/+','/')));
    i=i+1
  elseif arg[i]:sub(1,3) == '-L/' then
    table.insert(libpaths, (arg[i]:sub(3):gsub('/+','/')))
  elseif arg[i]          == '-l' then
    if not static then
      table.insert(libs, arg[i+1])
    end
    i=i+1
  elseif arg[i]:sub(1,2) == '-l' then
    if not static then
      table.insert(libs, arg[i]:sub(3))
    end
  elseif arg[i] == '-Bstatic' then
    static=true
  elseif arg[i] == '-Bdynamic' then
    static=false
  elseif arg[i] == '-dynamic-linker' then
    i=i+1 -- Ignore the dynamic linker
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
--]]
for k,v in pairs(foundlist) do
  if v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/lz4/') or
     v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/lzma/') or
     v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/zstd/') or
     v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/lmdb/') or
     v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/cuda/') or
     v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/cudnn/') or
     v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/oneAPI/') or
     v:match('^/cvmfs/ai.mila.quebec/apps/x86_64/common/OpenBLAS/') or
     LD_LUA_EXTRA:match('%f[^:\0]'..v) then
    table.insert(xarg, '-rpath')
    table.insert(xarg, v)
  end
end
arg = table.move(xarg, 1, #xarg, #arg+1, arg)
unistd.execp(LD_LUA_BACKEND, arg)
