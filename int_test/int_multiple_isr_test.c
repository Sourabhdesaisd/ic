#include "peripheral.h"


/* ============================================================
 * TC048 : Multiple ISR Service Order
 *
 * Verify that CPU executes multiple pending ISRs in the same
 * order selected by the interrupt controller arbitration logic.
 *
 * IRQ configuration:
 *
 *     IRQ10 = Priority 5
 *     IRQ11 = Priority 13
 *     IRQ12 = Priority 9
 *
 * Expected service order:
 *
 *     IRQ11 -> IRQ12 -> IRQ10
 *
 * ============================================================ */


/* ============================================================
 * Expected values
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
     * GPIO PINMUX CONFIGURATION
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
     * IRQ10 CONFIGURATION
     *
     * Priority = 5
     * CTL = 0x53
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_ENABLE_VALUE)
        error_print(10);
    else
        info_print(10);


    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL
    );

    actual_value = mmio_read(
        IRQ10_CTL_REG_ADDR
    );

    if (actual_value != EXP_IRQ10_CTL)
        error_print(11);
    else
        info_print(11);


    /* ============================================================
     * IRQ11 CONFIGURATION
     *
     * Priority = 13
     * CTL = 0xD3
     * ============================================================ */

    mmio_write(
        IRQ11_ENABLE_REG_ADDR,
        EXP_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ11_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_ENABLE_VALUE)
        error_print(12);
    else
        info_print(12);


    mmio_write(
        IRQ11_CTL_REG_ADDR,
        EXP_IRQ11_CTL
    );

    actual_value = mmio_read(
        IRQ11_CTL_REG_ADDR
    );

    if (actual_value != EXP_IRQ11_CTL)
        error_print(13);
    else
        info_print(13);


    /* ============================================================
     * IRQ12 CONFIGURATION
     *
     * Priority = 9
     * CTL = 0x93
     * ============================================================ */

    mmio_write(
        IRQ12_ENABLE_REG_ADDR,
        EXP_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ12_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_ENABLE_VALUE)
        error_print(14);
    else
        info_print(14);


    mmio_write(
        IRQ12_CTL_REG_ADDR,
        EXP_IRQ12_CTL
    );

    actual_value = mmio_read(
        IRQ12_CTL_REG_ADDR
    );

    if (actual_value != EXP_IRQ12_CTL)
        error_print(15);
    else
        info_print(15);


    /* ============================================================
     * Configuration Complete
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * Normal CPU Execution
     * ============================================================ */

    info_print(0x3000);


    /* ============================================================
     * Inform SV
     *
     * SV should assert ALL THREE interrupts:
     *
     *     IRQ10
     *     IRQ11
     *     IRQ12
     *
     * at approximately the same time / before arbitration.
     *
     * Expected:
     *
     *     pending[10] = 1
     *     pending[11] = 1
     *     pending[12] = 1
     *
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3010);




    /*
     * ========================================================
     * Expected first interrupt:
     *
     *     IRQ11
     *
     * because:
     *
     *     IRQ11 priority = 13
     *     IRQ12 priority = 9
     *     IRQ10 priority = 5
     *
     * Expected handler marker:
     *
     *     0xA011
     * ========================================================
     */


    info_print(0x3020);


    /*
     * ========================================================
     * After IRQ11 completion:
     *
     * Remaining:
     *
     *     IRQ12 = priority 9
     *     IRQ10 = priority 5
     *
     * Expected next handler:
     *
     *     IRQ12
     *
     * Expected marker:
     *
     *     0xA012
     * ========================================================
     */


    info_print(0x3030);


    /*
     * ========================================================
     * After IRQ12 completion:
     *
     * Remaining:
     *
     *     IRQ10 = priority 5
     *
     * Expected next handler:
     *
     *     IRQ10
     *
     * Expected marker:
     *
     *     0xA010
     * ========================================================
     */


    info_print(0x3040);


    /*
     * ========================================================
     * After IRQ10 completion:
     *
     * No interrupt should remain pending, assuming SV
     * deasserts the sources.
     *
     * interrupt_request_o should become 0.
     * ========================================================
     */


    info_print(0x3050);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x3333);

    info_print(0x7048);

    send_handshake_to_sv(1);
}
