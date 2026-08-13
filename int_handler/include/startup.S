.option norvc
.section .text.start
.global _start

_start:

    # Initialize stack pointer
#    li sp, 0x80010000
    la sp, _stack_top

    li a0, 0x0001FFFC # Load address into a0
    li a1, 0 # Load value 0 into a1
    sw a1, 0(a0) # Store word: Memory[0x0001FFFC] = 0

    # Call C main()
    call main

## If main returns, loop forever
#hang:
#    j hang


