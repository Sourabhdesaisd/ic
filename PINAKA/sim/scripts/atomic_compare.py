#!/usr/bin/env python

import sys
import re

START_PC = "0x80000000"

def clean_hex(x):
    x = str(x).lower().strip()

    if x == "na":
        return "na"

    if x.startswith("0x"):
        x = x[2:]

    if x == "":
        return "0"

    return "0x" + x.lstrip("0") if x.lstrip("0") != "" else "0x0"


def has_x(x):
    x = str(x).lower().strip()

    if x.startswith("0x"):
        x = x[2:]

    return "x" in x


def same(a, b):
    a = clean_hex(a)
    b = clean_hex(b)

    if a == "na" and b == "na":
        return True

    if has_x(a) or has_x(b):
        return False

    return a == b



def is_valid_hex(x):
    x = str(x).lower().replace("0x", "")
    return re.match(r'^[0-9a-f]+$', x) is not None

def inst_int(inst):
    inst = clean_hex(inst)
    if not is_valid_hex(inst):
        return 0
    return int(inst, 16)

def is_atomic(inst):
    return (inst_int(inst) & 0x7f) == 0x2f

def get_type(inst):
    val = inst_int(inst)
    opcode = val & 0x7f

    if opcode != 0x2f:
        return "BASIC"

    funct5 = (val >> 27) & 0x1f

    if funct5 == 0x02:
        return "LR.W"
    elif funct5 == 0x03:
        return "SC.W"
    else:
        return "AMO"

def parse_spike_file(filename):
    data = []

    with open(filename) as f:
        for line in f:

            m = re.search(
                r'core\s+\d+:\s+\d+\s+'
                r'(0x[0-9a-fA-F]+)\s+'
                r'\((0x[0-9a-fA-F]+)\)'
                r'(?:\s+x(\d+)\s+(0x[0-9a-fA-F]+))?',
                line
            )

            if not m:
                continue

            pc   = clean_hex(m.group(1))
            inst = clean_hex(m.group(2))

            if m.group(3):
                rd = m.group(3)
                wb = clean_hex(m.group(4))
            else:
                rd = "NA"
                wb = "NA"

            mem_addr = "NA"
            mem_data = "NA"

            # IMPORTANT:
            # Spike may print:
            # mem 0x8001fa1c mem 0x8001fa1c 0x6f2a3b55
            # First mem has only address.
            # Last mem has address + data.
            mem_all = re.findall(
                r'mem\s+(0x[0-9a-fA-F]+)(?:\s+(0x[0-9a-fA-F]+))?',
                line
            )

            if mem_all:
                # Prefer last mem entry which has data
                found_data = False

                for addr, data_val in reversed(mem_all):
                    if data_val != "":
                        mem_addr = clean_hex(addr)
                        mem_data = clean_hex(data_val)
                        found_data = True
                        break

                # If no data found, take last address only
                if not found_data:
                    mem_addr = clean_hex(mem_all[-1][0])
                    mem_data = "NA"

            data.append({
                "pc": pc,
                "inst": inst,
                "rd": rd,
                "wb": wb,
                "mem_addr": mem_addr,
                "mem_data": mem_data
            })

    return data

def parse_rtl_file(filename):
    data = []

    with open(filename) as f:
        for line in f:
            m = re.search(
                r'PC=([0-9a-fA-FxX]+)\s+'
                r'INSTR=([0-9a-fA-FxX]+)\s+'
                r'RD=([0-9a-fA-FxX]+)\s+'
                r'DATA=([0-9a-fA-FxX]+)\s+'
                r'MEM_ADDR=([0-9a-fA-FxX]+)\s+'
                r'MEM_DATA=([0-9a-fA-FxX]+)',
                line
            )

            if not m:
                continue

            pc = clean_hex(m.group(1))
            inst = clean_hex(m.group(2))

            rd_raw = m.group(3)
            if has_x(rd_raw):
                rd = "x"
            else:
                rd = str(int(rd_raw, 16)) if re.search(r'[a-fA-F]', rd_raw) else str(int(rd_raw))

            wb = clean_hex(m.group(4))
            mem_addr = clean_hex(m.group(5))
            mem_data = clean_hex(m.group(6))

            data.append({
                "pc": pc,
                "inst": inst,
                "rd": rd,
                "wb": wb,
                "mem_addr": mem_addr,
                "mem_data": mem_data
            })

    return data

def trim_from_pc(trace, start_pc):
    start_pc = clean_hex(start_pc)

    for i, item in enumerate(trace):
        if clean_hex(item["pc"]) == start_pc:
            return trace[i:]

    print "ERROR: start PC %s not found" % start_pc
    sys.exit(1)

