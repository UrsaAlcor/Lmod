arch_name = host_machine.cpu_family()
if arch_name=='ppc64' and host_machine.endian()=='little'
  arch_name += 'le'
endif
version_maj = meson.project_version().split('.')[0]
version_min = meson.project_version().split('.')[1]
binary_name = f'lua@version_maj@.@version_min@.@arch_name@'


executable(
    binary_name, [],
    dependencies: [
        subproject('lua')     .get_variable('lua_dep'),
        subproject('lfs')     .get_variable('lfs_dep'),
        subproject('lpeg')    .get_variable('lpeg_dep'),
        subproject('luaposix').get_variable('luaposix_dep'),
        subproject('lmod')    .get_variable('lmod_dep'),
    ],
    link_args: cc.get_supported_link_arguments([
        '-static-libgcc',
        '-static',
        '-Wl,-z,now',
        '-Wl,-z,relro',
        '-Wl,-z,combreloc',
        '-Wl,-z,noexecstack',
        '-Wl,-z,nocopyreloc',
        '-Wl,-z,text',
    ]),
    override_options: [
        'c_std=gnu99',
        'warning_level=3',
        'b_ndebug=true',
        'buildtype=minsize',
        'b_staticpic=false',
        'strip=true',
    ],
    install: true,
)
