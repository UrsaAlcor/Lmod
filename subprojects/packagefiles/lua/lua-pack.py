#usr/bin/env python
import argparse, os, sys


if __name__ == "__main__":
    argp = argparse.ArgumentParser()
    argp.add_argument('-o', '--output',       default=None, type=str)
    argp.add_argument('-p', '--package-name', default='',   type=str)
    argp.add_argument('-i', '--package-file', default='',   type=str)
    argp.add_argument('--no-nullpad', action='store_false', dest='nullpad')
    argp.add_argument('--nullpad',    action='store_true')
    argp.add_argument('--section',    default=None)
    args = argp.parse_args(sys.argv[1:])
    args.section = args.section or '.rodata'
    symb_prefix  = '_binary_'
    
    
    if args.output in {None, '', '-'}:
        out_dir  = '.'
        out_file = sys.stdout
    else:
        out_path = args.output or 'out.S'
        out_dir  = os.path.dirname(out_path) or '.'
        os.makedirs(out_dir, exist_ok=True)
        out_file = open(out_path, 'w')
    
    
    with out_file as f:
        path_size = os.stat(args.package_file).st_size
        path_rel  = os.path.relpath(args.package_file, out_dir)
        symb_name = args.package_name.replace('.', '_')
        
        f.write(f'.section {args.section}\n')
        f.write(f'.globl {symb_prefix}{symb_name}_start\n')
        f.write(f'.globl {symb_prefix}{symb_name}_end\n')
        f.write(f'{symb_prefix}{symb_name}_start:\n')
        f.write(f'    .incbin "{path_rel}", 0, {path_size}\n')
        f.write(f'    . = {symb_prefix}{symb_name}_start+{path_size}\n')
        f.write(f'{symb_prefix}{symb_name}_end:\n')
        f.write(f'    .byte 0\n' if args.nullpad else '')
        f.write(f'\n')
