#include "peripheral.h"


/* ============================================================
 *  ACK Correct ID
 *
 * Verify that ACK returns the interrupt ID that was actually
 * selected by the interrupt controller.
 *
 * Test:
 *
 *     IRQ10 enabled
 *     IRQ10 priority = 15
 *     IRQ10 asserted by SV
 *
 * Expected:
 *
 *     current_int_id_o       = IRQ10_ID
 *     soc_ack_int_id_o       = IRQ10_ID
 *     soc_ack_read_valid_en  = 1
 *
 * Therefore:
 *
 *     ACK ID == Selected Interrupt ID
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

#define EXP_IRQ10_ENABLE_VALUE     0x01U

/*
 * IRQ10 priority = 15
 *
 * CTL = 0xF3
 */
#define EXP_IRQ10_CTL_VALUE        0xF3U


/* ============================================================
 * GPIO PINMUX
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE     150994944U
#define EXP_GPIO_PINMUX1_VALUE     585U


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
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_IRQ10_ENABLE_VALUE
    );


    /* ============================================================
     * Read IRQ10 Enable
     * ============================================================ */

    actual_value = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );


    if (actual_value != EXP_IRQ10_ENABLE_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * Configure IRQ10
     *
     * Priority = 15
     * CTL      = 0xF3
     * ============================================================ */

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_VALUE
    );


    /* ============================================================
     * Read IRQ10 Control
     * ============================================================ */

    actual_value = mmio_read(
        IRQ10_CTL_REG_ADDR
    );


    if (actual_value != EXP_IRQ10_CTL_VALUE)
        error_print(1);
    else
        info_print(2);


    /* ============================================================
     * Configuration Complete
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * Inform SV
     *
     * SV should assert ONLY IRQ10.
     *
     * Expected:
     *
     *     IRQ10 becomes pending
     *     IRQ10 wins arbitration
     *     current_int_id_o = IRQ10_ID
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3000);


    /* ============================================================
     * Interrupt Acceptance
     *
     * CPU should receive the external interrupt and enter
     * irq10_handler().
     *
     * At interrupt acceptance:
     *
     *     current_int_id_o = IRQ10_ID
     *
     * ACK should correspond to the same ID.
     * ============================================================ */

    info_print(0x3010);


    /*
     * ============================================================
     * ACK CHECK
     *
     * The actual ACK signaling is expected to be observed
     * by the SV/UVM environment:
     *
     *     soc_ack_read_valid_en = 1
     *
     *     soc_ack_int_id_o = IRQ10_ID
     *
     *     current_int_id_o = IRQ10_ID
     *
     * Expected:
     *
     *     soc_ack_int_id_o == current_int_id_o
     *
     * ============================================================
     */

    info_print(0x3020);


    /*
     * Execution returns here after the IRQ10 handler executes
     * mret, if the handler is responsible for the return.
     */


    info_print(0x3333);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x7034);


}
