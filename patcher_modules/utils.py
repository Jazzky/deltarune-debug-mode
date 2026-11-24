from .setup import Context

import os
import sys

def perror(msg):
    print(msg, file=sys.stderr)

def set_double_quote(gml_code):
    return gml_code.replace('"', '""')

def get_file_pos(filename):
    return os.path.join(Context.CWD, filename)

def update_cwd(new_dir):
    if new_dir == Context.OWD:
        Context.CWD = '.'
    else:
        Context.CWD = os.path.normpath(os.path.join(Context.CWD, new_dir))
    os.chdir(new_dir)
