#include "peripheral.h"


/* ============================================================
 * Wrong EOI ID
 *
 * Verify that an incorrect EOI ID does not incorrectly clear
 * another interrupt.
 *
 * Test configuration:
 *
 *     IRQ10 = Priority 15
 *     IRQ11 = Priority 13
 *
 * Both IRQ10 and IRQ11 are enabled.
 *
 * SV generates both interrupts.
 *
 * Expected initial arbitration:
 *
 *     IRQ10 selected
 *     because 15 > 13
 *
 * IRQ10 becomes the current/acknowledged interrupt.
 *
 * Then an incorrect EOI is issued using IRQ11 ID.
 *
 * Expected:
 *
 *     EOI ID = IRQ11
 *     Current ID = IRQ10
 *
 * Therefore the EOI must NOT complete IRQ10.
 *
 * IRQ10 must remain active/current according to the
 * implementation.
 *
 * IRQ11 must not be incorrectly cleared by the wrong EOI.
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

#define EXP_IRQ_ENABLE_VALUE      0x01U

#define EXP_IRQ10_CTL_VALUE       0xF3U
#define EXP_IRQ11_CTL_VALUE       0xD3U


/* ============================================================
 * GPIO PINMUX
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE    150994944U
#define EXP_GPIO_PINMUX1_VALUE    585U


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
     * Enable IRQ10
     *
     * Priority = 15
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );


    actual_value = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );


    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * Configure IRQ10
     *
     * Priority = 15
     * CTL = 0xF3
     * ============================================================ */

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
     * Enable IRQ11
     *
     * Priority = 13
     * ============================================================ */

    mmio_write(
        IRQ11_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );


    actual_value = mmio_read(
        IRQ11_ENABLE_REG_ADDR
    );


    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(2);
    else
        info_print(3);


    /* ============================================================
     * Configure IRQ11
     *
     * Priority = 13
     * CTL = 0xD3
     * ============================================================ */

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
     * SV should assert BOTH:
     *
     *     IRQ10
     *     IRQ11
     *
     * Both interrupts must remain pending.
     *
     * Expected arbitration:
     *
     *     IRQ10 priority = 15
     *     IRQ11 priority = 13
     *
     * Therefore:
     *
     *     IRQ10 selected
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3000);


    /* ============================================================
     * IRQ10 CURRENT / ACKNOWLEDGED
     *
     * Expected:
     *
     *     current_int_id_o = IRQ10_ID
     *
     *     ACK ID           = IRQ10_ID
     *
     * IRQ11 remains pending.
     * ============================================================ */

    info_print(0x3010);


    /* ============================================================
     * WRONG EOI
     *
     * Current interrupt:
     *
     *     IRQ10
     *
     * Incorrect EOI:
     *
     *     IRQ11
     *
     * The EOI ID does NOT match the current interrupt.
     *
     
     *
     * ============================================================ */

    info_print(0x3020);


    /*
     * ------------------------------------------------------------
     * Expected after WRONG EOI:
     *
     *     IRQ10 must NOT be completed by the IRQ11 EOI.
     *
     *     IRQ11 must NOT be incorrectly cleared.
     *
     *     No stale/incorrect state transition should occur.
     *
     * Exact current/request behavior depends on the IC RTL
     * specification.
     * ------------------------------------------------------------
     */

    info_print(0x3030);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x7036);


}
