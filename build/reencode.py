#!/usr/bin/env python3

from pathlib import Path

for file_name in ["CODE.PAS", "GLOBALS.PAS"]:
    input_file = Path(__file__).parent.parent / file_name
    output_file = Path(__file__).parent / file_name
    encoded = '\r\n'.join(l.strip() for l in open(file_name, "r")).encode("cp862")
    open(output_file, "wb").write(encoded)
