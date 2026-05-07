# ============================================================
# KyroSoC Full Makefile (RTL + RISC-V SW + Simulation)
# Tool: Cadence Xcelium (irun)
# Arch: RV32IMC
# ============================================================
.ONESHELL:
SHELL := /bin/bash

# =========================================================
# PHONY
# =========================================================
.PHONY: all gen build spike  rtl compare clean dirs

# =========================================================
# RANDOM SEED + MODE
# =========================================================
SEED := $(or $(SEED),$(shell od -An -N2 -tu2 < /dev/urandom | tr -d ' '))
MODE ?= base

PREFIX = $(MODE)_$(SEED)

# =========================================================
# ROOT (FROM sim)
# =========================================================
ROOT     = /home/$(USER)/Desktop/PINAKA
RISCV_DV = $(ROOT)/third_party/riscv-dv
SW_DIR   = $(ROOT)/sw
RTL_DIR  = $(ROOT)/rtl
SIM_DIR  = $(ROOT)/sim
RESULT_DIR = $(SIM_DIR)/results
SCRIPT_DIR = $(SIM_DIR)/scripts

USER_EXT = $(RISCV_DV)/user_extension

RTL_SRC = $(ROOT)/rtl/ip

LOG_DIR = $(RESULT_DIR)/logs/$(PREFIX)

CFG_DIR    = $(SIM_DIR)/cfg


# =========================================================
# ISA (FULL DEFAULT - IMPORTANT)
# =========================================================
ISA ?= RV32I,RV32M,RV32C,RV32F,RV32FC,RV32D,RV32DC,RV32A

# GCC ARCH (separate from ISA)
ARCH = -march=rv32iac

#ARCH = -march=rv32imafdc
ABI  = -mabi=ilp32

# =========================================================
# MODE FLAGS (CONTROL INSTR, NOT ISA)
# =========================================================

ifeq ($(MODE),basic)
GEN_MODE_FLAGS = \
+instr_cnt=2000 \
+directed_instr_0=riscv_load_store_rand_addr_instr_stream,20 \
+data_page_size=4096 \
+enable_unaligned_load_store=1 \
+no_branch_jump=0 \
+disable_compressed_instr=1 \
+disable_mul_div_instr=1 \
+disable_floating_point_instr=1 \
+enable_amo=0 \
+no_amo_instr=1 \
+no_compressed_instr=1 \
+no_csr_instr=1 \
+no_fence=1 \
+no_system_instr=1 \
+disable_instr=fence \
+disable_instr=fence_i \
+num_of_sub_program=0

else ifeq ($(MODE),atomic)
GEN_MODE_FLAGS = \
+isa=rv32a \
+instr_cnt=1 \
+bare_program_mode=1 \
+enable_amo=1 \
+disable_compressed_instr=1 \
+disable_mul_div_instr=1 \
+disable_floating_point_instr=1 \
+no_branch_jump=1 \
+no_csr_instr=1 \
+no_load_store=1 \
+cfg_disable_compressed_instr=1 \
+directed_instr_0=riscv_amo_instr_stream,200000 \
+directed_instr_1=riscv_lr_sc_instr_stream,200000 \
+no_fence=1 \
+num_of_sub_program=0


else ifeq ($(MODE),compressed)
GEN_MODE_FLAGS = \
+isa=rv32c \
+instr_cnt=10000 \
+bare_program_mode=1 \
+enable_compressed_instr=1 \
+disable_compressed_instr=0 \
+enable_amo=0 \
+disable_mul_div_instr=1 \
+disable_floating_point_instr=1 \
+no_branch_jump=0 \
+no_load_store=0 \
+no_csr_instr=1 \
+no_system_instr=1 \
+no_data_page=1 \
+no_stack=1 \
+num_of_sub_program=0 \
+force_compressed_instr=1

endif

# =========================================================
# TOOLCHAIN
# =========================================================
RISCV_PREFIX  = /opt/riscv64im/bin/riscv64-unknown-elf
RISCV_GCC     = $(RISCV_PREFIX)-gcc
RISCV_OBJDUMP = $(RISCV_PREFIX)-objdump
RISCV_OBJCOPY = $(RISCV_PREFIX)-objcopy

CFLAGS = $(ARCH) $(ABI) -O0 -static -nostdlib

LINKER = $(SCRIPT_DIR)/linker.ld

# =========================================================
# FILES
# =========================================================
ASM_FILE = $(SW_DIR)/$(PREFIX).S
SEED_DIR = $(RESULT_DIR)/$(PREFIX)

ELF = $(SEED_DIR)/$(PREFIX).elf
BIN = $(SEED_DIR)/$(PREFIX).bin

