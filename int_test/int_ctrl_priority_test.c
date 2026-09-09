#include "peripheral.h"


/* ============================================================
 * Interrupt Control Programming
 *
 * IRQ0-IRQ9:
 *     CTL registers are RO.
 *     Read reset/implemented value and check it.
 *
 * IRQ10-IRQ15:
 *     CTL registers are RW.
 *     Program legal priority/control value.
 *     Read back and compare.
 *
 * Control value used for programmable IRQs:
 *
 *     0xD3
 *
 * After programming, SV can generate multiple IRQs and verify
 * that interrupt arbitration follows the programmed priority.
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

/* IRQ0-IRQ9 : RO reset values */

#define EXP_IRQ0_CTL_VALUE      0xFFU
#define EXP_IRQ1_CTL_VALUE      0xFFU
#define EXP_IRQ2_CTL_VALUE      0xFFU
#define EXP_IRQ3_CTL_VALUE      0xFFU
#define EXP_IRQ4_CTL_VALUE      0xFFU
#define EXP_IRQ5_CTL_VALUE      0xFFU
#define EXP_IRQ6_CTL_VALUE      0xFFU
#define EXP_IRQ7_CTL_VALUE      0xFFU
#define EXP_IRQ8_CTL_VALUE      0xFFU
#define EXP_IRQ9_CTL_VALUE      0xFFU


/* IRQ10-IRQ15 : RW */

#define EXP_IRQ10_CTL_VALUE     0xA3U
#define EXP_IRQ11_CTL_VALUE     0xB3U
#define EXP_IRQ12_CTL_VALUE     0xC3U
#define EXP_IRQ13_CTL_VALUE     0xD3U
#define EXP_IRQ14_CTL_VALUE     0xE3U
#define EXP_IRQ15_CTL_VALUE     0xF3U


