#!/usr/bin/env python3

from pathlib import Path

for file_name in ["CODE.PAS", "GLOBALS.PAS"]:
    input_file = Path(__file__).parent.parent / file_name
    output_file = Path(__file__).parent / file_name
    encoded = open(file_name, "rb").read().decode("utf-8").encode("cp862")
    open(output_file, "wb").write(encoded)
