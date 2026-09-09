#include "peripheral.h"


/* ============================================================
 * Back-to-Back ISR Entry
 *
 * IRQ11 -> IRQ12 -> IRQ10
 *
 * Priority:
 *
 *     IRQ11 = 13
 *     IRQ12 = 9
 *     IRQ10 = 5
 *
 * Control:
 *
 *     IRQ11 = 0xD3
 *     IRQ12 = 0x93
 *     IRQ10 = 0x53
 *
 * Expected CPU sequence:
 *
 *     IRQ11
 *       |
 *      ISR
 *       |
 *      MRET
 *       |
 *     IRQ12
 *       |
 *      ISR
 *       |
 *      MRET
 *       |
 *     IRQ10
 *       |
 *      ISR
 *       |
 *      MRET
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


    /* ============================================================
     * TEST START
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
     * CTL      = 0x53
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
     * CTL      = 0xD3
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
     * CTL      = 0x93
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
     * PRE-INTERRUPT CHECKPOINT
     * ============================================================ */

    info_print(0x3000);


    /* ============================================================
     * Inform SV
     *
     * SV should assert IRQ10, IRQ11 and IRQ12 such that all
     * three become pending.
     *
     * Expected arbitration:
     *
     *     IRQ11 -> IRQ12 -> IRQ10
     *
     * ============================================================ */

    send_handshake_to_sv(1);


    /* ============================================================
     * Normal execution checkpoint
     * ============================================================ */

    info_print(0x3010);


    /*
     * ============================================================
     * EXPECTED FIRST ISR
     * ============================================================
     *
     * IRQ11
     *
     * Handler marker:
     *
     *     0xA011
     *
     * Service marker:
     *
     *     0xA111
     *
     * Then:
     *
     *     MRET
     *
     * ============================================================
     */


    /*
     * ============================================================
     * EXPECTED SECOND ISR
     * ============================================================
     *
     * Immediately after IRQ11 MRET:
     *
     *     IRQ12 should be accepted.
     *
     * Handler marker:
     *
     *     0xA012
     *
     * Service marker:
     *
     *     0xA112
     *
     * Then:
     *
     *     MRET
     *
     * ============================================================
     */


    /*
     * ============================================================
     * EXPECTED THIRD ISR
     * ============================================================
     *
     * Immediately after IRQ12 MRET:
     *
     *     IRQ10 should be accepted.
     *
     * Handler marker:
     *
     *     0xA010
     *
     * Service marker:
     *
     *     0xA110
     *
     * Then:
     *
     *     MRET
     *
     * ============================================================
     */


    /* ============================================================
     * POST-ISR CHECKPOINT
     * ============================================================ */

    info_print(0x4000);

    info_print(0x4010);


    /* ============================================================
     * TEST COMPLETE
     * ============================================================ */

    info_print(0x3333);

    info_print(0x7050);


}
