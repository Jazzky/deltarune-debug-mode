from . import setup

from .utils import *
from .parse_folder.parse_folder import parse_master_folder

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
    common_lines = parse_master_folder(chapter)
        
    if common_lines:
        final_lines.append(f"\n// --- COMMON CODE ---")
        final_lines.extend(common_lines)
        
    update_cwd(setup.Context.OWD)
    final_lines.append("\n" + template_bottom)

    final_code = "\n".join(final_lines)
    return (final_code)
