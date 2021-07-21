project('Lua', 'c',
    version:         '5.4.4',
    meson_version:   '>=0.58.1',
    license:         'MIT',
)

python = import('python').find_installation()
cc     = meson.get_compiler('c')
libm   = cc.find_library('m', required: false)

add_project_arguments(cc.get_supported_arguments([
    '-ffunction-sections',
    '-fdata-sections',
    '-Wno-pedantic',
]), language: 'c')


lua_inc = include_directories('.')
core_files = files(
    'lapi.c',    'lcode.c',
    'lctype.c',  'ldebug.c',
    'ldo.c',     'ldump.c',
    'lfunc.c',   'lgc.c',
    'llex.c',    'lmem.c',
    'lobject.c', 'lopcodes.c',
    'lparser.c', 'lstate.c',
    'lstring.c', 'ltable.c',
    'ltm.c',     'lundump.c',
    'lvm.c',     'lzio.c',
)
aux_files = files('lauxlib.c')
lib_files = files(
   'lbaselib.c', 'lcorolib.c',
   'ldblib.c',   'liolib.c',
   'lmathlib.c', #'loadlib.c', # This file is patched!
   'loslib.c',   'lstrlib.c',
   'ltablib.c',  'lutf8lib.c',
   'linit.c',
)
lua_files  = files('lua.c')
luac_files = files('luac.c')
main_files = files('main.c')
load_files = [custom_target(
    'loadlib',
    command: [files('apply-patch.sh'), files('001-loadlib.patch'), files('loadlib.c'), '@OUTDIR@'],
    output:  ['loadlib.c'],
)]
lua_src = core_files+aux_files+lib_files+lua_files+luac_files+main_files+load_files
lua_c_args = [
    '-DLUA_USE_POSIX',
    '-ULUA_COMPAT_5_3',
]
lua_sta = static_library(
    'lua', lua_src,
    name_prefix: '',
    c_args: lua_c_args + [
        '-Dmain_lua=main_lua',
        '-Dmain_luac=main_luac',
        '-DLUA_PATH_DEFAULT="./?.lua;./?/init.lua"',
        '-DLUA_CPATH_DEFAULT="./?.so"',
    ],
)
lua_dep = declare_dependency(
    include_directories: lua_inc,
    compile_args:        lua_c_args,
    link_with:           lua_sta,
    dependencies:        libm,
)
lua_pack_py  = files('lua-pack.py')
lua_pack_gen = generator(python,
    arguments: [meson.current_source_dir()/'lua-pack.py',
                '@EXTRA_ARGS@', '-o', '@OUTPUT@', '-i', '@INPUT@'],
    output:    '@BASENAME@.S',
)
