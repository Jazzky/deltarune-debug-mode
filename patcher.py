import os
import sys
from patcher_modules.main import main 

if (__name__ == "__main__"):
    os.chdir(os.path.dirname(os.path.realpath(sys.argv[0])))
    exit(main(sys.argv[1:]))
