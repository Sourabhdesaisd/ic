#include "peripheral.h"


/* ============================================================
 *  Masked Higher Priority IRQ
 *
 * Test:
 *
 *     IRQ10 = Priority 15, DISABLED
 *     IRQ11 = Priority 5,  ENABLED
 *
 * Both IRQ10 and IRQ11 are asserted by SV.
 *
 * Since IRQ10 is disabled, it must be excluded from
 * arbitration even though it has the higher priority.
 *
 * Expected:
 *
 *     IRQ10 -> masked / not eligible
 *     IRQ11 -> eligible
 *     current_int_id_o = IRQ11
 *     interrupt_request_o = 1
 *     IRQ11 handler entered
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

#define EXP_IRQ10_ENABLE_VALUE     0x00U
#define EXP_IRQ11_ENABLE_VALUE     0x01U

#define EXP_IRQ10_CTL_VALUE        0xF3U
#define EXP_IRQ11_CTL_VALUE        0x53U


/* ============================================================
 * GPIO PINMUX
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE     150994944U
#define EXP_GPIO_PINMUX1_VALUE     585U


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
        EXP_GPIO_PINMUX0_VALUE
    );

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR,
        EXP_GPIO_PINMUX1_VALUE
    );


    info_print(0x2000);


    /* ============================================================
     * IRQ10
     *
     * Higher priority = 15
     *
     * But IRQ10 is DISABLED.
     *
     * ENABLE = 0
     * CTL    = 0xF3
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_IRQ10_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ10_ENABLE_VALUE)
        error_print(0);
    else
        info_print(1);


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
     * IRQ11
     *
     * Lower priority = 5
     *
     * IRQ11 is ENABLED.
     *
     * ENABLE = 1
     * CTL    = 0x53
     * ============================================================ */

    mmio_write(
        IRQ11_ENABLE_REG_ADDR,
        EXP_IRQ11_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ11_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ11_ENABLE_VALUE)
        error_print(2);
    else
        info_print(3);


    mmio_write(
        IRQ11_CTL_REG_ADDR,
        EXP_IRQ11_CTL_VALUE
    );

    actual_value = mmio_read(
        IRQ11_CTL_REG_ADDR
    );

    if (actual_value != EXP_IRQ11_CTL_VALUE)
        error_print(3);
    else
        info_print(4);


    /* ============================================================
     * Configuration Complete
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * Inform SV
     *
     * SV should now:
     *
     *     1. Assert IRQ10.
     *     2. Assert IRQ11.
     *
     * Both should be pending.
     *
     * Configuration:
     *
     *     IRQ10:
     *         priority = 15
     *         enable   = 0
     *
     *     IRQ11:
     *         priority = 5
     *         enable   = 1
     *
     * Expected:
     *
     *     IRQ10 excluded from arbitration.
     *     IRQ11 selected.
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3000);


    /* ============================================================
     * Expected Arbitration
     *
     * Both sources asserted:
     *
     *     pending[10] = 1
     *     pending[11] = 1
     *
     * Eligible:
     *
     *     IRQ10 = NO
     *     IRQ11 = YES
     *
     * Therefore:
     *
     *     current_int_id_o = IRQ11_ID
     *
     *     interrupt_request_o = 1
     *
     * IRQ10 must NOT be serviced.
     * IRQ11 must be serviced.
     * ============================================================ */

    info_print(0x3011);


    /*
     * Execution returns here after IRQ11 handler executes
     * and performs mret.
     */


    info_print(0x3333);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x7032);


}
