OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY
{
  RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 264K
}

SECTIONS
{
  . = ORIGIN(RAM);

  .text : {
      *(.text.start)
      *(.text*)
  } > RAM

  .rodata : {
      *(.rodata*)
  } > RAM

  .data : {
      *(.data*)
  } > RAM


  . =ALIGN(8);

  .tohost 0x80000000 : {
        *(.tohost)
    } > RAM

  .bss : {
      *(.bss*)
      *(COMMON)
  } > RAM

  . = ALIGN(4);

  _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}
