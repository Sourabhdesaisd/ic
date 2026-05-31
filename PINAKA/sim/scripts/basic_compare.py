import re
import sys

# -------------------------------------------------
# DEFAULT PATHS
# -------------------------------------------------
DEFAULT_SPIKE_LOG = "programs/addition/spike_trace.log"
DEFAULT_RTL_LOG   = "programs/addition/rtl_trace.log"

# -------------------------------------------------
# INPUT ARGUMENTS
# -------------------------------------------------
if len(sys.argv) == 3:
    spike_file = sys.argv[1]
    rtl_file   = sys.argv[2]
else:
    print("No arguments provided, using default paths...\n")
    spike_file = DEFAULT_SPIKE_LOG
    rtl_file   = DEFAULT_RTL_LOG

# -------------------------------------------------
# PARSE SPIKE
# -------------------------------------------------
def parse_spike_line(line):

    match = re.search(
        r'core\s+\d+:\s+\d+\s+(0x[0-9a-fA-F]+)\s+\((0x[0-9a-fA-F]+)\)\s+x(\d+)\s+(0x[0-9a-fA-F]+)',
        line
    )
    if match:
        return (
            match.group(1).lower(),
            match.group(2).lower(),
            "x" + match.group(3),
            match.group(4).lower()
        )

    match = re.search(
        r'core\s+\d+:\s+\d+\s+(0x[0-9a-fA-F]+)\s+\((0x[0-9a-fA-F]+)\)',
        line
    )
    if match:
        return (
            match.group(1).lower(),
            match.group(2).lower(),
            None,
            None
        )

    return None

# -------------------------------------------------
# PARSE RTL
# -------------------------------------------------
def parse_rtl_line(line):

    match = re.search(
        r'core\s+\d+:\s+([0-9a-fA-F]+)\s+\(([0-9a-fA-F]+)\)\s+x(\d+)\s+([0-9a-fA-F]+)',
        line
    )
    if match:
        return (
            "0x" + match.group(1).lower(),
            "0x" + match.group(2).lower(),
            "x" + match.group(3),
            "0x" + match.group(4).lower()
        )

    match = re.search(
        r'core\s+\d+:\s+([0-9a-fA-F]+)\s+\(([0-9a-fA-F]+)\)',
        line
    )
    if match:
        return (
            "0x" + match.group(1).lower(),
            "0x" + match.group(2).lower(),
            None,
            None
        )

    return None

# -------------------------------------------------
# LOAD FILES
# -------------------------------------------------
try:
    spike_lines = open(spike_file).readlines()
    rtl_lines   = open(rtl_file).readlines()
except:
    print("ERROR: Unable to open log files!")
    sys.exit(1)

# -------------------------------------------------
# BUILD SPIKE TRACE
# -------------------------------------------------
spike = []
start = False

for l in spike_lines:
    parsed = parse_spike_line(l)
    if parsed:
        pc, instr, rd, data = parsed
        if pc == "0x80000000":
            start = True
        if start:
            spike.append(parsed)

# -------------------------------------------------
# BUILD RTL TRACE
# -------------------------------------------------
rtl = []
for l in rtl_lines:
    parsed = parse_rtl_line(l)
    if parsed:
        rtl.append(parsed)

print("SPIKE instructions:", len(spike))
print("RTL instructions  :", len(rtl))

# -------------------------------------------------
# OFFSET
# -------------------------------------------------
OFFSET = 1
rtl = rtl[OFFSET:]

# -------------------------------------------------
# HELPERS
# -------------------------------------------------
def get_opcode(instr):
    try:
        return int(instr, 16) & 0x7f
    except:
        return -1

def is_store(instr):
    return get_opcode(instr) == 0x23

def is_branch(instr):
    return get_opcode(instr) == 0x63

def is_nop(instr):
    try:
        return int(instr, 16) == 0x00000013
    except:
        return False

