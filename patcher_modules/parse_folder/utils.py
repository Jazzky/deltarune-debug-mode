import os

from .. import utils

def set_content_field(config, file, db_quote=False):
    if (not os.path.isfile(file)):
        perror(f"Error: File {get_file_pos(file)} doesn't exists.")
        config['content'] = ""
        return

    with open(file) as f:
        content = f.read()
    if (db_quote):
        content = utils.set_double_quote(content)

    config['content'] = content
