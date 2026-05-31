#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os

# -----------------------------
# Check arguments
# -----------------------------
if len(sys.argv) < 2:
    print "Usage: python split_hex.py <input_hex>"
    sys.exit(1)

input_hex = sys.argv[1]

# -----------------------------
# Check file exists
# -----------------------------
if not os.path.isfile(input_hex):
    print "ERROR: File not found: %s" % input_hex
    sys.exit(1)

# -----------------------------
# Output paths
# -----------------------------
out_dir = os.path.dirname(os.path.abspath(input_hex))

b0_path = os.path.join(out_dir, "instruction_mem_B0.hex")
b1_path = os.path.join(out_dir, "instruction_mem_B1.hex")
b2_path = os.path.join(out_dir, "instruction_mem_B2.hex")
b3_path = os.path.join(out_dir, "instruction_mem_B3.hex")

MAX_DEPTH = 32768   # memory depth per bank

# -----------------------------
# Read HEX input
# -----------------------------
f = open(input_hex, "r")
lines = []
for line in f:
    line = line.strip()
    if line:
        lines.append(line)
f.close()

# Limit total instructions (256 * 4 bytes)
lines = lines[:MAX_DEPTH * 4]

# -----------------------------
# Split into banks
# -----------------------------
bank0 = []
bank1 = []
bank2 = []
bank3 = []

for line in lines:
    # Convert to 32-bit (8 hex chars)
    inst = line.zfill(8)

    # Little-endian split
    bank3.append(inst[0:2])   # MSB
    bank2.append(inst[2:4])
    bank1.append(inst[4:6])
    bank0.append(inst[6:8])   # LSB

# -----------------------------
# Write banks
# -----------------------------
def write_bank(path, data):
    f = open(path, "w")
    for i in range(MAX_DEPTH):
        if i < len(data):
            f.write(data[i] + "\n")
        else:
            f.write("00\n")   # padding
    f.close()

write_bank(b0_path, bank0)
write_bank(b1_path, bank1)
write_bank(b2_path, bank2)
write_bank(b3_path, bank3)

# -----------------------------
# Done
# -----------------------------
print "HEX split done successfully!"
print "Generated files:"
print "  %s" % b0_path
print "  %s" % b1_path
print "  %s" % b2_path
print "  %s" % b3_path
