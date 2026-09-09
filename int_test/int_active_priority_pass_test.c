#include "peripheral.h"


/* ============================================================
 * Active Priority Threshold Pass
 *
 * Verify that an interrupt is accepted when its priority
 * satisfies the active priority threshold rule.
 *
 * Test condition:
 *
 *     IRQ10 priority      = 15
 *     active_lvl_pr_i     = 10
 *
 * Therefore:
 *
 *     IRQ10 priority > active threshold
 *
 * Expected:
 *
 *     pending[10]        = 1
 *     highest pending    = IRQ10
 *     current interrupt  = IRQ10
 *     interrupt request  = 1
 *     IRQ10 handler      = entered
 *
 * active_lvl_pr_i is driven/configured by SV/UVM.
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

#define EXP_IRQ10_ENABLE_VALUE     0x01U

/*
 * 0xF3:
 *
 * Priority = 15
 *
 * Use the same CTL encoding already used in previous tests.
 */
#define EXP_IRQ10_CTL_VALUE        0xF3U


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
     * Enable IRQ10
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_IRQ10_ENABLE_VALUE
    );


    /* ============================================================
     * Read IRQ10 Enable
     * ============================================================ */

    actual_value = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );


    if (actual_value != EXP_IRQ10_ENABLE_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * Configure IRQ10 Priority
     *
     * CTL = 0xF3
     *
     * Priority = 15
     *
     * This is the highest priority value used in the tests.
     * ============================================================ */

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_VALUE
    );


    /* ============================================================
     * Read IRQ10 CTL
     * ============================================================ */

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
     * SV/UVM should configure:
     *
     *     active_lvl_pr_i = 10
     *
     * and then assert ONLY IRQ10.
     *
     * ============================================================ */

    send_handshake_to_sv(1);


    /* ============================================================
     * Interrupt expected
     *
     * IRQ10 priority = 15
     *
     * active threshold = 10
     *
     * Therefore IRQ10 satisfies the threshold rule.
     *
     * Expected:
     *
     *     interrupt_request_o = 1
     *
     *     current_int_id_o    = IRQ10_ID
     *
     *     IRQ10 handler       = entered
     *
     * ============================================================ */

    info_print(0x3000);


    /* ============================================================
     * Execution resumes here after IRQ10 handler / mret.
     * ============================================================ */

    info_print(0x3333);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x7029);


    return 0;
}
