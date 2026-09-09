#include "peripheral.h"


/* ============================================================
 * TC025 : Single Pending Interrupt
 *
 * Verify that when exactly one interrupt is eligible:
 *
 *     pending      = IRQ10
 *     highest      = IRQ10
 *     current ID   = IRQ10
 *     request      = 1
 *     handler      = IRQ10 handler
 *
 * No other IRQ should be selected.
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

#define EXP_IRQ_ENABLE_VALUE      0x01U

/*
 * IRQ10 control:
 *
 * Priority = 1
 * Keep the same encoding used in previous tests.
 */
#define EXP_IRQ10_CTL_VALUE       0xF3U


int main(void)
{
    uint32_t actual_value;


    /* ============================================================
     * Test Start
     * ============================================================ */

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
     *
     * Keep existing configuration.
     *
     * 0xFC000000
     * ============================================================ */

    asm volatile (
        "li t0, 0xFC000000\n"
        "csrrs x0, mie, t0\n"
    );


    info_print(0x1111);


    /* ============================================================
     * GPIO PINMUX Configuration
     * ============================================================ */

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR,
        150994944U
    );

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR,
        585U
    );


    info_print(0x2000);


    /* ============================================================
     * Enable ONLY IRQ10
     *
     * Other IRQs are not enabled by this test.
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );


    actual_value = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );


    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * Configure IRQ10
     *
     * IRQ10 CTL is RW.
     *
     * Priority = 1
     * ============================================================ */

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_VALUE
    );


    actual_value = mmio_read(
        IRQ10_CTL_REG_ADDR
    );


    if (actual_value != EXP_IRQ10_CTL_VALUE)
        error_print(1);
    else
        info_print(2);


    /* ============================================================
     * Configuration Complete
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * Inform SV
     *
     * SV must:
     *
     *     1. Assert ONLY IRQ10 source.
     *     2. Keep IRQ11-IRQ15 inactive.
     *     3. Keep all other interrupt sources inactive.
     *
     * Expected:
     *
     *     pending[10]       = 1
     *     highest_pending   = IRQ10
     *     current_int_id    = IRQ10 ID
     *     interrupt_request = 1
     *     IRQ10 handler     = entered
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3000);


    /* ============================================================
     * Interrupt Service
     *
     * CPU should enter IRQ10 handler.
     *
     * IRQ10 handler should print:
     *
     *     0xA010
     *
     * and perform ACK/EOI according to the IC implementation.
     *
     * After mret, execution returns here.
     * ============================================================ */

    info_print(0x3333);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x7007);

}
