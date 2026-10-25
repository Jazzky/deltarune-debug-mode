from .setup import Context, ALL_CHAPTERS

import os
import sys
import json
from patcher_modules.utils import get_file_pos, parse_chapter_config, set_double_quote

def init_basic_json(foldername, json_name):
    if not os.path.exists(json_name):
        print(f"Warning: `{get_file_pos(json_name)}' doesn't exist. Skipping", file=sys.stderr)
        return {}
    
    with open(json_name, "r", encoding="utf-8") as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError:
            print(f"Error: Malformed config.json in `{Context.CWD}'.", file=sys.stderr)
            return {}

    flattened_data = {}
    for key, value in data.items():
        if isinstance(value, list) and len(value) > 0 and isinstance(value[0], dict):
            for i, sub_value in enumerate(value):
                flattened_data[f"{key}|{i}"] = sub_value
        else:
            flattened_data[key] = value
    data = flattened_data

    res = {}
    defaults = {
        'mode': 'append',
        'chapters': ALL_CHAPTERS.copy(),
        'pre_actions': [],
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
        if data.get(opt) is not None:
            defaults[opt] = data[opt]
    
    defaults['chapters'] = parse_chapter_config(defaults['chapters'])
    
    for filename, file_config in data.items():
        real_filename = filename.split('|')[0]
        
        if defaults.get(filename) is not None:
            continue
        
        if real_filename[0] != '.' and not os.path.exists(real_filename):
            print(f"Error: `{real_filename}' doesn't exist in {Context.CWD}, skipping", file=sys.stderr)
            continue

        for key, value in defaults.items():
            file_config[key] = file_config.get(key, value)

        file_config['chapters'] = parse_chapter_config(file_config['chapters'])

        type_predic = ""
        gml_types = [
            ['gml_GlobalScript_', 'scr'],
            ['gml_Object_', 'obj'], 
            ['gml_RoomCC_', 'room']
        ]

        gml_predic = ""
        if real_filename.startswith("gml_"):
            gml_predic = real_filename
        else:
            for elem, g_type in gml_types:
                if real_filename.startswith(g_type):
                    gml_predic = elem + real_filename

        file_config['gml_name'] = file_config.get("gml_name", gml_predic)

        gml_extension = '.gml'
        if file_config['gml_name'].endswith(gml_extension):
            file_config['gml_name'] = file_config['gml_name'][:-len(gml_extension)]

        for elem, g_type in gml_types:
            if file_config['gml_name'].startswith(elem):
                type_predic = g_type
                break

        file_config['element_type'] = file_config.get('element_type', type_predic)
        if file_config['element_type'] not in [obj[1] for obj in gml_types]:
            print(f"Error: unknown element type `{file_config['element_type']}' for file `{real_filename}' in `{get_file_pos(json_name)}'")
            continue

        left_index = 2
        right_index = -2
        if file_config['element_type'] == 'scr':
            file_config['obj_name'] = "_".join(file_config['gml_name'].split("_")[left_index:])
        else:
            file_config['obj_name'] = "_".join(file_config['gml_name'].split("_")[left_index:right_index])
        
        if file_config['element_type'] == 'obj' and not file_config['gml_name'].endswith("Create_0"):
            file_config['create_new'] = False

        if file_config['element_type'] == "scr":
            file_config['variable_type'] = "UndertaleScript"
            file_config['class_id'] = "Scripts"
        elif file_config['element_type'] == "obj":
            file_config['variable_type'] = "UndertaleGameObject"
            file_config['class_id'] = "GameObjects"

        res[filename] = file_config

    return res

def execute_actions(action_list, config, csx_lines):
    file_suffix = "_file"
    for action in action_list:
        for method, params in action.items():
            params_copy = params.copy()
            for key, value in params_copy.items():
                if key.endswith(file_suffix):
                    with open(value, encoding="utf-8") as f:
                        params[key[:-len(file_suffix)]] = f.read()
            
            gml_name = config["gml_name"]
            call_variables = []
            if method == "find_replace":
                call_name = "QueueFindReplace"
                call_variables = [gml_name, params["find"], params["replace"]]

            elif method == "regex_find_replace":
                call_name = "QueueRegexFindReplace"
                call_variables = [gml_name, params["find"], params["replace"]]

            elif method == "append":
                call_name = "QueueAppend"
                call_variables = [gml_name, params["content"]]

            elif method == "replace":
                call_name = "QueueReplace"
                call_variables = [gml_name, params["content"]]

            newline = f"importGroup.{call_name}("
            for i in range(len(call_variables)):
                if (i != 0):
                    newline += ",\n"
                newline += f'@"{call_variables[i]}"'
            newline += "\n);"
            csx_lines.append(newline)


def get_command_variable(config):
    elem_type = config['element_type']
    mode = config['mode']
    obj_name = config['obj_name']
    gml_name = config['gml_name']

    elem_identifier = ""
    queue_op = ""

    elem_identifier = f'"{gml_name}"'
    if mode == "replace":
        queue_op = "QueueReplace"
    elif mode == "append":
        queue_op = "QueueAppend"
    elif mode == "prepend":
        queue_op = "QueuePrepend"

    return elem_identifier, queue_op
