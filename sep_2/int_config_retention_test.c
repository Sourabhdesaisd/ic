#include "peripheral.h"


/* ============================================================
 * TC049 : ISR Configuration Retention
 *
 * Verify that interrupt configuration is not corrupted by
 * interrupt service.
 *
 * IRQ configuration:
 *
 *     IRQ10:
 *         ENABLE = 1
 *         CTL    = 0x53
 *         Priority = 5
 *
 *     IRQ11:
 *         ENABLE = 1
 *         CTL    = 0xD3
 *         Priority = 13
 *
 *     IRQ12:
 *         ENABLE = 1
 *         CTL    = 0x93
 *         Priority = 9
 *
 *
 * Test flow:
 *
 *     1. Program IRQ10/11/12.
 *     2. Read and save configuration.
 *     3. Generate multiple interrupts.
 *     4. Service IRQ11 -> IRQ12 -> IRQ10.
 *     5. Read configuration again.
 *     6. Compare actual values with the values programmed
 *        before ISR execution.
 *
 *
 * Expected:
 *
 *     ISR execution must not modify:
 *
 *         IRQ enable configuration
 *         IRQ control configuration
 *
 *     unless software intentionally changes them.
 *
 * ============================================================ */


/* ============================================================
 * Expected configuration
 * ============================================================ */

#define EXP_ENABLE_VALUE       0x01U

#define EXP_IRQ10_CTL          0x53U
#define EXP_IRQ11_CTL          0xD3U
#define EXP_IRQ12_CTL          0x93U


/* ============================================================
 * GPIO PINMUX
 * ============================================================ */

#define EXP_GPIO_PINMUX0       150994944U
#define EXP_GPIO_PINMUX1       585U



int main(void)
{
    uint32_t actual_value;
    uint32_t irq10_enable_before;
    uint32_t irq11_enable_before;
    uint32_t irq12_enable_before;
    uint32_t irq10_ctl_before;
    uint32_t irq11_ctl_before;
    uint32_t irq12_ctl_before;


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
     * Keep your required value:
     *
     *     0xFC000000
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
        EXP_GPIO_PINMUX0
    );

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR,
        EXP_GPIO_PINMUX1
    );


    info_print(0x2000);


    /* ============================================================
     * ============================================================
     * IRQ10 CONFIGURATION
     * ============================================================
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_ENABLE_VALUE
    );

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL
    );


    /* ============================================================
     * IRQ11 CONFIGURATION
     * ============================================================ */

    mmio_write(
        IRQ11_ENABLE_REG_ADDR,
        EXP_ENABLE_VALUE
    );

    mmio_write(
        IRQ11_CTL_REG_ADDR,
        EXP_IRQ11_CTL
    );


    /* ============================================================
     * IRQ12 CONFIGURATION
     * ============================================================ */

    mmio_write(
        IRQ12_ENABLE_REG_ADDR,
        EXP_ENABLE_VALUE
    );

    mmio_write(
        IRQ12_CTL_REG_ADDR,
        EXP_IRQ12_CTL
    );


    /* ============================================================
     * READ CONFIGURATION BEFORE ISR
     *
     * Save the configuration that was programmed.
     * ============================================================ */

    irq10_enable_before =
        mmio_read(IRQ10_ENABLE_REG_ADDR);

    irq11_enable_before =
        mmio_read(IRQ11_ENABLE_REG_ADDR);

    irq12_enable_before =
        mmio_read(IRQ12_ENABLE_REG_ADDR);


    irq10_ctl_before =
        mmio_read(IRQ10_CTL_REG_ADDR);

    irq11_ctl_before =
        mmio_read(IRQ11_CTL_REG_ADDR);

    irq12_ctl_before =
        mmio_read(IRQ12_CTL_REG_ADDR);


    /* ============================================================
     * Verify configuration before interrupt service
     * ============================================================ */

    if (irq10_enable_before != EXP_ENABLE_VALUE)
        error_print(10);
    else
        info_print(10);


    if (irq11_enable_before != EXP_ENABLE_VALUE)
        error_print(11);
    else
        info_print(11);


    if (irq12_enable_before != EXP_ENABLE_VALUE)
        error_print(12);
    else
        info_print(12);


    if (irq10_ctl_before != EXP_IRQ10_CTL)
        error_print(13);
    else
        info_print(13);


    if (irq11_ctl_before != EXP_IRQ11_CTL)
        error_print(14);
    else
        info_print(14);


    if (irq12_ctl_before != EXP_IRQ12_CTL)
        error_print(15);
    else
        info_print(15);


    /* ============================================================
     * Configuration Complete
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * Normal Execution Before ISR
     * ============================================================ */

    info_print(0x3000);


   
    send_handshake_to_sv(1);


    info_print(0x3010);


    /* ============================================================
     * ISR SERVICE
     *
     * Expected handler sequence:
     *
     *     0xA011
     *     0xA012
     *     0xA010
     *
     * No interrupt configuration is modified inside the
     * handlers.
     * ============================================================ */

    info_print(0x3020);

	wait_for_handshake_from_sv();
    

    info_print(0x3333);

    /* ============================================================
     * READ CONFIGURATION AFTER ISR
     * ============================================================ */

    actual_value = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );

    if (actual_value != irq10_enable_before)
        error_print(20);
    else
        info_print(20);


    actual_value = mmio_read(
        IRQ11_ENABLE_REG_ADDR
    );

    if (actual_value != irq11_enable_before)
        error_print(21);
    else
        info_print(21);


    actual_value = mmio_read(
        IRQ12_ENABLE_REG_ADDR
    );

    if (actual_value != irq12_enable_before)
        error_print(22);
    else
        info_print(22);


    /* ============================================================
     * Verify CONTROL registers after ISR
     * ============================================================ */

    actual_value = mmio_read(
        IRQ10_CTL_REG_ADDR
    );

    if (actual_value != irq10_ctl_before)
        error_print(23);
    else
        info_print(23);


    actual_value = mmio_read(
        IRQ11_CTL_REG_ADDR
    );

    if (actual_value != irq11_ctl_before)
        error_print(24);
    else
        info_print(24);


    actual_value = mmio_read(
        IRQ12_CTL_REG_ADDR
    );

    if (actual_value != irq12_ctl_before)
        error_print(25);
    else
        info_print(25);


    /* ============================================================
     * Post-ISR Execution
     * ============================================================ */

    info_print(0x3030);


    /*
     * If configuration was retained, all six checks above
     * should pass.
     */


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x3333);

    send_handshake_to_sv(1);
    

    info_print(0x7049);


}
