project('lfs', 'c',
    version:         '1.8.0',
    meson_version:   '>=0.58.1',
    license:         'MIT',
)

lua_dep = subproject('lua').get_variable('lua_dep')
lfs_inc = include_directories('src')
lfs_src = files('src/lfs.c')
lfs_sta = static_library(
    'lfs', lfs_src,
    include_directories: lfs_inc,
    dependencies:        lua_dep,
    name_prefix:         '',
)
lfs_dep = declare_dependency(
    include_directories: lfs_inc,
    link_with:           lfs_sta,
    dependencies:        lua_dep,
)
