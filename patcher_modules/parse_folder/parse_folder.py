import os
import sys
import json

from .adders import *
from .csx_builder import *
from ..config_parser.parse_config_json import parse_config_json 

def parse_folder(folder, chapter):
    update_cwd(folder)

    folder_config = parse_config_json(folder, "config.json")
    for keyname, config in folder_config.items():
        if (chapter not in config['chapters']):
            continue
            
        add_csx("\n")
        
        if (config['patchtype'] == "gml"):
            add_gml_element(config)
        elif (config['patchtype'] == "csx"):
            add_csx_element(config)
        elif (config['patchtype'] == "directory"):
            add_dir_element(config, chapter)

    update_cwd('..')

def parse_master_folder(chapter):
    clear_csx()
    reset_declared_elem()

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

    for fold in os.listdir('.'):
        if fold[0] != '.' and os.path.isdir(fold) and fold not in folders:
            print(f"Warning: `{fold}' module not used", file=sys.stderr)

    for folder in folders:
        if (folder.startswith('.')):
            continue

        parse_folder(folder, chapter)

    return (get_csx())
