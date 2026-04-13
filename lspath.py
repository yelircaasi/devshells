import os
from pathlib import Path
import re


PATH = sorted(map(Path, os.environ["PATH"].split(":")))
HOME = str(Path.home())
print(PATH)

bar = "=" * 80
nix_prefix = re.compile(r"/nix/store/[a-z]0-9]{64}")


for path_member in PATH:
    display = nix_prefix.sub("/nix/store/", str(path_member)).replace(HOME, "$HOME")
    print(f"{bar}\n{display}\n{bar}")
    if path_member.exists():
        executables = os.listdir(path_member)
        for executable in executables:
            print(executable)
