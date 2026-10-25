import os
import sys

MAX_CHAPTER = 5

ALL_CHAPTERS = list(range(1, MAX_CHAPTER + 1))
SOURCE_FOLDER = "source"
OUTPUT_FILE = "debug_mode_chap{}.csx"
TEMPLATE_FILE = os.path.join("patcher_modules", "templates", "debug_mode_template.csx")

os.chdir(os.path.dirname(os.path.realpath(sys.argv[0])))
class Context:
    OWD = os.path.abspath('.')
    CWD = '.'
