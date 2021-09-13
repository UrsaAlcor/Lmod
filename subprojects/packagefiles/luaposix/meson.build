project('luaposix', 'c',
    version:         '35.1',
    meson_version:   '>=0.58.1',
    license:         'MIT',
)

cc     = meson.get_compiler('c')
rt     = cc.find_library('rt',     required: false)
crypt  = cc.find_library('crypt',  required: false)
socket = cc.find_library('socket', required: false)
add_project_arguments(cc.get_supported_arguments([
    '-ffunction-sections',
    '-fdata-sections',
    '-Wno-pedantic',
    '-Wno-unused-variable',
    '-Wno-unused-function',
    '-Wno-address',
]), language: 'c')

package_name = meson.project_name()
package_verv = 'v'+meson.project_version()

lua_dep      = subproject('lua').get_variable('lua_dep')
lua_pack     = subproject('lua').get_variable('lua_pack_gen')
luaposix_inc = include_directories('ext/include')
luaposix_src = files('ext/posix/posix.c')
luaposix_cfg = {'package': package_name, 'version': package_verv}
luaposix_lua = {
    'posix':            files('lib/posix/init.lua'),
    'posix._base':      files('lib/posix/_base.lua'),
    'posix._bitwise':   files('lib/posix/_bitwise.lua'),
    'posix._strict':    files('lib/posix/_strict.lua'),
    'posix.compat':     files('lib/posix/compat.lua'),
    'posix.deprecated': files('lib/posix/deprecated.lua'),
    'posix.sys':        files('lib/posix/sys.lua'),
    'posix.util':       files('lib/posix/util.lua'),
    'posix.version':    configure_file(configuration: luaposix_cfg,
                                       input:  files('lib/posix/version.lua.in'),
                                       output: 'version.lua'),
}
foreach pack_name, pack_file: luaposix_lua
  luaposix_src += lua_pack.process(pack_file, extra_args: ['-p', pack_name])
endforeach
luaposix_c_args = [
    f'-DPACKAGE="@package_name@"',
    f'-DVERSION="@package_verv@"',
     '-D_POSIX_C_SOURCE=200809L',
     '-D_XOPEN_SOURCE=700',
]
luaposix_c_args += cc.has_function('posix_fadvise')              ? ['-DHAVE_POSIX_FADVISE']      : []
luaposix_c_args += cc.has_header  ('sched.h')                    ? ['-DHAVE_SCHED_H']            : []
luaposix_c_args += cc.has_function('sched_getscheduler')         ? ['-DHAVE_SCHED_GETSCHEDULER'] : []
luaposix_c_args += cc.has_function('sched_setscheduler')         ? ['-DHAVE_SCHED_SETSCHEDULER'] : []
luaposix_c_args += cc.has_header  ('sys/msg.h')                  ? ['-DHAVE_SYS_MSG_H']          : []
luaposix_c_args += cc.has_function('msgrcv')                     ? ['-DHAVE_MSGRCV']             : []
luaposix_c_args += cc.has_function('msgsnd')                     ? ['-DHAVE_MSGSND']             : []
have_sys_socket  = cc.has_header('sys/socket.h') and cc.has_function('socket', dependencies: socket)
luaposix_c_args += cc.has_header  ('net/if.h')          and have_sys_socket ? ['-DHAVE_NET_IF_H']          : []
luaposix_c_args += cc.has_header  ('linux/netlink.h')   and have_sys_socket ? ['-DHAVE_LINUX_NETLINK_H']   : []
luaposix_c_args += cc.has_header  ('linux/if_packet.h') and have_sys_socket ? ['-DHAVE_LINUX_IF_PACKET_H'] : []
luaposix_c_args += cc.has_function('statvfs')                    ? ['-DHAVE_STATVFS']            : []
have_crypt       = cc.has_function('crypt', dependencies: crypt)
luaposix_c_args += have_crypt                                    ? ['-DHAVE_CRYPT']              : []
luaposix_c_args += cc.has_header('crypt.h')                      ? ['-DHAVE_CRYPT_H']            : []
luaposix_c_args += cc.has_header_symbol('unistd.h', 'fdatasync') ? ['-DHAVE_DECL_FDATASYNC']     : []
luaposix_c_args += cc.has_function('fdatasync')                  ? ['-DHAVE_FDATASYNC']          : []
luaposix_c_args += cc.has_function('gethostid')                  ? ['-DHAVE_GETHOSTID']          : []
luaposix_sta = static_library(
    'luaposix',          luaposix_src,
    include_directories: luaposix_inc,
    c_args:              luaposix_c_args,
    dependencies:        lua_dep,
    name_prefix:         '',
    override_options: ['b_ndebug=true'],
)
luaposix_dep = declare_dependency(
    include_directories: luaposix_inc,
    link_with:           luaposix_sta,
    dependencies:        [lua_dep, rt, crypt, socket],
)
