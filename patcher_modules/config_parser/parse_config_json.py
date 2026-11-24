from ..setup import Context, ALL_CHAPTERS

import os
import sys
import json

from .parse_patching_elem import parse_patching_elem
from .parse_chapter_config import parse_chapter_config
from ..utils import get_file_pos

def parse_config_json(foldername, json_name):
    if (not os.path.exists(json_name)):
        print(f"Warning: `{get_file_pos(json_name)}' doesn't exist. Skipping", file=sys.stderr)
        return {}
    
    with open(json_name, "r", encoding="utf-8") as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError:
            print(f"Error: Malformed config.json in `{Context.CWD}'.", file=sys.stderr)
            return {}

    res = {}
    defaults = {
        'patchtype': 'gml',
        'keyname': '',
        'chapters': ALL_CHAPTERS.copy(),
        'mode': 'append',
        'actions': [],
        'create_new': False,
        'persistent': True,
        'visible': True,
        'awake': True,
    }

    for key, value in defaults.items():
        defaults[key] = data.get(key, value)

    optionals = ["gml_name", "element_type"]
    for opt in optionals:
        if (data.get(opt) is not None):
            defaults[opt] = data[opt]
    
    defaults['chapters'] = parse_chapter_config(defaults['chapters'])
    
    for keyname, file_config in data.items():
        to_add = parse_patching_elem(keyname, file_config, defaults)

        if (to_add == None):
            continue;

        res[keyname] = to_add

    return (res)
