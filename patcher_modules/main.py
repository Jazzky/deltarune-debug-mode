from . import setup

import os
from .compiler import compile_utmt_mod

def handle_argv(argv):
    if (len(argv) == 1):
        setup.TEMPLATE_FILE = argv[1]

def create_csx_file(chapter):
    template_file = setup.TEMPLATE_FILE
    if not (os.path.isfile(template_file)):
        print(f"Error: template file {template_file} doesn't exists");
        return (1)

    output_mod = compile_utmt_mod(
        source_folder=setup.SOURCE_FOLDER,
        template_file=template_file,
        chapter=chapter
    )

    if (output_mod == None):
        return (1)

    output_file = setup.OUTPUT_FILE.format(chapter)
    with open(output_file, "w") as f:
        f.write(output_mod)
    print(f"Success: '{output_file}' generated.\n")


def main(argv):
    handle_argv(argv)

    if not (os.path.isdir(setup.SOURCE_FOLDER)):
        print(f"Error: source folder {setup.SOURCE_FOLDER} doesn't exists")
        return (1)

    for chapter in setup.ALL_CHAPTERS:
        error = create_csx_file(chapter)
        if (error):
            return (1)
    return (0)
