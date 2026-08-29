#include "peripheral.h"

/* ============================================================
 * Expected Values
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE    150994944U
#define EXP_GPIO_PINMUX1_VALUE    585U

#define EXP_IRQ12_ENABLE_VALUE    0x00000001U
#define EXP_IRQ12_ATTR_VALUE      0x00000000U
#define EXP_IRQ12_CTL_VALUE       0x000000D6U


int main(void)
{
    uint32_t actual_pinmux0;
    uint32_t actual_pinmux1;

    uint32_t actual_irq12_enable;
    uint32_t actual_irq12_attr;
    uint32_t actual_irq12_ctl;


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
     *
     * GPIO PINMUX0 = 150994944
     * GPIO PINMUX1 = 585
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
     * Self Check GPIO PINMUX0
     * ============================================================ */

    actual_pinmux0 =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR);

    if (actual_pinmux0 != EXP_GPIO_PINMUX0_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * Self Check GPIO PINMUX1
     * ============================================================ */

    actual_pinmux1 =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR);

    if (actual_pinmux1 != EXP_GPIO_PINMUX1_VALUE)
        error_print(1);
    else
        info_print(2);


    info_print(0x2000);


    /* ============================================================
     * Enable IRQ12
     * ============================================================ */

    mmio_write(
        IRQ12_ENABLE_REG_ADDR,
        EXP_IRQ12_ENABLE_VALUE
    );


    /* Read back IRQ12 ENABLE register */

    actual_irq12_enable =
        mmio_read(IRQ12_ENABLE_REG_ADDR);

    if (actual_irq12_enable != EXP_IRQ12_ENABLE_VALUE)
        error_print(2);
    else
        info_print(3);



    /* ============================================================
     * Program IRQ12 Control
     * ============================================================ */

    mmio_write(
        IRQ12_CTL_REG_ADDR,
        EXP_IRQ12_CTL_VALUE
    );


    /* Read back IRQ12 CONTROL register */

    actual_irq12_ctl =
        mmio_read(IRQ12_CTL_REG_ADDR);

    if (actual_irq12_ctl != EXP_IRQ12_CTL_VALUE)
        error_print(4);
    else
        info_print(5);


    /* ============================================================
     * All Configuration Self Checks Passed
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * Inform SV/UVM
     *
     * After this handshake, SV/UVM should generate the GPIO
     * interrupt corresponding to IRQ12.
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3333);


}
