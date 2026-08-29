#include "peripheral.h"

/* ============================================================
 * Defined in exception_handlers.c
 * ============================================================ */

extern volatile uint32_t irq5_handler_seen;


int main()
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
     * Clear handler status before generating the error
     * ============================================================ */

    irq5_handler_seen = 0U;


    /* ============================================================
     * Generate Data Memory Address Decode Error
     *
     * INT_DATA_MEM_ADDR_ERROR must be an invalid/unmapped
     * data-memory address according to your SoC address map.
     * ============================================================ */

    mmio_write(INT_DATA_MEM_ADDR_ERROR, 10U);


    /* ============================================================
     * If the invalid access generated IRQ5:
     *
     *   irq5_handler()
     *        |
     *        +--> irq5_handler_seen = 1
     *        |
     *        +--> MEPC = MEPC + 4
     *        |
     *        +--> mret
     *
     * Execution returns here.
     * ============================================================ */


    /* ============================================================
     * Self-check
     * ============================================================ */

    if (irq5_handler_seen != 1U)
    {
        error_print(0);
    }
    else
    {
        info_print(1);
    }


    /* ============================================================
     * Test PASS indication
     * ============================================================ */

    info_print(0x9005);


    /* ============================================================
     * Inform SV test is complete
     * ============================================================ */

    send_handshake_to_sv(1);

}
