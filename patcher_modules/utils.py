from .setup import Context, ALL_CHAPTERS

import os

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

def parse_chapter_config(chap_list):
    chap_list = list(set(chap_list))
    if min(chap_list) < 0:
        if max(chap_list) >= 0:
            print(f"Warning: invalid chapter values. Skipping.")
            print("Rules: only positive or negative numbers but no mix")
            return {}
        parsed = ALL_CHAPTERS.copy()
        for chap in chap_list:
            parsed.remove(-chap)
        chap_list = parsed
    return chap_list
