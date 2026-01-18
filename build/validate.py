#!/usr/bin/env python3

import base64
from hashlib import sha256
import os
from pathlib import Path
import sys

ALLOWED_DIFFS = [146, 149, 150, 151, 152, 11393, 11394, 11395, 11396]
EXPECTED_LENGTH = 52098
EXPECTED_DIGEST = b'u7jY7LtrSWycOjwiEC0DuqM+r+Ju8fFNkF6GORijpWk='

if len(sys.argv) > 1:
    file_name = sys.argv[1]
else:
    for path in os.listdir(Path(__file__).parent):
        if path.lower() == "k.com":
            file_name = Path(__file__).parent / path
            break

if file_name is None:
    print("An argument must be supplied if k.com isn't present")
    exit(1)

contents = bytearray(open(file_name, "rb").read())
if len(contents) != EXPECTED_LENGTH:
    print(f"{file_name.name} has a length of {len(contents)} instead of the expected {EXPECTED_LENGTH}")
    exit(1)
for offset in ALLOWED_DIFFS[::-1]:
    del(contents[offset])
digest = base64.b64encode(sha256(contents).digest())
if digest != EXPECTED_DIGEST:
    print(f"{file_name.name} has a sha256 of {digest} instead of the expected {EXPECTED_DIGEST}")
    exit(1)

print(f"{file_name.name} validated successfully")

