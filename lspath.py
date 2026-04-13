import os
from pathlib import Path


PATH = list(map(Path, os.environ["PATH"].split(":")))

print(PATH)

bar = "=" * 80

for path_member in PATH:
    print(f"{bar}\n{path_member}\n{bar}")
    if path_member.exists():
        executables = os.listdir(path_member)
        for executable in executables:
            print(executable)