UVM_LOG   = $(LOG_DIR)/$(PREFIX)_uvm.log
SPIKE_LOG = $(LOG_DIR)/$(PREFIX)_spike.log
RTL_LOG   = $(LOG_DIR)/rtl_trace.log
CMP_LOG   = $(LOG_DIR)/$(PREFIX)_compare.log

RTL_FILELIST = $(CFG_DIR)/$(MODE)_rtl.f
TB_FILELIST  = $(CFG_DIR)/$(MODE)_tb.f
COMPARE_SCRIPT = $(SCRIPT_DIR)/compare.py

# Atomic detection
DO_SPLIT = $(if $(filter atomic,$(MODE)),1,0)


HEX_FILE = $(SEED_DIR)/instruction_mem.hex


INSTR_B0 = $(SEED_DIR)/instruction_mem_B0.hex
INSTR_B1 = $(SEED_DIR)/instruction_mem_B1.hex
INSTR_B2 = $(SEED_DIR)/instruction_mem_B2.hex
INSTR_B3 = $(SEED_DIR)/instruction_mem_B3.hex

# =========================================================
# DEFAULT FLOW
# =========================================================
all: dirs gen build HEX_GEN spike rtl compare

# =========================================================
# DIR SETUP
# =========================================================
dirs:
	mkdir -p $(SW_DIR)
	mkdir -p $(RESULT_DIR)
	mkdir -p $(LOG_DIR)

# =========================================================
# 1. GENERATION (riscv-dv)
# =========================================================
gen:
	@echo "========== GENERATION =========="
	@echo "MODE = $(MODE)"
	@echo "SEED = $(SEED)"
	@echo "ISA  = $(ISA)"

	mkdir -p $(SEED_DIR)

	
	cd $(RISCV_DV) && \
	xrun -64bit -sv -uvm \
	+svseed=random \
	+asm_file_name=$(PREFIX) \
	+march=$(ISA) \
	-uvmhome /tools/cadence_march2021/XCELIUM2009/tools/methodology/UVM/CDNS-1.2 \
	-f $(ROOT)/sim/cfg/files.f \
	-top riscv_instr_gen_tb_top \
	+UVM_TESTNAME=riscv_instr_base_test \
	+gen_only=1 \
	+bare_program_mode=1 \
	$(GEN_MODE_FLAGS) \
	+ntb_random_seed=random \
	-access +rwc \
	-l $(UVM_LOG)

	# Move ASM to sw/
	@if [ -f $(RISCV_DV)/$(PREFIX).S ]; then \
		mv $(RISCV_DV)/$(PREFIX).S $(SW_DIR)/; \
		echo "? ASM moved to sw/"; \
	else \
		echo "? ERROR: ASM not generated"; exit 1; \
	fi

# =========================================================
# 2. BUILD
# =========================================================
build:
	@echo "========== BUILD =========="

	@if [ ! -f $(ASM_FILE) ]; then \
		echo "ERROR: ASM missing"; exit 1; \
	fi

	mkdir -p $(SEED_DIR)

	$(RISCV_GCC) \
	$(ASM_FILE) \
	$(USER_EXT)/user_init.s \
	$(CFLAGS) \
	-I$(USER_EXT) \
	-T $(LINKER) \
	-o $(ELF)

	$(RISCV_OBJDUMP) -d $(ELF) > $(SEED_DIR)/$(PREFIX).objdump

	$(RISCV_OBJCOPY) -O binary $(ELF) $(BIN)
	
	$(RISCV_OBJCOPY) -O verilog $(ELF) $(SEED_DIR)/$(PREFIX).mem

	$(MAKE) HEX_GEN MODE=$(MODE)

	

# ============================================================
# HEX GENERATION (MODE BASED)
# ============================================================

HEX_GEN:
	echo "MODE = $(MODE)"

	$(RISCV_OBJCOPY) -O binary --only-section=.text $(ELF) $(SEED_DIR)/text.bin

	HEX_FILE=$(SEED_DIR)/instruction_mem.hex

	if [ "$(MODE)" = "basic" ]; then
	    echo "Basic Mode ? 32-bit HEX"
	    xxd -p -c 4 $(SEED_DIR)/text.bin | \
	    sed 's/\(..\)\(..\)\(..\)\(..\)/\4\3\2\1/' > $$HEX_FILE

	elif [ "$(MODE)" = "atomic" ]; then
	    echo "Atomic Mode ? 32-bit HEX + split"
	    xxd -p -c 4 $(SEED_DIR)/text.bin | \
	    sed 's/\(..\)\(..\)\(..\)\(..\)/\4\3\2\1/' > $$HEX_FILE
	    cd $(SEED_DIR)
		echo "Running split script..."
		cd $(SEED_DIR) && python $(SCRIPT_DIR)/split_hex.py instruction_mem.hex

		echo "Generating single 32-bit data memory hex..."
		cd $(SEED_DIR) && python $(SCRIPT_DIR)/mem_to_word_hex.py \
		$(SEED_DIR)/$(PREFIX).mem \
		$(SEED_DIR)/program_data.hex

	elif [ "$(MODE)" = "compressed" ]; then
	    echo "Compressed Mode ? BYTE HEX"
	    hexdump -v -e '1/1 "%02x\n"' $(SEED_DIR)/text.bin > $$HEX_FILE

	else
	    echo "Default Mode ? BYTE HEX"
		xxd -p -c 4 $(SEED_DIR)/text.bin | \
	    sed 's/\(..\)\(..\)\(..\)\(..\)/\4\3\2\1/' > $$HEX_FILE
	fi

	echo "HEX generated: $$HEX_FILE"
