#!/usr/bin/env python

import sys
import os
import re


# ================= UTIL =================
def hex_to_int(x):
    return int(x.replace("(", "").replace(")", ""), 16)


# ================= Parse SPIKE LOG =================
def parse_spike_line(line):
    parts = line.strip().split()

    if len(parts) < 4:
        return None

    try:
        # -------- PC --------
        pc = None
        for p in parts:
            if p.startswith("0x"):
                pc = p.replace(":", "").lower()
                break

        if pc is None:
            return None

        # -------- MEM / LOAD --------
        if "mem" in parts:
            mem_idx = parts.index("mem")

            # LOAD: rd data mem addr
            if mem_idx >= 2 and parts[mem_idx - 2].startswith("x"):
                rd = parts[mem_idx - 2]
                data = parts[mem_idx - 1]
                addr = parts[mem_idx + 1]

                return ("LOAD", pc, rd, data.lower(), addr.lower())

            # STORE: mem addr data
            addr = parts[mem_idx + 1]
            data = parts[mem_idx + 2]

            return ("MEM", pc, addr.lower(), data.lower())

        # -------- REG --------
        for i in range(len(parts)):
            if parts[i].startswith("x") and i + 1 < len(parts):
                rd = parts[i]
                data = parts[i + 1]
                return ("REG", pc, rd, data.lower())

    except:
        return None


# ================= Parse RTL LOG =================
def parse_rtl_line(line):
    if "PC=" not in line:
        return None

    try:
        pc = re.search(r'PC=([0-9a-fA-F]+)', line).group(1)
        pc = "0x" + pc.lower()

        if "REG" in line:
            rd = re.search(r'RD=(x\d+)', line).group(1)
            data = re.search(r'DATA=([0-9a-fA-F]+)', line).group(1)
            return ("REG", pc, rd, "0x" + data.lower())

        elif "MEM" in line:
            addr = re.search(r'ADDR=([0-9a-fA-F]+)', line).group(1)
            data = re.search(r'DATA=([0-9a-fA-F]+)', line).group(1)
            return ("MEM", pc, "0x" + addr.lower(), "0x" + data.lower())

    except:
        return None


# ================= ARGUMENT CHECK =================
if len(sys.argv) < 3:
    print("Usage: python compare.py <spike_log> <rtl_log>")
    sys.exit(1)

SPIKE_LOG = sys.argv[1]
RTL_LOG   = sys.argv[2]

OUT_LOG = os.path.join(os.path.dirname(RTL_LOG), "compare_result.log")


# ================= READ FILES =================
spike_lines = open(SPIKE_LOG).readlines()
rtl_lines   = open(RTL_LOG).readlines()

spike = []
rtl = []

# -------- SPIKE --------
for l in spike_lines:
    parsed = parse_spike_line(l)
    if parsed:
        pc_val = int(parsed[1], 16)
        if pc_val >= 0x80000000:
            spike.append(parsed)

# -------- RTL --------
for l in rtl_lines:
    parsed = parse_rtl_line(l)
    if parsed:
        rtl.append(parsed)

print("Spike entries:", len(spike))
print("RTL entries  :", len(rtl))


# ================= OFFSET =================
OFFSET = int(os.getenv("OFFSET", 1))
rtl = rtl[OFFSET:]


# ================= COMPARE =================
print("\n===== Spike vs RTL Comparison =====\n")
print("{:<5} {:<6} {:<12} {:<12} {:<12} {}".format(
    "Idx", "Type", "PC", "OP", "DATA", "STATUS"))
print("-" * 70)

fail_count = 0
pass_count = 0

log_file = open(OUT_LOG, "w")
log_file.write("Idx Type PC OP DATA STATUS\n")

i = 0
j = 0

while i < len(spike) and j < len(rtl):

    entry_s = spike[i]

    type_s = entry_s[0]
    pc_s   = entry_s[1]

    # -------- SPIKE unpack --------
    if type_s in ["REG", "MEM"]:
        op_s   = entry_s[2]
        data_s = entry_s[3]
        addr_s = None

    elif type_s == "LOAD":
        op_s   = entry_s[2]
        data_s = entry_s[3]
        addr_s = entry_s[4]

    type_r, pc_r, op_r, data_r = rtl[j]

    # -------- TYPE MATCH --------
    if not (type_s == type_r or (type_s == "LOAD" and type_r == "REG")):
        i += 1
        continue

    # -------- PC MATCH --------
    if pc_s == pc_r:

        # -------- OPERAND CHECK --------
        if type_s == "REG":
            if op_s != op_r:
                status = "FAIL(RD)"
                fail_count += 1
                i += 1
                j += 1
                continue

        elif type_s == "MEM":
            if hex_to_int(op_s) != hex_to_int(op_r):
                status = "FAIL(ADDR)"
                fail_count += 1
                i += 1
                j += 1
                continue

        elif type_s == "LOAD":
            if op_s != op_r:
                status = "FAIL(RD)"
                fail_count += 1
                i += 1
                j += 1
                continue

        # -------- DATA CHECK --------
        if hex_to_int(data_s) != hex_to_int(data_r):
            status = "FAIL(DATA)"
            fail_count += 1
        else:
            status = "PASS"
            pass_count += 1

        print("{:<5} {:<6} {:<12} {:<12} {:<12} {}".format(
            i, type_s, pc_s, op_r, data_r, status))

        log_file.write("{} {} {} {} {} {}\n".format(
            i, type_s, pc_s, op_r, data_r, status))

        i += 1
        j += 1

    else:
        if hex_to_int(pc_s) < hex_to_int(pc_r):
            i += 1
        else:
            j += 1


# ================= SUMMARY =================
print("\n" + "=" * 60)
total = pass_count + fail_count

print("Total Compared :", total)
print("Total Passed   :", pass_count)
print("Total Failed   :", fail_count)


if fail_count == 0:
    print("\nALL MATCHED SUCCESSFULLY")
    log_file.write("\nALL MATCHED SUCCESSFULLY\n")
else:
    print("\nMISMATCH FOUND")
    log_file.write("\nMISMATCH FOUND\n")

print("\nSpike entries:", len(spike))
print("RTL entries  :", len(rtl))

log_file.close()
