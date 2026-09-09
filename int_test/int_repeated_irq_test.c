#include "peripheral.h"


/* ============================================================
 *  Repeated ISR
 *
 * Verify that the same interrupt source can invoke its ISR
 * repeatedly.
 *
 * IRQ:
 *
 *     IRQ10
 *
 * Priority:
 *
 *     5
 *
 * CTL:
 *
 *     0x53
 *
 * Test:
 *
 *     Event 1 -> IRQ10 ISR -> EOI -> MRET
 *     Event 2 -> IRQ10 ISR -> EOI -> MRET
 *     Event 3 -> IRQ10 ISR -> EOI -> MRET
 *
 * Expected:
 *
 *     Exactly one ISR entry for each valid IRQ10 event.
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

#define EXP_IRQ10_ENABLE_VALUE     0x01U
#define EXP_IRQ10_CTL_VALUE        0x53U

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


    actual_value = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );


    if (actual_value != EXP_IRQ10_ENABLE_VALUE)
        error_print(10);
    else
        info_print(10);


    /* ============================================================
     * Configure IRQ10
     *
     * Priority = 5
     * CTL      = 0x53
     * ============================================================ */

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_VALUE
    );


    actual_value = mmio_read(
        IRQ10_CTL_REG_ADDR
    );


    if (actual_value != EXP_IRQ10_CTL_VALUE)
        error_print(11);
    else
        info_print(11);


    /* ============================================================
     * Configuration Complete
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * EVENT 1 : Prepare
     * ============================================================ */

    info_print(0x3001);


    /*
     * Inform SV that Event 1 can be generated.
     *
     * SV:
     *
     *     assert IRQ10
     *     wait for ISR
     *     clear/deassert IRQ10
     */

    send_handshake_to_sv(1);


    /* ============================================================
     * EVENT 1 : Normal Execution After ISR
     * ============================================================ */

    info_print(0x3011);


    /*
     * At this point expected ISR sequence was:
     *
     *     0xA010
     *     0xA011
     *
     * exactly once.
     */


    /* ============================================================
     * EVENT 2 : Prepare
     * ============================================================ */

   

    /*
     * second IRQ10 event.
     */

   

    /* ============================================================
     * EVENT 2 : Normal Execution After ISR
     * ============================================================ */

   

    /*
     * Expected:
     *
     *     Second 0xA010
     *     Second 0xA011
     *
     * exactly once.
     */


    /* ============================================================
     * EVENT 3 : Prepare
     * ============================================================ */

   

    /*
     * generate the third IRQ10 event.
     */



    /* ============================================================
     * EVENT 3 : Normal Execution After ISR
     * ============================================================ */

    info_print(0x3013);


    /*
     * Expected:
     *
     *     Third 0xA010
     *     Third 0xA011
     *
     * exactly once.
     */


    /* ============================================================
     * Final Checkpoint
     * ============================================================ */

    info_print(0x4000);



    info_print(0x7050);


}
