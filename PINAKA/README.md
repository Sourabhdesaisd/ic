# KyroSoC Project

##  Overview
KyroSoC is a scalable SoC development environment featuring:
- RTL design (SystemVerilog)
- UVM-based verification
- RISC-V (RV32IMC) software integration
- Cadence Xcelium simulation flow
- Automation-ready infrastructure

---

#  Directory Structure

```

kyrosoc/
+-- docs/
+-- rtl/
¦   +-- common/
¦   +-- ip/
¦   +-- top/
+-- tb/
¦   +-- env/
¦   +-- agents/
¦   +-- sequences/
¦   +-- tests/
¦   +-- scoreboard/
¦   +-- tb_top/
+-- sim/
¦   +-- cfg/
¦   +-- scripts/
¦   +-- regressions/
¦   +-- results/
+-- sw/
¦   +-- baremetal/
+-- build/
+-- tools/
+-- third_party/
+-- configs/
+-- Makefile
+-- README.md

```

---

#  Simulation Flow (Cadence Xcelium)

## Run Simulation
```

make run TEST=<test> SEED=<seed>

```

## GUI Debug
```

make gui TEST=<test>

```

## Regression
```

make regress

```

---

#  Output Structure

```

sim/results/
+-- logs/run_<timestamp>/sim.log
+-- waves/run_<timestamp>/wave.fsdb

```

---

#  Filelist Strategy

## Structure
```

sim/cfg/
+-- rtl.f
+-- tb.f
+-- defines.f
+-- filelist.f

```

## Compilation Order
```

defines  RTL  TB

````

---

#  Auto Filelist Generation (Recommended)

Manual filelist maintenance does not scale. Use this script:

## `tools/python/gen_filelist.py`

```python
import os

RTL_DIR = "rtl"
TB_DIR = "tb"

def collect_sv_files(base):
    files = []
    for root, _, filenames in os.walk(base):
        for f in filenames:
            if f.endswith((".sv", ".v")):
                files.append(os.path.join(root, f))
    return sorted(files)

def write_filelist(path, incdirs, files):
    with open(path, "w") as f:
        for d in incdirs:
            f.write(f"+incdir+./{d}\n")
        f.write("\n")
        for file in files:
            f.write(f"./{file}\n")

rtl_files = collect_sv_files(RTL_DIR)
tb_files = collect_sv_files(TB_DIR)

write_filelist("sim/cfg/rtl.f",
               ["rtl/common", "rtl/ip", "rtl/top"],
               rtl_files)

write_filelist("sim/cfg/tb.f",
               ["tb/env", "tb/agents", "tb/sequences", "tb/tests"],
               tb_files)

print("Filelists generated.")
````

## Usage

```
python3 tools/python/gen_filelist.py
```

---

#  RISC-V Software Flow (RV32IMC)

## Toolchain

```
riscv32-unknown-elf-gcc
```

## Architecture

```
-march=rv32imc
-mabi=ilp32
```

## Build

```
make sw_build PROG=<name>
```

## Outputs

```
build/sw/
+-- prog.elf
+-- prog.bin
+-- prog.hex
+-- prog.dis
```

---

#  Run with Software

```
make run_sw PROG=<prog> TEST=<test>
make run_hex PROG=<prog> TEST=<test>
```

---

#  Testbench Integration

```
+RISCV_PROG=<file>
```

```systemverilog
$value$plusargs("RISCV_PROG=%s", prog);
$readmemh(prog, mem);
```

---

#  RISC-V DV Integration (Advanced)

## Add riscv-dv

```
cd third_party
git clone https://github.com/google/riscv-dv.git
```

## Generate Random Programs

```
cd third_party/riscv-dv
python3 run.py --target rv32imc --test riscv_rand_test
```

## Integrate Output

* Use generated `.elf/.hex` in:

```
make run_sw PROG=<generated>
```

---

#  Spike Co-Simulation (Optional but Powerful)

## Install Spike

```
git clone https://github.com/riscv-software-src/riscv-isa-sim.git
cd riscv-isa-sim
mkdir build && cd build
../configure --prefix=/opt/spike
make -j
make install
```

## Run Spike

```
spike pk build/sw/prog.elf
```

## Use Case

* Golden reference comparison
* Signature checking in scoreboard

---

#  Regression Flow

```
sim/regressions/smoke.list
```

Run:

```
make regress
```

---

#  Clean

```
make clean
make distclean
```

---

#  Developer Onboarding (Day-1 Setup)

## 1. Clone Repo

```
git clone <repo>
cd kyrosoc
```

## 2. Setup Environment

### Cadence

```
source /path/to/cadence/setup.sh
```

### RISC-V Toolchain

```
export PATH=<riscv-toolchain>/bin:$PATH
```

Verify:

```
riscv32-unknown-elf-gcc --version
```

---

## 3. Generate Filelists

```
python3 tools/python/gen_filelist.py
```

---

## 4. Build Software

```
make sw_build PROG=hello
```

---

## 5. Run Simulation

```
make run_sw PROG=hello TEST=basic_test
```
