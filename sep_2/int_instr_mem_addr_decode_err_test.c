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
    );


    /* ============================================================
     * Enable Machine External Interrupt
     * ============================================================ */

    asm volatile (
        "li t0, 0xFC000000\n"
        "csrrs x0, mie, t0\n"
    );


    info_print(0x1111);


    /* ============================================================
     * Trigger Instruction Memory Address Decode Error
     *
     * Load invalid instruction address into t0.
     *
     * jr t0 will change the PC to 0x0009_0000.
     *
     * This address is outside the valid IMEM range.
     * ============================================================ */

    asm volatile (
        "li t0, 0x00090000\n"
        "jr t0\n"
    );


    /*
     * Execution should return here after IRQ9 handler.
     *
     * Handler:
     *
     *     MEPC = MEPC + 4
     *
     * Therefore the CPU skips the faulting jump instruction
     * and continues with the next valid instruction.
     */


    info_print(0x3333);


    /* ============================================================
     * Test complete
     * ============================================================ */

    send_handshake_to_sv();


    info_print(0x9009);


}
