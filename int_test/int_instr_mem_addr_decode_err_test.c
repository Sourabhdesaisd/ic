#include "peripheral.h"


/* ============================================================
 * IRQ9
 *
 * Instruction Memory Address Decode Error
 *
 * Valid IMEM:
 *
 *     0x0000_0000 - 0x0000_FFFF
 *
 * Invalid instruction fetch address:
 *
 *     0x0009_0000
 * ============================================================ */

#define INVALID_IMEM_ADDR    0x00090000U


int main(void)
{
    info_print(0x0000);


    /* ============================================================
     * Enable Global Machine Interrupt
     *
     * mstatus.MIE = bit[3]
     * ============================================================ */

    asm volatile (
        "li t0, 0x8\n"
        "csrrs x0, mstatus, t0\n"
        :
        :
        : "t0", "memory"
    );


    /* ============================================================
     * Enable Machine External Interrupt
     * ============================================================ */

    asm volatile (
        "li t0, 0xFC000000\n"
        "csrrs x0, mie, t0\n"
        :
        :
        : "t0", "memory"
    );


    info_print(0x1111);


    /* ============================================================
     * Prepare dynamic recovery address
     *
     * We calculate the address of the recovery point dynamically
     * and store it in mscratch.
     *
     * Therefore there is:
     *
     *     NO hardcoded recovery address
     *     NO MEPC + 4
     *     NO extern variable
     * ============================================================ */

    asm volatile (
        /*
         * Get address of local recovery label.
         *
         * The assembler/linker resolves this address.
         */
        "la t1, 1f\n"

        /*
         * Save recovery PC in mscratch.
         */
        "csrw mscratch, t1\n"

        /*
         * Load invalid instruction memory address.
         */
        "li t0, %[invalid_addr]\n"

        /*
         * Jump to invalid instruction memory.
         *
         * This causes IRQ9.
         */
        "jr t0\n"

        /*
         * ========================================================
         * Recovery point
         *
         * IRQ9 handler will set:
         *
         *     MEPC = MSCRATCH
         *
         * MRET will therefore return here.
         * ========================================================
         */
        "1:\n"
        :
        : [invalid_addr] "i" (INVALID_IMEM_ADDR)
        : "t0", "t1", "memory"
    );


    /* ============================================================
     * Execution comes here after IRQ9 handler + MRET
     * ============================================================ */

    info_print(0x3333);


    /* ============================================================
     * Test complete
     * ============================================================ */

    send_handshake_to_sv();


    info_print(0x9009);


    /* ============================================================
     * Stop execution
     * ============================================================ */


}