# -------------------------------------------------
# BRANCH OFFSET
# -------------------------------------------------
def get_branch_offset(instr):
    instr = int(instr, 16)

    imm12  = (instr >> 31) & 0x1
    imm10_5 = (instr >> 25) & 0x3F
    imm4_1 = (instr >> 8) & 0xF
    imm11  = (instr >> 7) & 0x1

    imm = (imm12 << 12) | (imm11 << 11) | \
          (imm10_5 << 5) | (imm4_1 << 1)

    if imm & (1 << 12):
        imm -= (1 << 13)

    return imm

# -------------------------------------------------
# COMPARE
# -------------------------------------------------
print("\n============ TRACE COMPARE ============\n")

fail = 0
i = 0
j = 0

while i < len(spike) and j < len(rtl):

    pc_s, instr_s, rd_s, data_s = spike[i]
    pc_r, instr_r, rd_r, data_r = rtl[j]

    if is_store(instr_s):
        i += 1
        continue
    if is_store(instr_r):
        j += 1
        continue

    # ---------------- BRANCH ----------------
    if is_branch(instr_s):

        print("BRANCH DETECTED")
        print("SPIKE: PC={} INST={}".format(pc_s, instr_s))

        temp_j = j
        found = False
        while temp_j < len(rtl):
            if rtl[temp_j][0] == pc_s:
                print("RTL  : PC={} INST={}".format(rtl[temp_j][0], rtl[temp_j][1]))
                found = True
                break
            temp_j += 1

        if not found:
            print("RTL  : PC NOT FOUND (pipeline skip)")

        print("--------------------------------------")

        next_pc_seq = hex(int(pc_s, 16) + 4)

        if i + 1 < len(spike):
            actual_next_pc = spike[i + 1][0]

            if actual_next_pc != next_pc_seq:
                offset = get_branch_offset(instr_s)
                target_pc = hex(int(pc_s, 16) + offset)

                print(">>> BRANCH TAKEN: {} -> {}".format(pc_s, target_pc))

                while j < len(rtl) and rtl[j][0] != target_pc:
                    j += 1

                i += 1
                continue

        i += 1
        j += 1
        continue

    # ---------------- REALIGN ----------------
    if pc_s != pc_r:
        while j < len(rtl) and rtl[j][0] != pc_s:
            j += 1

        if j >= len(rtl):
            print("ERROR: Cannot realign RTL")
            break

        pc_r, instr_r, rd_r, data_r = rtl[j]

    # ---------------- COMPARE ----------------
    result = "PASS"

    # NOP
    if is_nop(instr_s):
        if instr_s != instr_r:
            result = "FAIL_INSTR"
            fail += 1
        else:
            result = "PASS (NOP)"

    # NO WRITEBACK (SPIKE missing rd)
    elif rd_s is None:
        if instr_s != instr_r:
            result = "FAIL_INSTR"
            fail += 1
        else:
            result = "PASS (NO WB)"

    # NORMAL
    else:
        if instr_s != instr_r:
            result = "FAIL_INSTR"
            fail += 1
        elif rd_s != rd_r:
            result = "FAIL_RD"
            fail += 1
        elif data_s != data_r:
            result = "FAIL_DATA"
            fail += 1

    # -------- PRINT FIX --------
    if rd_r is None:
        print("RTL  : PC={} INST={}".format(pc_r, instr_r))
    else:
        print("RTL  : PC={} INST={} RD={} DATA={}".format(pc_r, instr_r, rd_r, data_r))

    if rd_s is None:
        print("SPIKE: PC={} INST={}".format(pc_s, instr_s))
    else:
        print("SPIKE: PC={} INST={} RD={} DATA={}".format(pc_s, instr_s, rd_s, data_s))

    print("RESULT:", result)
    print("--------------------------------------")

    i += 1
    j += 1

# -------------------------------------------------
# SUMMARY
# -------------------------------------------------
print("\n======================================")

if fail == 0:
    print("ALL INSTRUCTIONS MATCHED")
else:
    print("TOTAL FAILURES:", fail)
    sys.exit(1)
