#!/usr/bin/env python
# Works with python2 and python3

import sys
import re

if len(sys.argv) < 3:
    print("Usage: spike_to_csv.py <spike.log> <output.csv>")
    sys.exit(1)

log_file = sys.argv[1]
csv_file = sys.argv[2]

header = ["pc","binary","instr","instr_str","operand","gpr"]

def parse_line(line):
    """
    Handles format like:
    core 0: 3 0x00001000 (0x00000297) x5 0x00001000
    core 0: 3 0x0000100c (0x0182a283) x5 0x80000000 mem 0x00001018
    """

    # Extract PC and binary
    m = re.search(r'core\s+\d+:\s+\d+\s+(0x[0-9a-fA-F]+)\s+\((0x[0-9a-fA-F]+)\)\s*(.*)', line)
    if not m:
        return None

    pc = m.group(1)
    binary = m.group(2)
    rest = m.group(3).strip()

    instr = "unknown"
    instr_str = "unknown"
    operand = ""
    gpr = ""

    # Extract register write (xN value)
    reg_match = re.search(r'(x\d+)\s+(0x[0-9a-fA-F]+)', rest)
    if reg_match:
        gpr = reg_match.group(1) + ":" + reg_match.group(2)

    # NOTE:
    # Your log does NOT contain instruction mnemonic
    # So we cannot extract real instr ? keep placeholder

    return [pc, binary, instr, instr_str, operand, gpr]


with open(log_file, 'r') as fin, open(csv_file, 'w') as fout:

    fout.write(",".join(header) + "\n")

    for line in fin:
        line = line.strip()

        if not line.startswith("core"):
            continue

        parsed = parse_line(line)

        if parsed:
            fout.write(",".join(parsed) + "\n")

print("CSV generated:", csv_file)