def cmp_field(name, sp, rt, errors):
    if not same(sp[name], rt[name]):
        errors.append(name.upper())

def compare(spike, rtl):
    total = min(len(spike), len(rtl))

    pass_count = 0
    fail_count = 0

    pc_pass = pc_fail = 0
    inst_pass = inst_fail = 0
    rd_pass = rd_fail = 0
    wb_pass = wb_fail = 0
    mem_addr_pass = mem_addr_fail = 0
    mem_data_pass = mem_data_fail = 0

    print "================================================================================"
    print "COMPARE START"
    print "SPIKE count :", len(spike)
    print "RTL   count :", len(rtl)
    print "COMPARE     :", total
    print "================================================================================"

    for i in range(total):
        sp = spike[i]
        rt = rtl[i]

        inst_type = get_type(sp["inst"])
        errors = []

        if same(sp["pc"], rt["pc"]):
            pc_pass += 1
        else:
            pc_fail += 1
            errors.append("PC")

        if same(sp["inst"], rt["inst"]):
            inst_pass += 1
        else:
            inst_fail += 1
            errors.append("INSTR")

        sp_rd = sp["rd"]
        rt_rd = rt["rd"] 
        
        # In your RTL trace, RD=0 means no destination register.
        # In Spike, RD=NA means no destination register.
        if sp_rd == "NA" and rt_rd == "0":
            rd_pass += 1
        elif sp_rd == "NA" and rt_rd == "NA":
            rd_pass += 1
        elif sp_rd == rt_rd:
            rd_pass += 1
        else:
            rd_fail += 1
            errors.append("RD")

        sp_wb = sp["wb"]
        rt_wb = rt["wb"]
    
        # WB compare
        if sp["wb"] == "NA":
            # Spike did not write back.
            # RTL WB stage may still show old/forwarded value, so ignore RTL WB.
            wb_pass += 1
        
        elif same(sp["wb"], rt["wb"]):
            wb_pass += 1
        
        else:
            wb_fail += 1
            errors.append("WB")

        # Compare mem only for memory/atomic instruction where Spike has mem info
        if sp["mem_addr"] == "NA":
            mem_addr_pass += 1
        elif same(sp["mem_addr"], rt["mem_addr"]):
            mem_addr_pass += 1
        else:
            mem_addr_fail += 1
            errors.append("MEM_ADDR")

        if sp["mem_data"] == "NA":
            mem_data_pass += 1
        elif same(sp["mem_data"], rt["mem_data"]):
            mem_data_pass += 1
        else:
            mem_data_fail += 1
            errors.append("MEM_DATA")

        print "\n--------------------------------------------------------------------------------"
        print "LINE  : %-6d" % i

        print "SPIKE : PC=%-12s INSTR=%-12s RD=%-5s WB=%-12s MEM_ADDR=%-12s MEM_DATA=%-12s" % \
              (sp["pc"], sp["inst"], sp["rd"], sp["wb"], sp["mem_addr"], sp["mem_data"])

        print "RTL   : PC=%-12s INSTR=%-12s RD=%-5s WB=%-12s MEM_ADDR=%-12s MEM_DATA=%-12s" % \
              (rt["pc"], rt["inst"], rt["rd"], rt["wb"], rt["mem_addr"], rt["mem_data"])

        print "TYPE  : %s" % inst_type

        if len(errors) == 0:
            print "RESULT: PASS"
            pass_count += 1
        else:
            print "RESULT: FAIL"
            print "ERROR : %s" % ",".join(errors)
            fail_count += 1

    print "\n================================================================================"
    print "FINAL SUMMARY"
    print "================================================================================"
    print "PC       PASS : %-6d FAIL : %d" % (pc_pass, pc_fail)
    print "INSTR    PASS : %-6d FAIL : %d" % (inst_pass, inst_fail)
    print "RD       PASS : %-6d FAIL : %d" % (rd_pass, rd_fail)
    print "WB       PASS : %-6d FAIL : %d" % (wb_pass, wb_fail)
    print "MEM_ADDR PASS : %-6d FAIL : %d" % (mem_addr_pass, mem_addr_fail)
    print "MEM_DATA PASS : %-6d FAIL : %d" % (mem_data_pass, mem_data_fail)

    print "\n================================================================================"
    print "OVERALL RESULT"
    print "================================================================================"
    print "PASS :", pass_count
    print "FAIL :", fail_count
    print "TOTAL:", total

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print "Usage: python compare.py spike.log rtl_trace.log"
        sys.exit(1)

    spike = parse_spike_file(sys.argv[1])
    rtl = parse_rtl_file(sys.argv[2])

    spike = trim_from_pc(spike, START_PC)
    rtl = trim_from_pc(rtl, START_PC)

    compare(spike, rtl)
