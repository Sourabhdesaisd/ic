#!/usr/bin/env python

import sys
import re

# =========================================================
# HELPERS
# =========================================================
def is_atomic(inst):
    return (int(inst, 16) & 0x7f) == 0x2f

def is_lr(inst):
    return is_atomic(inst) and (((int(inst, 16) >> 27) & 0x1f) == 0x02)

def is_sc(inst):
    return is_atomic(inst) and (((int(inst, 16) >> 27) & 0x1f) == 0x03)

def is_reg_write(inst):
    opcode = int(inst, 16) & 0x7f

    # STORE
    if opcode == 0x23:
        return False

    # BRANCH
    if opcode == 0x63:
        return False

    return True

# =========================================================
# PARSE SPIKE
# =========================================================
def parse_spike_file(filename):
    data = []

    with open(filename) as f:
        for line in f:

            m = re.search(
                r'core\s+\d+:\s+\d+\s+'
                r'(0x[0-9a-fA-F]+)\s+'
                r'\((0x[0-9a-fA-F]+)\)\s+'
                r'x(\d+)\s+'
                r'(0x[0-9a-fA-F]+)', line)

            if m:
                pc   = m.group(1).lower()
                inst = m.group(2).lower()
                rd   = m.group(3)
                wb   = m.group(4).lower()

                addr = "NA"
                val  = "NA"

                mem = re.findall(r'mem\s+(0x[0-9a-fA-F]+)\s+(0x[0-9a-fA-F]+)', line)
                if mem:
                    addr, val = mem[-1]

                data.append((pc, inst, rd, wb, addr, val))

    return data

# =========================================================
# PARSE RTL
# =========================================================
def parse_rtl_file(filename):
    data = []

    with open(filename) as f:
        for line in f:

            m = re.search(
                r'PC=(\w+)\s+INSTR=(\w+)\s+RD=(\d+)\s+DATA=(\w+)'
                r'\s+MEM_WE=(\d+)\s+MEM_ADDR=(\w+)\s+MEM_DATA=(\w+)', line)

            if m:
                pc   = "0x" + m.group(1).lower()
                inst = "0x" + m.group(2).lower()
                rd   = m.group(3)
                wb   = "0x" + m.group(4).lower()

                we   = m.group(5)
                addr = "0x" + m.group(6).lower()
                val  = "0x" + m.group(7).lower()

                if we == "1":
                    addr_out = addr
                    val_out  = val
                else:
                    addr_out = "NA"
                    val_out  = "NA"

                data.append((pc, inst, rd, wb, addr_out, val_out))

    return data

# =========================================================
# COMPARE WITH PC ALIGNMENT
# =========================================================
def compare(spike, rtl):

    print "--------------------------------------------------------------------------------"
    print "SPIKE count :", len(spike)
    print "RTL   count :", len(rtl)
    print "--------------------------------------------------------------------------------"
    print "PC           INST         RD    WB           MEM_ADDR     MEM_DATA"
    print "--------------------------------------------------------------------------------"


    i = 0
    j = 0

    total = 0

    pc_pass = 0
    pc_fail = 0

    inst_pass = 0
    inst_fail = 0

    rd_pass = 0
    rd_fail = 0

    wb_pass = 0
    wb_fail = 0

    mem_addr_pass = 0
    mem_addr_fail = 0

    mem_data_pass = 0
    mem_data_fail = 0

    total_pass = 0
    total_fail = 0

    while i < len(spike) and j < len(rtl):

        sp = spike[i]
        rt = rtl[j]

        sp_pc = int(sp[0], 16)
        rt_pc = int(rt[0], 16)

        # ALIGN
        if sp_pc < rt_pc:
            i += 1
            continue
        elif rt_pc < sp_pc:
            j += 1
            continue

        total += 1

        fail_flag = False

        # ================= PC =================
        if sp[0] == rt[0]:
            pc_pass += 1
        else:
            pc_fail += 1
            fail_flag = True

        # ================= INST =================
        if sp[1] == rt[1]:
            inst_pass += 1
        else:
            inst_fail += 1
            fail_flag = True

        # ================= RD =================
        if sp[2] == rt[2]:
            rd_pass += 1
        else:
            rd_fail += 1
            fail_flag = True

        # ================= WB =================
        if is_reg_write(sp[1]):
            if sp[3] == rt[3]:
                wb_pass += 1
            else:
                wb_fail += 1
                fail_flag = True

        # ================= MEM ADDR =================
        if sp[4] != "NA":
            if sp[4] == rt[4]:
                mem_addr_pass += 1
            else:
                mem_addr_fail += 1
                fail_flag = True

        # ================= MEM DATA =================
        if sp[5] != "NA":
            if sp[5] == rt[5]:
                mem_data_pass += 1
            else:
                mem_data_fail += 1
                fail_flag = True

        # ================= FINAL RESULT PER PC =================
        if fail_flag:
            total_fail += 1
        else:
            total_pass += 1

        i += 1
        j += 1

    # ================= FINAL SUMMARY =================
    print "\n========== FINAL SUMMARY ==========\n"

    print "TOTAL ALIGNED PC :", total
    print ""

    print "PC        PASS :", pc_pass, "FAIL :", pc_fail
    print "INST      PASS :", inst_pass, "FAIL :", inst_fail
    print "RD        PASS :", rd_pass, "FAIL :", rd_fail
    print "WB        PASS :", wb_pass, "FAIL :", wb_fail
    print "MEM_ADDR  PASS :", mem_addr_pass, "FAIL :", mem_addr_fail
    print "MEM_DATA  PASS :", mem_data_pass, "FAIL :", mem_data_fail

    print "\n========== OVERALL RESULT ==========\n"

    print "TOTAL PASS :", total_pass
    print "TOTAL FAIL :", total_fail

   
# =========================================================
# MAIN
# =========================================================
if __name__ == "__main__":

    if len(sys.argv) != 3:
        print "Usage: python compare.py spike.log rtl.log"
        sys.exit(1)

    spike = parse_spike_file(sys.argv[1])
    rtl   = parse_rtl_file(sys.argv[2])

    compare(spike, rtl)
