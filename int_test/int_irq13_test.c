#include "peripheral.h"

/* ============================================================
 * Expected Values
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE    150994944U
#define EXP_GPIO_PINMUX1_VALUE    585U

#define EXP_IRQ13_ENABLE_VALUE    0x00000001U
#define EXP_IRQ13_ATTR_VALUE      0x00000000U
#define EXP_IRQ13_CTL_VALUE       0x000000D8U


int main(void)
{
    uint32_t actual_pinmux0;
    uint32_t actual_pinmux1;

    uint32_t actual_irq13_enable;
    uint32_t actual_irq13_attr;
    uint32_t actual_irq13_ctl;


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
     * GPIO PINMUX Configuration
     *
     * PINMUX0 = 150994944
     * PINMUX1 = 585
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
     * Self Check : GPIO PINMUX0
     * ============================================================ */

    actual_pinmux0 =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR);

    if (actual_pinmux0 != EXP_GPIO_PINMUX0_VALUE)
    {
        error_print(0);
    }
    else
    {
        info_print(1);
    }


    /* ============================================================
     * Self Check : GPIO PINMUX1
     * ============================================================ */

    actual_pinmux1 =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR);

    if (actual_pinmux1 != EXP_GPIO_PINMUX1_VALUE)
    {
        error_print(1);
    }
    else
    {
        info_print(2);
    }


    info_print(0x2000);


    /* ============================================================
     * Enable IRQ13
     * ============================================================ */

    mmio_write(
        IRQ13_ENABLE_REG_ADDR,
        EXP_IRQ13_ENABLE_VALUE
    );


    /* ============================================================
     * Self Check : IRQ13 Enable Register
     * ============================================================ */

    actual_irq13_enable =
        mmio_read(IRQ13_ENABLE_REG_ADDR);

    if (actual_irq13_enable != EXP_IRQ13_ENABLE_VALUE)
    {
        error_print(2);
    }
    else
    {
        info_print(3);
    }


   

    /* ============================================================
     * Program IRQ13 Control
     * ============================================================ */

    mmio_write(
        IRQ13_CTL_REG_ADDR,
        EXP_IRQ13_CTL_VALUE
    );


    /* ============================================================
     * Self Check : IRQ13 Control Register
     * ============================================================ */

    actual_irq13_ctl =
        mmio_read(IRQ13_CTL_REG_ADDR);

    if (actual_irq13_ctl != EXP_IRQ13_CTL_VALUE)
    {
        error_print(4);
    }
    else
    {
        info_print(5);
    }


    /* ============================================================
     * All Configuration Checks Passed
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * Inform SV/UVM
     *
     * After this handshake, SV can generate the GPIO interrupt
     * corresponding to IRQ13.
     * ============================================================ */

    send_handshake_to_sv(1);


    /* ============================================================
     * Configuration Complete
     * ============================================================ */

    info_print(0x3333);


    return 0;
}
