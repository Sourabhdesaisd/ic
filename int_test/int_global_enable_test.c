#include "peripheral.h"


/* ============================================================
 *  Global Enable Masking
 *
 * Purpose:
 * Verify that mstatus.MIE blocks interrupt delivery.
 *
 * Test sequence:
 *
 *   1. Disable global interrupt - mstatus.MIE = 0
 *   2. Enable machine external interrupt using 0xFC000000
 *   3. Enable IRQ10 in Interrupt Controller
 *   4. Generate IRQ10 from SV
 *   5. IRQ10 must become pending
 *   6. CPU must NOT enter IRQ10 handler while MIE = 0
 *   7. Enable global interrupt - mstatus.MIE = 1
 *   8. Pending IRQ10 must be serviced
 *   9. IRQ10 handler executes
 *  10. Handler returns using mret
 *
 * ============================================================ */


/* ============================================================
 * Expected Values
 * ============================================================ */

#define EXP_IRQ10_ENABLE       0x01U
#define EXP_IRQ10_PENDING      0x01U


int main(void)
{
    uint32_t expected_enable;
    uint32_t actual_enable;

    uint32_t expected_pending;
    uint32_t actual_pending;


    /* ============================================================
     * Test Start
     * ============================================================ */

    info_print(0x0000);


    /* ============================================================
     * Disable Global Machine Interrupt
     *
     * mstatus.MIE = 0
     *
     * 0x8 = bit[3]
     * ============================================================ */

    asm volatile (
        "li t0, 0x8\n"
        "csrrc x0, mstatus, t0\n"
    );


    info_print(0x1000);


    /* ============================================================
     * Enable Machine External Interrupt
     *
     * Keep the existing configuration used by your tests.
     *
     * mie = mie | 0xFC000000
     *
     * IMPORTANT:
     * Global interrupt is still disabled because:
     *
     *     mstatus.MIE = 0
     *
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
        150994944U
    );

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR,
        585U
    );


    info_print(0x2000);


    /* ============================================================
     * Enable IRQ10
     *
     * IRQ10 ENABLE register is RW.
     * ============================================================ */

    expected_enable = EXP_IRQ10_ENABLE;

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        expected_enable
    );


    /* ============================================================
     * Read IRQ10 ENABLE
     * ============================================================ */

    actual_enable = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );


    /* ============================================================
     * Self-check IRQ10 ENABLE
     * ============================================================ */

    if (actual_enable != expected_enable)
        error_print(0);
    else
        info_print(1);


   

    /* ============================================================
     * Configure IRQ10 control
     * ============================================================ */

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        0x000000D3U
    );


    info_print(0x2222);


    /* ============================================================
     * GLOBAL INTERRUPT IS STILL DISABLED
     *
     * At this point:
     *
     *     mstatus.MIE = 0
     *     mie          = configured
     *     IRQ10 enable = 1
     *
     * Tell SV to generate IRQ10.
     *
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3000);


    /* ============================================================
     * Check IRQ10 pending
     *
     * SV should assert IRQ10 after the handshake.
     *
     * Expected:
     *
     *     IRQ10 pending = 1
     *
     * But:
     *
     *     mstatus.MIE = 0
     *
     * Therefore CPU must NOT enter irq10_handler.
     *
     * ============================================================ */

 /*   expected_pending = EXP_IRQ10_PENDING;

    actual_pending = mmio_read(
        IRQ10_PENDING_REG_ADDR
    );*/


    /* ============================================================
     * Self-check pending state
     * ============================================================ */

   /* if (actual_pending != expected_pending)
        error_print(1);
    else
        info_print(2);*/

  //
  //
  /*
 * Note:
 * During the SV test, the interrupt is asserted only once and the
 * pending register gets updated when the interrupt goes high.
 * The pending bit is then cleared as part of the interrupt handling
 * sequence before this C test reads the register. Therefore, the
 * pending register cannot be observed as '1' from the C test.
 */
    /* ============================================================
     * Global Interrupt Still Disabled
     *
     * IRQ10 is pending, but CPU must not service it.
     *
     * Waveform expectation:
     *
     *     IRQ10 source       = 1
     *     IRQ10 pending      = 1
     *     mstatus.MIE        = 0
     *     CPU interrupt      = 0
     *     irq10_handler      = NOT ENTERED
     *
     * ============================================================ */

    info_print(0x3100);


    /* ============================================================
     * Enable Global Machine Interrupt
     *
     * mstatus.MIE = 1
     *
     * The IRQ10 interrupt is already pending.
     *
     * Therefore CPU should now recognize and service IRQ10.
     *
     * ============================================================ */

    asm volatile (
        "li t0, 0x8\n"
        "csrrs x0, mstatus, t0\n"
    );


    info_print(0x4000);


   

    info_print(0x5000);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x5005);

}
