#include "peripheral.h"


/* ============================================================
 * Expected GPIO PINMUX values
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE     150994944U
#define EXP_GPIO_PINMUX1_VALUE     585U


/* ============================================================
 * Expected IRQ ENABLE value
 * ============================================================ */

#define EXP_IRQ_ENABLE_VALUE       0x00000001U


/* ============================================================
 * Expected IRQ CTL values
 *
 * IRQ10 = Priority 15
 * IRQ11 = Priority 5
 * IRQ12 = Priority 9
 * IRQ13 = Priority 3
 * IRQ14 = Priority 15
 * IRQ15 = Priority 7
 * ============================================================ */

#define EXP_IRQ10_CTL_VALUE        0x000000FFU
#define EXP_IRQ11_CTL_VALUE        0x00000053U
#define EXP_IRQ12_CTL_VALUE        0x00000093U
#define EXP_IRQ13_CTL_VALUE        0x00000033U
#define EXP_IRQ14_CTL_VALUE        0x000000F3U
#define EXP_IRQ15_CTL_VALUE        0x00000073U


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
     * ============================================================ */

    asm volatile (
        "li t0, 0xFC000000\n"
        "csrrs x0, mie, t0\n"
    );


    info_print(0x1111);


    /* ============================================================
     * GPIO PINMUX CONFIGURATION
     * ============================================================ */

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR,
        EXP_GPIO_PINMUX0_VALUE
    );

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR,
        EXP_GPIO_PINMUX1_VALUE
    );


    /* ============================================================
     * Check GPIO PINMUX0
     * ============================================================ */

    actual_value =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR);

    if (actual_value != EXP_GPIO_PINMUX0_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * Check GPIO PINMUX1
     * ============================================================ */

    actual_value =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR);

    if (actual_value != EXP_GPIO_PINMUX1_VALUE)
        error_print(1);
    else
        info_print(2);


    info_print(0x2000);


    /* ============================================================
     * IRQ10 CONFIGURATION
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value =
        mmio_read(IRQ10_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(2);
    else
        info_print(3);


    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_VALUE
    );

    actual_value =
        mmio_read(IRQ10_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ10_CTL_VALUE)
        error_print(3);
    else
        info_print(4);


    /* ============================================================
     * IRQ11 CONFIGURATION
     * ============================================================ */

    mmio_write(
        IRQ11_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value =
        mmio_read(IRQ11_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(4);
    else
        info_print(5);


    mmio_write(
        IRQ11_CTL_REG_ADDR,
        EXP_IRQ11_CTL_VALUE
    );

    actual_value =
        mmio_read(IRQ11_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ11_CTL_VALUE)
        error_print(5);
    else
        info_print(6);


    /* ============================================================
     * IRQ12 CONFIGURATION
     * ============================================================ */

    mmio_write(
        IRQ12_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value =
        mmio_read(IRQ12_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(6);
    else
        info_print(7);


    mmio_write(
        IRQ12_CTL_REG_ADDR,
        EXP_IRQ12_CTL_VALUE
    );

    actual_value =
        mmio_read(IRQ12_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ12_CTL_VALUE)
        error_print(7);
    else
        info_print(8);


    /* ============================================================
     * IRQ13 CONFIGURATION
     * ============================================================ */

    mmio_write(
        IRQ13_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value =
        mmio_read(IRQ13_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(8);
    else
        info_print(9);


    mmio_write(
        IRQ13_CTL_REG_ADDR,
        EXP_IRQ13_CTL_VALUE
    );

    actual_value =
        mmio_read(IRQ13_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ13_CTL_VALUE)
        error_print(9);
    else
        info_print(10);


    /* ============================================================
     * IRQ14 CONFIGURATION
     * ============================================================ */

    mmio_write(
        IRQ14_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value =
        mmio_read(IRQ14_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(10);
    else
        info_print(11);


    mmio_write(
        IRQ14_CTL_REG_ADDR,
        EXP_IRQ14_CTL_VALUE
    );

    actual_value =
        mmio_read(IRQ14_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ14_CTL_VALUE)
        error_print(11);
    else
        info_print(12);


    /* ============================================================
     * IRQ15 CONFIGURATION
     * ============================================================ */

    mmio_write(
        IRQ15_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value =
        mmio_read(IRQ15_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(12);
    else
        info_print(13);


    mmio_write(
        IRQ15_CTL_REG_ADDR,
        EXP_IRQ15_CTL_VALUE
    );

    actual_value =
        mmio_read(IRQ15_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ15_CTL_VALUE)
        error_print(13);
    else
        info_print(14);


    /* ============================================================
     * All interrupt configurations passed
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * Inform SV/UVM
     *
     * At this point all IRQ10–IRQ15 registers have been
     * configured and read-back verified.
     * ============================================================ */

    send_handshake_to_sv(1);


    /* ============================================================
     * Configuration Test PASS
     * ============================================================ */

    info_print(0x900F);


}
