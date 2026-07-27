#!/usr/bin/env python

import sys

BASE_ADDR = 0x80000000
MEM_BYTES = 264 * 1024

if len(sys.argv) != 3:
    print("Usage: python pinaka_mem_to_word_hex.py input.mem output.hex")
    sys.exit(1)

input_mem = sys.argv[1]
output_hex = sys.argv[2]

mem = {}
addr = BASE_ADDR

with open(input_mem, "r") as f:

    for line in f:
        line = line.strip()

        if line == "":
            continue

        if line.startswith("@"):

            # support both:
            # @00010074
            # @80010074

            tmp_addr = int(line[1:],16)

            if tmp_addr < BASE_ADDR:
                addr = BASE_ADDR + tmp_addr
            else:
                addr = tmp_addr

            continue

        for b in line.split():
            mem[addr] = int(b,16)
            addr += 1

if not mem:
    print("ERROR : empty mem file")
    sys.exit(1)

END_ADDR = BASE_ADDR + MEM_BYTES - 1

with open(output_hex,"w") as out:

    a = BASE_ADDR

    while a <= END_ADDR:

        b0 = mem.get(a+0,0)
        b1 = mem.get(a+1,0)
        b2 = mem.get(a+2,0)
        b3 = mem.get(a+3,0)

        word="%02X%02X%02X%02X\n"%(b3,b2,b1,b0)

        out.write(word)

        a += 4

print("Generated :",output_hex)
print("Base address = 0x%08X"%BASE_ADDR)
print("End address  = 0x%08X"%END_ADDR)
print("Total words =",MEM_BYTES//4)
