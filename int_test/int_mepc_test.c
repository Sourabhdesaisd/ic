#include "peripheral.h"


/* ============================================================
 *  Interrupt MEPC Capture
 *
 * Verify that MEPC contains the architecturally expected
 * interrupted/resume PC when an external interrupt is taken.
 *
 * IRQ used:
 *
 *     IRQ10
 *
 * Priority:
 *
 *     15
 *
 * CTL:
 *
 *     0xF3
 *
 * Test flow:
 *
 *     main()
 *       |
 *       | controlled execution point
 *       |
 *       +----> SV asserts IRQ10
 *                   |
 *                   v
 *              CPU interrupt entry
 *                   |
 *                   v
 *                 MEPC
 *                   |
 *                   v
 *             irq10_handler()
 *                   |
 *                   v
 *              read MEPC
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

#define EXP_IRQ10_ENABLE_VALUE     0x01U
#define EXP_IRQ10_CTL_VALUE        0xF3U


/* ============================================================
 * GPIO PINMUX
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE     150994944U
#define EXP_GPIO_PINMUX1_VALUE     585U



/* ============================================================
 * Main
 * ============================================================ */

int main(void)
{
    uint32_t main_resume_pc;


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
     * Keep your existing required value:
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


    /* ============================================================
     * Verify IRQ10 Enable
     * ============================================================ */

    if (mmio_read(IRQ10_ENABLE_REG_ADDR) !=
        EXP_IRQ10_ENABLE_VALUE)
    {
        error_print(0);
    }
    else
    {
        info_print(1);
    }


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
     * Verify IRQ10 Control
     * ============================================================ */

    if (mmio_read(IRQ10_CTL_REG_ADDR) !=
        EXP_IRQ10_CTL_VALUE)
    {
        error_print(1);
    }
    else
    {
        info_print(2);
    }


    info_print(0x2222);


    /* ============================================================
     * CONTROLLED INTERRUPT POINT
     *
     * This marker identifies the point in the test where the
     * interrupt source is allowed to become active.
     * ============================================================ */

    info_print(0x3000);


    /*
     * Tell SV that CPU is ready.
     *
     * SV should assert IRQ10 after this handshake.
     */
    send_handshake_to_sv(1);


    /*
     * This is the controlled application execution point.
     *
     * SV should assert IRQ10 around this point.
     */
    info_print(0x3010);


    /*
     * Keep a visible instruction sequence after the handshake.
     *
     * The actual MEPC value must be determined from the
     * instruction/PC trace and CPU interrupt-entry behavior.
     */
    info_print(0x3020);


    info_print(0x3030);


    /* ============================================================
     * After interrupt handler returns with MRET
     *
     * Execution should resume according to MEPC.
     * ============================================================ */

    info_print(0x3040);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x3333);

    info_print(0x7042);


}
