project('lpeg', 'c',
    version:         '1.0.2',
    meson_version:   '>=0.58.1',
    license:         'MIT',
)

cc = meson.get_compiler('c')
lua_dep  = subproject('lua').get_variable('lua_dep')
lua_pack = subproject('lua').get_variable('lua_pack_gen')
lpeg_inc = include_directories('.')
lpeg_src = files('lpcap.c', 'lpcode.c', 'lpprint.c', 'lptree.c', 'lpvm.c')
lpeg_lua = {
    're': files('re.lua'),
}
foreach pack_name, pack_file: lpeg_lua
  lpeg_src += lua_pack.process(pack_file, extra_args: ['-p', pack_name])
endforeach
lpeg_sta = static_library(
    'lpeg', lpeg_src,
    c_args: cc.get_supported_arguments(['-Wno-implicit-fallthrough']),
    dependencies: lua_dep,
    name_prefix: '',
)
lpeg_dep = declare_dependency(
    include_directories: lpeg_inc,
    link_with:           lpeg_sta,
    dependencies:        lua_dep,
)
