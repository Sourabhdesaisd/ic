#include "peripheral.h"

/* ============================================================
 * Expected Values
 * ============================================================ */

#define EXP_IRQ0_PENDING_VALUE    0x00000078U
#define EXP_IRQ0_ENABLE_VALUE     0x00000001U
#define EXP_IRQ0_CTL_VALUE        0x00000076U


int main(void)
{
    uint32_t actual_irq0_pending;
    uint32_t actual_irq0_enable;
    uint32_t actual_irq0_ctl;


    /* ============================================================
     * Test Start
     * ============================================================ */

    info_print(0x0000);


    /* ============================================================
     * Configure IRQ0 Pending Register
     * ============================================================ */

    mmio_write(
        IRQ0_PENDING_REG_ADDR,
        EXP_IRQ0_PENDING_VALUE
    );


    /* Read IRQ0 Pending Register */

    actual_irq0_pending =
        mmio_read(IRQ0_PENDING_REG_ADDR);


    /* Self Check */

    if (actual_irq0_pending != EXP_IRQ0_PENDING_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * Configure IRQ0 Enable Register
     * ============================================================ */

    mmio_write(
        IRQ0_ENABLE_REG_ADDR,
        EXP_IRQ0_ENABLE_VALUE
    );


    /* Read IRQ0 Enable Register */

    actual_irq0_enable =
        mmio_read(IRQ0_ENABLE_REG_ADDR);


    /* Self Check */

    if (actual_irq0_enable != EXP_IRQ0_ENABLE_VALUE)
        error_print(1);
    else
        info_print(2);


    

    /* ============================================================
     * Configure IRQ0 Control Register
     * ============================================================ */

    mmio_write(
        IRQ0_CTL_REG_ADDR,
        EXP_IRQ0_CTL_VALUE
    );


    /* Read IRQ0 Control Register */

    actual_irq0_ctl =
        mmio_read(IRQ0_CTL_REG_ADDR);


    /* Self Check */

    if (actual_irq0_ctl != EXP_IRQ0_CTL_VALUE)
        error_print(3);
    else
        info_print(4);


    /* ============================================================
     * All Register Readback Checks Passed
     * ============================================================ */

    info_print(0x4444);


    /* ============================================================
     * Inform SV/UVM that IRQ0 configuration is complete
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x5555);


    return 0;
}
