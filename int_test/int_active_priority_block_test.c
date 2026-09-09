#include "peripheral.h"


/* ============================================================
 * Active Priority Threshold Block
 *
 * Test condition:
 *
 *     IRQ10 priority      = 5
 *     active_lvl_pr_i     = 10
 *
 * Therefore:
 *
 *     5 < 10
 *
 * IRQ10 must NOT be delivered while the active priority
 * threshold is 10.
 *
 * Expected while blocked:
 *
 *     pending[10]        = 1
 *     current_int_id     = IRQ10 / implementation dependent
 *     interrupt_request  = 0
 *
 *
 * Then SV changes:
 *
 *     active_lvl_pr_i = 3
 *
 * Now:
 *
 *     5 > 3
 *
 * IRQ10 becomes eligible.
 *
 * Expected:
 *
 *     interrupt_request = 1
 *     current_int_id    = IRQ10
 *     IRQ10 handler      = entered
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

#define EXP_IRQ10_ENABLE_VALUE     0x01U

/*
 * IRQ10 priority = 5
 *
 * CTL encoding:
 *
 *     0x53
 *
 * Priority = 5
 */
#define EXP_IRQ10_CTL_VALUE        0x53U


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
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_IRQ10_ENABLE_VALUE
    );


    /* ============================================================
     * Read IRQ10 ENABLE
     * ============================================================ */

    actual_value = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );


    if (actual_value != EXP_IRQ10_ENABLE_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * Configure IRQ10 priority
     *
     * CTL = 0x53
     *
     * Priority = 5
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
     * SV should:
     *
     *     1. Configure active_lvl_pr_i = 10
     *     2. Assert ONLY IRQ10
     *
     * IRQ10 priority = 5
     *
     * Therefore:
     *
     *     5 < 10
     *
     * IRQ10 must be blocked.
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3000);


    /* ============================================================
     * BLOCKED PHASE
     *
     * SV should verify:
     *
     *     pending[10]        = 1
     *     interrupt_request  = 0
     *
     * CPU must NOT enter irq10_handler() at this point.
     *
     * The pending interrupt must be retained.
     *
     * ============================================================ */

    info_print(0x3010);


    /*
     * ------------------------------------------------------------
     * IMPORTANT
     *
     * Do not generate another interrupt here.
     *
     * SV should now change:
     *
     *     active_lvl_pr_i = 3
     *
     * while keeping IRQ10 pending.
     *
     * ------------------------------------------------------------
     */


    info_print(0x3020);


    /* ============================================================
     * ELIGIBLE PHASE
     *
     * New condition:
     *
     *     IRQ10 priority = 5
     *     active_lvl_pr_i = 3
     *
     * Therefore:
     *
     *     5 > 3
     *
     * IRQ10 must now become eligible.
     *
     * Expected:
     *
     *     interrupt_request_o = 1
     *     current_int_id_o    = IRQ10
     *     IRQ10 handler       = entered
     *
     * ============================================================ */

    info_print(0x3030);


    /*
     * Execution reaches here after irq10_handler()
     * executes mret.
     */


    info_print(0x3333);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x7030);


}