int main(void)
{
    uint32_t actual_ctl;


    /* ============================================================
     * Test Start
     * ============================================================ */

    info_print(0x0000);


    /* ============================================================
     * Enable Global Machine Interrupt
     *
     * mstatus.MIE = 1
     * ============================================================ */

    asm volatile (
        "li t0, 0x8\n"
        "csrrs x0, mstatus, t0\n"
    );


    /* ============================================================
     * Enable Machine External Interrupt
     *
     * Keep existing configuration.
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
     * IRQ0
     *
     * CTL[0] is RO.
     * Expected reset/implemented value = 0xFF.
     * ============================================================ */

    actual_ctl = mmio_read(IRQ0_CTL_REG_ADDR);

    if (actual_ctl != EXP_IRQ0_CTL_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * IRQ1
     *
     * CTL[1] is RO.
     * ============================================================ */

    actual_ctl = mmio_read(IRQ1_CTL_REG_ADDR);

    if (actual_ctl != EXP_IRQ1_CTL_VALUE)
        error_print(1);
    else
        info_print(2);


    /* ============================================================
     * IRQ2
     * ============================================================ */

    actual_ctl = mmio_read(IRQ2_CTL_REG_ADDR);

    if (actual_ctl != EXP_IRQ2_CTL_VALUE)
        error_print(2);
    else
        info_print(3);


    /* ============================================================
     * IRQ3
     * ============================================================ */

    actual_ctl = mmio_read(IRQ3_CTL_REG_ADDR);

    if (actual_ctl != EXP_IRQ3_CTL_VALUE)
        error_print(3);
    else
        info_print(4);


    /* ============================================================
     * IRQ4
     * ============================================================ */

    actual_ctl = mmio_read(IRQ4_CTL_REG_ADDR);

    if (actual_ctl != EXP_IRQ4_CTL_VALUE)
        error_print(4);
    else
        info_print(5);


    /* ============================================================
     * IRQ5
     * ============================================================ */

    actual_ctl = mmio_read(IRQ5_CTL_REG_ADDR);

    if (actual_ctl != EXP_IRQ5_CTL_VALUE)
        error_print(5);
    else
        info_print(6);


    /* ============================================================
     * IRQ6
     * ============================================================ */

    actual_ctl = mmio_read(IRQ6_CTL_REG_ADDR);

    if (actual_ctl != EXP_IRQ6_CTL_VALUE)
        error_print(6);
    else
        info_print(7);


    /* ============================================================
     * IRQ7
     * ============================================================ */

    actual_ctl = mmio_read(IRQ7_CTL_REG_ADDR);

    if (actual_ctl != EXP_IRQ7_CTL_VALUE)
        error_print(7);
    else
        info_print(8);


    /* ============================================================
     * IRQ8
     * ============================================================ */

    actual_ctl = mmio_read(IRQ8_CTL_REG_ADDR);

    if (actual_ctl != EXP_IRQ8_CTL_VALUE)
        error_print(8);
    else
        info_print(9);


    /* ============================================================
     * IRQ9
     *
     * CTL[9] is RO.
     * ============================================================ */

    actual_ctl = mmio_read(IRQ9_CTL_REG_ADDR);

    if (actual_ctl != EXP_IRQ9_CTL_VALUE)
        error_print(9);
    else
        info_print(10);


    /* ============================================================
     * IRQ10
     *
     * CTL[10] is RW.
     *
     * Program legal control/priority value.
     * ============================================================ */

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_VALUE
    );

    actual_ctl = mmio_read(
        IRQ10_CTL_REG_ADDR
    );

    if (actual_ctl != EXP_IRQ10_CTL_VALUE)
        error_print(10);
    else
        info_print(11);


    /* ============================================================
     * IRQ11
     * ============================================================ */

    mmio_write(
        IRQ11_CTL_REG_ADDR,
        EXP_IRQ11_CTL_VALUE
    );

    actual_ctl = mmio_read(
        IRQ11_CTL_REG_ADDR
    );

    if (actual_ctl != EXP_IRQ11_CTL_VALUE)
        error_print(11);
    else
        info_print(12);


    /* ============================================================
     * IRQ12
     * ============================================================ */

    mmio_write(
        IRQ12_CTL_REG_ADDR,
        EXP_IRQ12_CTL_VALUE
    );

    actual_ctl = mmio_read(
        IRQ12_CTL_REG_ADDR
    );

    if (actual_ctl != EXP_IRQ12_CTL_VALUE)
        error_print(12);
    else
        info_print(13);


    /* ============================================================
     * IRQ13
     * ============================================================ */

    mmio_write(
        IRQ13_CTL_REG_ADDR,
        EXP_IRQ13_CTL_VALUE
    );

    actual_ctl = mmio_read(
        IRQ13_CTL_REG_ADDR
    );

    if (actual_ctl != EXP_IRQ13_CTL_VALUE)
        error_print(13);
    else
        info_print(14);


    /* ============================================================
     * IRQ14
     * ============================================================ */

    mmio_write(
        IRQ14_CTL_REG_ADDR,
        EXP_IRQ14_CTL_VALUE
    );

    actual_ctl = mmio_read(
        IRQ14_CTL_REG_ADDR
    );

    if (actual_ctl != EXP_IRQ14_CTL_VALUE)
        error_print(14);
    else
        info_print(15);


    /* ============================================================
     * IRQ15
     * ============================================================ */

    mmio_write(
        IRQ15_CTL_REG_ADDR,
        EXP_IRQ15_CTL_VALUE
    );

    actual_ctl = mmio_read(
        IRQ15_CTL_REG_ADDR
    );

    if (actual_ctl != EXP_IRQ15_CTL_VALUE)
        error_print(15);
    else
        info_print(16);


    /* ============================================================
     * Configuration Complete
     * ============================================================ */

    info_print(0x2222);


    send_handshake_to_sv(1);


    info_print(0x3333);


}
