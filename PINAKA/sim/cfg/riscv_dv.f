# ============================================================
# RISC-V DV Filelist (irun - FINAL, Stable, RV32IMC)
# ============================================================

-uvm

# ============================================================
# Include directories
# ============================================================

+incdir+/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src
+incdir+/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/base
+incdir+/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/comps
+incdir+/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/dap
+incdir+/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/deprecated
+incdir+/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/dpi
+incdir+/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros
+incdir+/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/tlm1
+incdir+/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/tlm2

+incdir+./third_party/riscv-dv/src
+incdir+./third_party/riscv-dv/src/isa
+incdir+./third_party/riscv-dv/target/rv32imc

# ============================================================
# Base Packages
# ============================================================

./third_party/riscv-dv/src/riscv_signature_pkg.sv
./third_party/riscv-dv/src/riscv_instr_pkg.sv

# ============================================================
# Configuration
# ============================================================

./third_party/riscv-dv/src/riscv_instr_gen_config.sv

# ============================================================
# ISA
# ============================================================

./third_party/riscv-dv/src/isa/riscv_instr.sv
./third_party/riscv-dv/src/isa/rv32i_instr.sv
./third_party/riscv-dv/src/isa/rv32m_instr.sv
./third_party/riscv-dv/src/isa/rv32c_instr.sv

# ============================================================
# Generator Core
# ============================================================

./third_party/riscv-dv/src/riscv_instr_stream.sv
./third_party/riscv-dv/src/riscv_instr_sequence.sv

# ============================================================
# Optional / Stability
# ============================================================

./third_party/riscv-dv/src/riscv_directed_instr_lib.sv
./third_party/riscv-dv/src/riscv_privileged_common_seq.sv

# ============================================================
# Target
# ============================================================

./third_party/riscv-dv/target/rv32imc/riscv_core_setting.sv
