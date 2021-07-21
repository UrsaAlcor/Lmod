project('Lmod', 'c',
    version:         '8.5.9',
    meson_version:   '>=0.58.1',
    license:         'MIT',
)

lua_dep  = subproject('lua').get_variable('lua_dep')
lua_pack = subproject('lua').get_variable('lua_pack_gen')
lmod_src = files('pkgs/term/core.c')
lmod_lua = {
    'term.colors': files('pkgs/term/term/colors.lua'),
    'term.cursor': files('pkgs/term/term/cursor.lua'),
    'term':        files('pkgs/term/term/init.lua'),
}
foreach pack_name, pack_file: lmod_lua
  lmod_src += lua_pack.process(pack_file, extra_args: ['-p', pack_name])
endforeach
lmod_sta = static_library(
    'lmod', lmod_src,
    dependencies: lua_dep,
    name_prefix:  '',
)
lmod_dep = declare_dependency(
    link_with:           lmod_sta,
    dependencies:        lua_dep,
)
