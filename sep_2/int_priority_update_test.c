#include "peripheral.h"


/* ============================================================
 *  Priority Update With Pending IRQ
 *
 * Initial configuration:
 *
 *     IRQ10 = Priority 5   -> CTL = 0x53
 *     IRQ12 = Priority 9   -> CTL = 0x93
 *
 * Both IRQ10 and IRQ12 are made pending.
 *
 * Initial arbitration:
 *
 *     IRQ12 (9) > IRQ10 (5)
 *
 * Therefore IRQ12 is selected first.
 *
 *
 * Runtime update:
 *
 *     IRQ10 = Priority 15  -> CTL = 0xF3
 *
 * while IRQ10 and IRQ12 are pending.
 *
 * New arbitration:
 *
 *     IRQ10 (15) > IRQ12 (9)
 *
 * Therefore IRQ10 must become the highest-priority pending IRQ.
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

#define EXP_IRQ_ENABLE_VALUE      0x01U

#define EXP_IRQ10_CTL_INITIAL     0x53U
#define EXP_IRQ12_CTL_INITIAL     0x93U

#define EXP_IRQ10_CTL_UPDATED     0xF3U


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
     * Enable IRQ12
     * ============================================================ */

    mmio_write(
        IRQ12_ENABLE_REG_ADDR,
        EXP_IRQ_ENABLE_VALUE
    );


    actual_value = mmio_read(
        IRQ12_ENABLE_REG_ADDR
    );


    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(1);
    else
        info_print(2);


    /* ============================================================
     * Configure IRQ10
     *
     * Initial priority = 5
     *
     * CTL = 0x53
     * ============================================================ */

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_INITIAL
    );


    actual_value = mmio_read(
        IRQ10_CTL_REG_ADDR
    );


    if (actual_value != EXP_IRQ10_CTL_INITIAL)
        error_print(2);
    else
        info_print(3);


    /* ============================================================
     * Configure IRQ12
     *
     * Initial priority = 9
     *
     * CTL = 0x93
     * ============================================================ */

    mmio_write(
        IRQ12_CTL_REG_ADDR,
        EXP_IRQ12_CTL_INITIAL
    );


    actual_value = mmio_read(
        IRQ12_CTL_REG_ADDR
    );


    if (actual_value != EXP_IRQ12_CTL_INITIAL)
        error_print(3);
    else
        info_print(4);


    /* ============================================================
     * Initial configuration complete
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * Inform SV
     *
     * SV should:
     *
     *     1. Assert IRQ10.
     *     2. Assert IRQ12.
     *     3. Keep both interrupts pending.
     *
     * Initial priorities:
     *
     *     IRQ10 = 5
     *     IRQ12 = 9
     *
     * Expected:
     *
     *     IRQ12 selected
     *
     * because:
     *
     *     9 > 5
     *
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3000);


    /* ============================================================
     * Initial Arbitration
     *
     * SV/UVM should check:
     *
     *     pending IRQ10 = 1
     *     pending IRQ12 = 1
     *
     *     IRQ12 priority = 9
     *     IRQ10 priority = 5
     *
     * Expected selected interrupt:
     *
     *     IRQ12
     *
     * ============================================================ */

    info_print(0x3012);

	wait_for_handshake_from_sv(1);

    /*
     * ============================================================
     * Runtime Priority Update
     *
     * IRQ10 is already pending.
     *
     * Change IRQ10 priority:
     *
     *     5 -> 15
     *
     * CTL:
     *
     *     0x53 -> 0xF3
     *
     * IRQ12 remains pending with priority 9.
     * ============================================================ */

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_UPDATED
    );


    /* ============================================================
     * Read Updated IRQ10 CTL
     * ============================================================ */

    actual_value = mmio_read(
        IRQ10_CTL_REG_ADDR
    );


    if (actual_value != EXP_IRQ10_CTL_UPDATED)
        error_print(4);
    else
        info_print(5);


    /* ============================================================
     * Updated Arbitration
     *
     * New priorities:
     *
     *     IRQ10 = 15
     *     IRQ12 = 9
     *
     * Both are still pending.
     *
     * Expected:
     *
     *     IRQ10 selected
     *
     * because:
     *
     *     15 > 9
     * ============================================================ */

    info_print(0x3020);

    send_handshake_to_sv(2);

    /*
     * SV/UVM should now check:
     *
     *     pending[10]       = 1
     *     pending[12]       = 1
     *
     *     IRQ10 priority    = 15
     *     IRQ12 priority    = 9
     *
     * Expected:
     *
     *     current_int_id_o  = IRQ10
     *     interrupt_request_o = 1
     *
     * ============================================================
     */


    /* ============================================================
     * Test Complete
     *
     * Do not generate another interrupt from C.
     *
     * SV controls the pending sources and arbitration checks.
     * ============================================================ */

    info_print(0x3031);



}
