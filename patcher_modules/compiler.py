import os
import sys
import json
from patcher_modules import register
from patcher_modules.utils import Context, update_cwd, get_file_pos, set_double_quote
from patcher_modules.config_parser import init_basic_json, execute_actions, get_command_variable

def parse_folder(declared_elements=None, current_chapter=0):
    if declared_elements is None:
        declared_elements = []
        
    csx_lines = []
    master_config_path = "config.json"
    folder_order = []
    
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

    sub_dirs = sorted([d for d in os.listdir('.') if d[0] != '.' and os.path.isdir(d)])
    if folder_order:
        for fold in sub_dirs:
            if fold not in folders:
                print(f"Warning: `{get_file_pos(fold)}' module not used", file=sys.stderr)
    else:
        folders = sub_dirs

    for folder in folders:
        if folder.startswith('.'):
            continue

        update_cwd(folder)

        has_subdirs = any(d[0] != '.' and os.path.isdir(d) for d in os.listdir('.'))
        if has_subdirs:
            csx_lines.extend(parse_folder(declared_elements, current_chapter))
            if not os.path.exists(master_config_path):
                update_cwd('..')
                continue

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
                    if config['element_type'] == 'scr':
                        csx_lines.append(register.ADD_SCRIPT.replace("FILE_NAME", config['obj_name']))
                    elif config['element_type'] == 'obj':
                        obj_options = [str(config['visible']).lower(), str(config['persistent']).lower(), str(config['awake']).lower()]
                        csx_lines.append(register.ADD_OBJECT.replace("FILE_NAME", config['obj_name']).format(*obj_options))
                else:
                    csx_lines.append(f'{config["variable_type"]} {config["obj_name"]} = Data.{config["class_id"]}.ByName("{config["obj_name"]}");')

            elem_identifier, queue_op = get_command_variable(config)

            if real_filename[0] != '.':
                csx_lines.append(f'importGroup.{queue_op}({elem_identifier},\n@"{gml_code}");')

            execute_actions(config['actions'], config, csx_lines)

        update_cwd('..')

    return csx_lines

def compile_utmt_mod(source_folder, template_file):
    if not os.path.exists(source_folder) or not os.path.exists(template_file):
        print("Error: 'source' folder or 'template.csx' missing.")
        return

    with open(template_file, 'r', encoding='utf-8') as f:
        template_content = f.read()

    if "// BOTTOM" not in template_content:
        print("Error: '// BOTTOM' marker missing in template.csx.")
        return
        
    template_parts = template_content.split("// BOTTOM")
    template_top = template_parts[0].replace("// TOP", "").strip() 
    template_bottom = template_parts[1].strip()

    for i in range(1, 6):
        element_memory = []
        output_file = f"debug_mode_chap{i}.csx"
        final_lines = []
        
        current_top = template_top.replace("CHAPTER_NUMBER", str(i))
        current_bottom = template_bottom.replace("CHAPTER_NUMBER", str(i))

        final_lines.append(current_top)
        
        update_cwd(source_folder)
        print(f"Parsing common code for Chapter {i}...")
        common_lines = parse_folder(element_memory, i)
        
        if common_lines:
            final_lines.append(f"\n// --- COMMON CODE ---")
            final_lines.extend(common_lines)
        
        update_cwd(Context.OWD)
        final_lines.append("\n" + current_bottom)

        with open(output_file, 'w', encoding='utf-8') as out_file:
            out_file.write('\n'.join(final_lines))
            
        print(f"Success: '{output_file}' generated.\n")
