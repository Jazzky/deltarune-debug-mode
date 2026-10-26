from . import setup

import os
import sys
import json
from patcher_modules import register
from patcher_modules.utils import update_cwd, get_file_pos, set_double_quote
from patcher_modules.config_parser import init_basic_json, execute_actions, get_command_variable

def parse_folder(current_chapter=1):
    csx_lines = []
    master_config_path = "config.json"
    folder_order = []
    declared_elements = []
    
    if os.path.exists(master_config_path):
        with open(master_config_path, 'r', encoding='utf-8') as f:
            try:
                master_config = json.load(f)
                folder_order = master_config.get("order", [])
            except json.JSONDecodeError:
                print(f"Error: Malformed master {get_file_pos(master_config_path)}.")

    folders = []
    for fold in folder_order:
        if not os.path.exists(fold):
            print(f"Warning: {master_config_path} `{fold}' doesn't exist", file=sys.stderr)
        elif not os.path.isdir(fold):
            print(f"Warning: `{fold}' isn't a folder", file=sys.stderr)
        else:
            folders.append(fold)

    for fold in os.listdir('.'):
        if fold[0] != '.' and os.path.isdir(fold) and fold not in folders:
            print(f"Warning: `{fold}' module not used", file=sys.stderr)

    for folder in folders:
        if folder.startswith('.'):
            continue

        update_cwd(folder)
        folder_config = init_basic_json(folder, master_config_path)

        for filename, config in folder_config.items():
            real_filename = filename.split('|')[0]
            
            if real_filename[0] != '.':
                with open(real_filename, 'r', encoding='utf-8') as f:
                    gml_code = set_double_quote(f.read())
            
            if current_chapter not in config['chapters']:
                continue
                
            csx_lines.append("\n")
            create_new = config.get('create_new', False)
            execute_actions(config['pre_actions'], config, csx_lines)
            
            if config['obj_name'] not in declared_elements:
                declared_elements.append(config['obj_name'])
                if create_new:
                    if config['element_type'] == 'obj':
                        obj_options = [str(config['visible']).lower(), str(config['persistent']).lower(), str(config['awake']).lower()]
                        csx_lines.append(register.ADD_OBJECT.replace("FILE_NAME", config['obj_name']).format(*obj_options))

            elem_identifier, queue_op = get_command_variable(config)

            if real_filename[0] != '.':
                csx_lines.append(f'importGroup.{queue_op}({elem_identifier},\n@"{gml_code}");')

            execute_actions(config['actions'], config, csx_lines)

        update_cwd('..')

    return csx_lines

def compile_utmt_mod(source_folder, template_file, chapter):
    with open(template_file, 'r', encoding='utf-8') as f:
        template_content = f.read()

    
    template_parts = template_content.split("// SEPARATION")
    if (len(template_parts) != 2):
        print(f"Error: there should be only one '// SEPARATION' marker in {template_file}.")
        return (None)

    template_top = template_parts[0].replace("CHAPTER_NUMBER", str(chapter))
    template_bottom = template_parts[1].replace("CHAPTER_NUMBER", str(chapter))

    final_lines = []
    final_lines.append(template_top)
        
    update_cwd(source_folder)
    print(f"Parsing common code for Chapter {chapter}...")
    common_lines = parse_folder(chapter)
        
    if common_lines:
        final_lines.append(f"\n// --- COMMON CODE ---")
        final_lines.extend(common_lines)
        
    update_cwd(setup.Context.OWD)
    final_lines.append("\n" + template_bottom)

    final_code = "\n".join(final_lines)
    return (final_code)
