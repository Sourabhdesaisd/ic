# Directory: sim

## Description
> Add description of this directory.

## Contents
- List important files/modules here

## Usage
> Explain how to use the contents

## Notes
> Any additional notes


### Normal run command

## BASIC

make MODE=basic ISA=RV32I

##COMPRESSED


make MODE=compressed ISA=RV32C

## ATOMIC


make MODE=atomic ISA=RV32I,RV32A


### Regression Run Commands


## BASIC
./run_regression.sh basic RV32I 100

##COMPRESSED

./run_regression.sh compressed RV32C 100


## ATOMIC
./run_regression.sh atomic "RV32I,RV32A" 100



# Atomic Instruction Run – Verification Note

## Overview
This run is configured specifically for **Atomic (AMO / LR-SC) instruction verification**.  
The goal is to stress the Atomic instruction stream while minimizing unrelated random instruction generation.

---

## Configuration Used

The  configuration is applied in the Makefile:

+instr_cnt=1

---

## Purpose of `instr_cnt = 1`

`instr_cnt` is intentionally set to **1** to:

- Minimize generation of normal random instructions
- Prioritize **AMO directed instruction stream**
- Prioritize **LR/SC directed instruction stream**
- Keep verification focused on **Atomic core behavior**

As a result, only **one basic random instruction** may be generated at the very end of the program.

---

## Expected End-of-Program Behavior

After completion of Atomic instructions, riscv-dv may append **one basic random instruction**.

### Expected PASS cases
If the final basic instruction is:

- `LUI`
- `AUIPC`
- `ADDI`

then the complete run is expected to **PASS**.

---

## Acceptable Final Instruction Failure

If the last generated instruction is another **basic instruction**, such as:

- `SLTI`
- `XORI`
- `ORI`
- `ANDI`
- `SLLI`
- `SRLI`
- `SRAI`
- `ADD`
- `SUB`
- `XOR`
- `OR`
- `AND`

then:

- **All AMO instructions must PASS**
- **All LR/SC instructions must PASS**
- **Only the final basic instruction may FAIL**

This failure is acceptable because it belongs to **basic random instruction generation**, not to the Atomic instruction stream.

---

## Pass Criteria

| Check                                           | Expected Result |
|-------------------------------------------------|-----------------|
| AMO instruction execution                       | PASS |
| LR/SC instruction execution                     | PASS |
| Final instruction = LUI / AUIPC / ADDI          | PASS |
| Final instruction = any other basic instruction | Only final instruction may FAIL |

---

## Conclusion

If:

- Atomic instruction sequence passes
- LR/SC sequence passes
- Only the last appended basic random instruction fails (if generated)

then **Atomic core verification is considered successful**.
