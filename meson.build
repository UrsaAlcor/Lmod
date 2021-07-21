project('Alcor', 'c',
    version:          '5.4.4',
    meson_version:    '>=0.58.1',
    license:          'MIT',
    default_options:  [
        'c_std=gnu99',
        'warning_level=3',
    ],
)

cc = meson.get_compiler('c')
subdir('lmod/lua')
