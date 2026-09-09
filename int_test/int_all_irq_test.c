#include "peripheral.h"


/* ============================================================
 * All 16 IRQ Individual Mapping
 *
 * Purpose:
 *
 * Verify one-to-one mapping:
 *
 *     Source
 *       |
 *       v
 *     IRQ[n]
 *       |
 *       v
 *     Pending[n]
 *       |
 *       v
 *     Interrupt ID
 *       |
 *       v
 *     CPU interrupt
 *       |
 *       v
 *     Correct handler
 *
 *
 * SV must generate IRQ0 -> IRQ15 one at a time.
 *
 * For every IRQ:
 *
 *     1. Assert one source only
 *     2. Check pending
 *     3. Check interrupt ID
 *     4. Check interrupt request
 *     5. Check correct handler entry
 *     6. Check no adjacent IRQ is selected
 *     7. Complete interrupt
 *
 * ============================================================ */


/* ============================================================
 * GPIO configuration
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE      150994944U
#define EXP_GPIO_PINMUX1_VALUE      585U


/* ============================================================
 * IRQ configuration
 *
 * All IRQs enabled.
 * ============================================================ */

#define EXP_IRQ_ENABLE_VALUE        0x01U

#define EXP_IRQ_ATTR_VALUE          0x00U

/* ============================================================
 * IRQ10-IRQ15 control values
 *
 * Different priority values
 *
 * IRQ10 -> Priority 1
 * IRQ11 -> Priority 5
 * IRQ12 -> Priority 9
 * IRQ13 -> Priority 3
 * IRQ14 -> Priority 15
 * IRQ15 -> Priority 7
 *
 * ============================================================ */

#define EXP_IRQ10_CTL_VALUE        0x13U
#define EXP_IRQ11_CTL_VALUE        0x53U
#define EXP_IRQ12_CTL_VALUE        0x93U
#define EXP_IRQ13_CTL_VALUE        0x33U
#define EXP_IRQ14_CTL_VALUE        0xF3U
#define EXP_IRQ15_CTL_VALUE        0x73U
/* ============================================================
 * Test Start
 * ============================================================ */

int main(void)
{
    uint32_t actual_value;


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
        EXP_GPIO_PINMUX0_VALUE
    );

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR,
        EXP_GPIO_PINMUX1_VALUE
    );


    info_print(0x2000);


    /* ============================================================
     * IRQ0
     * ============================================================ */

    mmio_write(
        IRQ0_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ0_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * IRQ1
     * ============================================================ */

    mmio_write(
        IRQ1_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ1_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(1);
    else
        info_print(2);


    /* ============================================================
     * IRQ2
     * ============================================================ */

    mmio_write(
        IRQ2_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ2_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(2);
    else
        info_print(3);


    /* ============================================================
     * IRQ3
     * ============================================================ */

    mmio_write(
        IRQ3_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ3_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(3);
    else
        info_print(4);


    /* ============================================================
     * IRQ4
     * ============================================================ */

    mmio_write(
        IRQ4_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ4_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(4);
    else
        info_print(5);


    /* ============================================================
     * IRQ5
     * ============================================================ */

    mmio_write(
        IRQ5_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ5_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(5);
    else
        info_print(6);


    /* ============================================================
     * IRQ6
     * ============================================================ */

    mmio_write(
        IRQ6_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ6_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(6);
    else
        info_print(7);


    /* ============================================================
     * IRQ7
     * ============================================================ */

    mmio_write(
        IRQ7_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ7_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(7);
    else
        info_print(8);


    /* ============================================================
     * IRQ8
     * ============================================================ */

    mmio_write(
        IRQ8_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ8_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(8);
    else
        info_print(9);


    /* ============================================================
     * IRQ9
     * ============================================================ */

    mmio_write(
        IRQ9_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ9_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(9);
    else
        info_print(10);


     /* ============================================================
     * IRQ10
     *
     * Enable IRQ10.
     *
     * CTL10 = 0x13
     * Priority = 1
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(10);
    else
        info_print(10);


    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_VALUE
    );

    actual_value = mmio_read(
        IRQ10_CTL_REG_ADDR
    );

    if (actual_value != EXP_IRQ10_CTL_VALUE)
        error_print(11);
    else
        info_print(11);


    /* ============================================================
     * IRQ11
     *
     * CTL11 = 0x53
     * Priority = 5
     * ============================================================ */

    mmio_write(
        IRQ11_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ11_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(12);
    else
        info_print(12);


    mmio_write(
        IRQ11_CTL_REG_ADDR,
        EXP_IRQ11_CTL_VALUE
    );

    actual_value = mmio_read(
        IRQ11_CTL_REG_ADDR
    );

    if (actual_value != EXP_IRQ11_CTL_VALUE)
        error_print(13);
    else
        info_print(13);


    /* ============================================================
     * IRQ12
     *
     * CTL12 = 0x93
     * Priority = 9
     * ============================================================ */

    mmio_write(
        IRQ12_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ12_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(14);
    else
        info_print(14);


    mmio_write(
        IRQ12_CTL_REG_ADDR,
        EXP_IRQ12_CTL_VALUE
    );

    actual_value = mmio_read(
        IRQ12_CTL_REG_ADDR
    );

    if (actual_value != EXP_IRQ12_CTL_VALUE)
        error_print(15);
    else
        info_print(15);


    /* ============================================================
     * IRQ13
     *
     * CTL13 = 0x33
     * Priority = 3
     * ============================================================ */

    mmio_write(
        IRQ13_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ13_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(16);
    else
        info_print(16);


    mmio_write(
        IRQ13_CTL_REG_ADDR,
        EXP_IRQ13_CTL_VALUE
    );

    actual_value = mmio_read(
        IRQ13_CTL_REG_ADDR
    );

    if (actual_value != EXP_IRQ13_CTL_VALUE)
        error_print(17);
    else
        info_print(17);


    /* ============================================================
     * IRQ14
     *
     * CTL14 = 0xF3
     * Priority = 15
     * ============================================================ */

    mmio_write(
        IRQ14_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ14_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(18);
    else
        info_print(18);


    mmio_write(
        IRQ14_CTL_REG_ADDR,
        EXP_IRQ14_CTL_VALUE
    );

    actual_value = mmio_read(
        IRQ14_CTL_REG_ADDR
    );

    if (actual_value != EXP_IRQ14_CTL_VALUE)
        error_print(19);
    else
        info_print(19);


    /* ============================================================
     * IRQ15
     *
     * CTL15 = 0x73
     * Priority = 7
     * ============================================================ */

    mmio_write(
        IRQ15_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ15_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(20);
    else
        info_print(20);


    mmio_write(
        IRQ15_CTL_REG_ADDR,
        EXP_IRQ15_CTL_VALUE
    );

    actual_value = mmio_read(
        IRQ15_CTL_REG_ADDR
    );

    if (actual_value != EXP_IRQ15_CTL_VALUE)
        error_print(21);
    else
        info_print(21);


    /* ============================================================
     * Configuration Complete
     * ============================================================ */

    info_print(0x2222);


    

    send_handshake_to_sv(1);


    info_print(0x3333);


}
