from ..utils import set_double_quote
from .csx_builder import *

def get_action_newline(method, call_name, variables):
    if (method == "csx"):
        return (variables[0])

    newline = f"importGroup.{call_name}("
    for i in range(len(variables)):
        if (i != 0):
            newline += ",\n"
        newline += f'@"{set_double_quote(variables[i])}"'
    newline += "\n);"
    return (newline)

def execute_actions(action_list, config):
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

            elif method == "csx":
                call_name = ""
                call_variables = [params["content"]]

            newline = get_action_newline(method, call_name, call_variables)
            add_csx(newline)


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
