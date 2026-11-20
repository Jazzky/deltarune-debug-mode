from ..setup import Context

import os
import sys

from ..utils import get_file_pos
from .parse_chapter_config import parse_chapter_config

def parse_gml_elem(keyname, file_config):
    if (keyname[0] != "." and not os.path.isfile(keyname)):
        print(f"Error: `{keypath}' doesn't exist in {Context.CWD}, skipping", file=sys.stderr)
        return (1)

    filename = os.path.basename(keyname)
    type_predic = ""
    gml_types = [
        ['gml_GlobalScript_', 'scr'],
        ['gml_Object_', 'obj'], 
        ['gml_RoomCC_', 'room']
    ]

    gml_predic = ""
    if filename.startswith("gml_"):
        gml_predic = filename
    else:
        for elem, g_type in gml_types:
            if filename.startswith(g_type):
                gml_predic = elem + filename

    file_config['gml_name'] = file_config.get("gml_name", gml_predic)

    gml_extension = '.gml'
    if (file_config['gml_name'].endswith(gml_extension)):
        file_config['gml_name'] = file_config['gml_name'][:-len(gml_extension)]

    for elem, g_type in gml_types:
        if (file_config['gml_name'].startswith(elem)):
            type_predic = g_type
            break

    file_config['element_type'] = file_config.get('element_type', type_predic)
    if (file_config['element_type'] not in [obj[1] for obj in gml_types]):
        print(f"Error: unknown element type `{file_config['element_type']}' for file `{filename}' in `{get_file_pos(json_name)}'")
        return (1)

    left_index = 2
    right_index = -2
    if (file_config['element_type'] == 'scr'):
        file_config['obj_name'] = "_".join(file_config['gml_name'].split("_")[left_index:])
    else:
        file_config['obj_name'] = "_".join(file_config['gml_name'].split("_")[left_index:right_index])
    
    if (file_config['element_type'] == "scr"):
        file_config['variable_type'] = "UndertaleScript"
        file_config['class_id'] = "Scripts"

    elif (file_config['element_type'] == "obj"):
        file_config['variable_type'] = "UndertaleGameObject"
        file_config['class_id'] = "GameObjects"

    file_config['patchtype'] = "gml"
    return (0)


def parse_patching_elem(keyname, file_config, defaults):
    if (defaults.get(keyname) is not None):
        return (None)
    
    for key, value in defaults.items():
        file_config[key] = file_config.get(key, value)

    file_config['keyname'] = keyname
    file_config['chapters'] = parse_chapter_config(file_config['chapters'])

    error = 0
    if (os.path.isdir(keyname)):
        error = parse_directory_elem(keyname, file_config)

    elif (keyname.endswith(".csx")):
        error = parse_csx_elem(keyname, file_config)

    else:
        error = parse_gml_elem(keyname, file_config)

    if (error):
        return (None)

    return (file_config)


def parse_directory_elem(keyname, file_config):
    file_config["patchtype"] = "directory"
    return (0)

def parse_csx_elem(keyname, file_config):
    if (not os.path.isfile(keyname)):
        return (1)

    file_config["patchtype"] = "csx"
    return (0)
