from .. import register

import os

from ..utils import *
from .utils import *
from .csx_builder import *
from .patching_actions import execute_actions, get_command_variable

def add_gml_code_element(config):
    if (config['element_type'] == 'obj'):
        obj_options = [
            str(config['visible']).lower(),
            str(config['persistent']).lower(),
            str(config['awake']).lower()
        ]

        add_csx(register.ADD_OBJECT.replace(
            "FILE_NAME", config['obj_name']
        ).format(*obj_options))

def add_gml_element(config):
    if (not elem_declared(config['obj_name'])):
        create_new = config.get('create_new', False)
        add_declared_elem(config['obj_name'])
        if (create_new):
            add_gml_code_element(config)

    elem_identifier, queue_op = get_command_variable(config)

    if (config['keyname'][0] != '.'):
        set_content_field(config, config['keyname'], True)
        add_csx(f'importGroup.{queue_op}({elem_identifier},\n@"{config["content"]}");')

    execute_actions(config['actions'], config)

def add_csx_element(config):
    set_content_field(config, config['keyname'], db_quote=False)
    add_csx(config["content"])

def add_dir_element(config, chapter):
    from .parse_folder import parse_folder
    new_folder = config['keyname']
    parse_folder(new_folder, chapter)
