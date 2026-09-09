#include "peripheral.h"


/* ============================================================
 * EOI Correct ID
 *
 * Verify EOI completes service for the acknowledged interrupt.
 *
 * Test:
 *
 *     IRQ10 enabled
 *     IRQ10 priority = 15
 *     SV asserts IRQ10
 *
 * Expected sequence:
 *
 *     IRQ10 pending
 *          |
 *          v
 *     IRQ10 selected
 *          |
 *          v
 *     ACK IRQ10
 *          |
 *          v
 *     EOI IRQ10
 *          |
 *          v
 *     IRQ10 service completed
 *
 * SV/UVM should monitor:
 *
 *     soc_ack_int_id_o
 *     soc_ack_read_valid_en
 *     soc_eoi_valid_i
 *     soc_eoi_id_i
 *     interrupt_request_o
 *     current_int_id_o
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
     * Read IRQ10 ENABLE
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
     * Read IRQ10 CTL
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
     * SV should:
     *
     *     1. Assert ONLY IRQ10.
     *     2. Wait for IRQ10 to become pending.
     *     3. Allow IRQ10 to be selected.
     *
     * Expected:
     *
     *     current_int_id_o = IRQ10_ID
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3000);


    /* ============================================================
     * Interrupt Acceptance / ACK
     *
     * CPU should accept IRQ10.
     *
     * SV should observe:
     *
     *     current_int_id_o      = IRQ10_ID
     *     soc_ack_read_valid_en = 1
     *     soc_ack_int_id_o      = IRQ10_ID
     *
     * ============================================================ */

    info_print(0x3010);


    /* ============================================================
     * EOI Phase
     *
     * After ACK, the acknowledged interrupt is IRQ10.
     *
     * The EOI interface must therefore contain:
     *
     *     soc_eoi_valid_i = 1
     *     soc_eoi_id_i    = IRQ10_ID
     *
     * EOI should complete service of IRQ10.
     *
     * ============================================================ */

    info_print(0x3020);


    /* ============================================================
     * After EOI
     *
     * Expected:
     *
     *     IRQ10 service completed
     *     IRQ10 no longer active
     *     interrupt_request_o deasserts
     *
     * if no other interrupt is pending.
     *
     * ============================================================ */

    info_print(0x3030);


    /*
     * Execution resumes here after the interrupt handler
     * returns with mret.
     */


    info_print(0x3333);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x7035);


}