# =========================================================
# 3. SPIKE
# =========================================================
spike:
	@echo "========== SPIKE =========="

	env LD_LIBRARY_PATH=/home/sgeuser8/gcc-10-install/lib64:$$LD_LIBRARY_PATH \
	/home/sgeuser8/riscv-isa-sim/build/spike --log-commits --isa=RV32IAC $(ELF) \
	> $(SPIKE_LOG) 2>&1



# =========================================================
# 4. RTL
# =========================================================

rtl:
	@echo "========== RTL =========="
	@echo "MODE = $(MODE)"

	mkdir -p $(LOG_DIR)

ifeq ($(MODE),atomic)
	@echo "Atomic Mode ? Using split instruction memory"
	cd $(SIM_DIR) && \
	xrun -access +rwc \
	-f $(SIM_DIR)/cfg/$(MODE)_rtl.f \
	-f $(SIM_DIR)/cfg/$(MODE)_tb.f \
	+test=$(PREFIX) \
	+seed=$(SEED) \
	+log_dir=$(LOG_DIR) \
	+instr_file_B0=$(INSTR_B0) \
	+instr_file_B1=$(INSTR_B1) \
	+instr_file_B2=$(INSTR_B2) \
	+instr_file_B3=$(INSTR_B3) \
	+data_file=$(SEED_DIR)/program_data.hex \
	+trace_file=$(LOG_DIR)/rtl_trace.log \
	-l $(LOG_DIR)/rtl_run.log 

else
	@echo "Basic/Compressed Mode ? Using single HEX"
	cd $(SIM_DIR) && \
	xrun -access +rwc \
	-f $(SIM_DIR)/cfg/$(MODE)_rtl.f \
	-f $(SIM_DIR)/cfg/$(MODE)_tb.f \
	+test=$(PREFIX) \
	+seed=$(SEED) \
	+log_dir=$(LOG_DIR) \
	+instr_file=$(SEED_DIR)/instruction_mem.hex \
	+trace_file=$(LOG_DIR)/rtl_trace.log \
	-l $(LOG_DIR)/rtl_run.log 

endif


# =========================================================
# 5. COMPARE
# =========================================================
compare:
	@echo "========== COMPARE =========="

	python $(SCRIPT_DIR)/$(MODE)_compare.py \
    $(LOG_DIR)/$(PREFIX)_spike.log \
    $(LOG_DIR)/rtl_trace.log | tee $(LOG_DIR)/compare.log	

	@echo "TEST = $(PREFIX)"
	@echo "ISA  = $(ISA)"
	

# ============================================================
# Help (Updated)
# ============================================================

.PHONY: help
help:
	@echo "===================================================="
	@echo " KyroSoC Makefile Help"
	@echo "===================================================="
	@echo ""
	@echo "Simulation:"
	@echo " make run TEST=<test> SEED=<seed>"
	@echo " make gui TEST=<test>"
	@echo ""
	@echo "RISC-V Build:"
	@echo " make sw_build PROG=<name>"
	@echo ""
	@echo "Run with SW:"
	@echo " make run_sw PROG=<name> TEST=<test>"
	@echo " make run_hex PROG=<name> TEST=<test>"
	@echo ""
	@echo "Regression:"
	@echo " make regress"
	@echo ""
	@echo "Clean:"
	@echo " make clean"
	@echo " make distclean"
	@echo ""
	@echo "Variables:"
	@echo " TEST         = $(TEST)"
	@echo " SEED         = $(SEED)"
	@echo " PROG         = $(PROG)"
	@echo " RISCV_ARCH   = $(RISCV_ARCH)"
	@echo " RISCV_ABI    = $(RISCV_ABI)"
	@echo ""
	@echo "Examples:"
	@echo " make run TEST=basic_test"
	@echo " make run_sw PROG=hello TEST=core_test"
	@echo " make run_hex PROG=hello"
	@echo "===================================================="
