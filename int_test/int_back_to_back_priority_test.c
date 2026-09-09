#include "peripheral.h"


/* ============================================================
 *  Back-to-Back Priority Service
 *
 * Three interrupts are enabled and asserted by SV:
 *
 *     IRQ10 = Priority 5
 *     IRQ11 = Priority 13
 *     IRQ12 = Priority 9
 *
 * Expected service order:
 *
 *     IRQ11 -> IRQ12 -> IRQ10
 *
 * because:
 *
 *     13 > 9 > 5
 *
 * After ACK/EOI of the current interrupt, the next highest
 * pending interrupt must be selected immediately.
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

#define EXP_IRQ_ENABLE_VALUE      0x01U

#define EXP_IRQ10_CTL_VALUE       0x53U
#define EXP_IRQ11_CTL_VALUE       0xD3U
#define EXP_IRQ12_CTL_VALUE       0x93U


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
     * Keep existing configuration:
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
     * Priority = 5
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
     * Enable IRQ12
     *
     * Priority = 9
     * ============================================================ */

    mmio_write(
        IRQ12_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );

    actual_value = mmio_read(
        IRQ12_ENABLE_REG_ADDR
    );

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(4);
    else
        info_print(5);


    mmio_write(
        IRQ12_CTL_REG_ADDR,
        EXP_IRQ12_CTL_VALUE
    );

    actual_value = mmio_read(
        IRQ12_CTL_REG_ADDR
    );

    if (actual_value != EXP_IRQ12_CTL_VALUE)
        error_print(5);
    else
        info_print(6);


    /* ============================================================
     * Configuration Complete
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * Inform SV
     *
     * SV should assert:
     *
     *     IRQ10 = 1
     *     IRQ11 = 1
     *     IRQ12 = 1
     *
     * Keep all three pending.
     *
     * Expected initial arbitration:
     *
     *     IRQ11
     *
     * because:
     *
     *     IRQ11 priority = 13
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3000);


    /* ============================================================
     * FIRST SERVICE
     *
     * Expected:
     *
     *     current_int_id_o = IRQ11
     *     interrupt_request_o = 1
     *     IRQ11 handler entered
     *
     * IRQ10 and IRQ12 remain pending.
     *
     * IRQ11 handler performs ACK/EOI.
     * ============================================================ */

    info_print(0x3011);


    /*
     * ------------------------------------------------------------
     * After IRQ11 ACK/EOI:
     *
     * IRQ11 should no longer be the active interrupt.
     *
     * Remaining pending interrupts:
     *
     *     IRQ10 = priority 5
     *     IRQ12 = priority 9
     *
     * Therefore IRQ12 must be selected next.
     * ------------------------------------------------------------
     */

    info_print(0x3022);


    /* ============================================================
     * SECOND SERVICE
     *
     * Expected:
     *
     *     current_int_id_o = IRQ12
     *     interrupt_request_o = 1
     *     IRQ12 handler entered
     *
     * IRQ10 remains pending.
     *
     * IRQ12 handler performs ACK/EOI.
     * ============================================================ */

    info_print(0x3033);


    /*
     * ------------------------------------------------------------
     * After IRQ12 ACK/EOI:
     *
     * Remaining pending interrupt:
     *
     *     IRQ10 = priority 5
     *
     * Therefore IRQ10 must be selected immediately.
     * ------------------------------------------------------------
     */

    info_print(0x3044);


    /* ============================================================
     * THIRD SERVICE
     *
     * Expected:
     *
     *     current_int_id_o = IRQ10
     *     interrupt_request_o = 1
     *     IRQ10 handler entered
     *
     * IRQ10 handler performs ACK/EOI.
     * ============================================================ */

    info_print(0x3055);


   
 


    info_print(0x3333);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x7033);


}
