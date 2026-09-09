 #include "peripheral.h"

/* ============================================================
 * Expected Values
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE    150994944U
#define EXP_GPIO_PINMUX1_VALUE    585U

#define EXP_IRQ10_ENABLE_VALUE    0x00000001U
#define EXP_IRQ10_ATTR_VALUE      0x00000000U
#define EXP_IRQ10_CTL_VALUE       0x000000D3U


int main(void)
{
    uint32_t actual_pinmux0;
    uint32_t actual_pinmux1;

    uint32_t actual_irq10_enable;
    uint32_t actual_irq10_attr;
    uint32_t actual_irq10_ctl;


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
     * Keeping your existing configuration.
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
     * Read Back GPIO PINMUX0
     * ============================================================ */

    actual_pinmux0 =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR);


    if (actual_pinmux0 != EXP_GPIO_PINMUX0_VALUE)
    {
        error_print(0);
    }
    else
    {
        info_print(0x1001);
    }


    /* ============================================================
     * Read Back GPIO PINMUX1
     * ============================================================ */

    actual_pinmux1 =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR);


    if (actual_pinmux1 != EXP_GPIO_PINMUX1_VALUE)
    {
        error_print(1);
    }
    else
    {
        info_print(0x1002);
    }


    info_print(0x2000);


    /* ============================================================
     * Configure IRQ10
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_IRQ10_ENABLE_VALUE
    );



    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_VALUE
    );


    /* ============================================================
     * Read Back IRQ10 ENABLE Register
     * ============================================================ */

    actual_irq10_enable =
        mmio_read(IRQ10_ENABLE_REG_ADDR);


    if (actual_irq10_enable != EXP_IRQ10_ENABLE_VALUE)
    {
        error_print(2);
    }
    else
    {
        info_print(0x2001);
    }




    /* ============================================================
     * Read Back IRQ10 CONTROL Register
     * ============================================================ */

    actual_irq10_ctl =
        mmio_read(IRQ10_CTL_REG_ADDR);


    if (actual_irq10_ctl != EXP_IRQ10_CTL_VALUE)
    {
        error_print(4);
    }
    else
    {
        info_print(0x2003);
    }


    /* ============================================================
     * Configuration Complete
     *
     * At this point:
     *
     * GPIO PINMUX configured
     * IRQ10 enabled
     * IRQ10 attributes configured
     * IRQ10 control configured
     * CPU interrupts enabled
     *
     * Now inform SV/UVM to generate GPIO interrupt.
     * ============================================================ */

    info_print(0x2222);

    send_handshake_to_sv(1);


    /* ============================================================
     * Waiting point
     *
     * After handshake, SV/UVM generates IRQ10.
     *
     * Expected execution flow:
     *
     * main()
     *   |
     *   | send_handshake_to_sv(1)
     *   |
     *   v
     * SV/UVM generates GPIO interrupt
     *   |
     *   v
     * GPIO -> Interrupt Controller
     *   |
     *   v
     * CPU interrupt request
     *   |
     *   v
     * irq10_handler()
     *
     * Handler prints:
     *
     *     0xA010
     * ============================================================ */

    info_print(0x3333);


    /*
     * Do not use:
     *
     * extern volatile uint32_t irq10_handler_seen;
     *
     * in this version.
     *
     * Handler entry is checked using info_print(0xA010).
     */

}
