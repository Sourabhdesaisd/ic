#include "peripheral.h"

/* ============================================================
 * Expected Values
 * ============================================================ */

#define EXP_IRQ0_ENABLE_VALUE       0x00000001U
#define EXP_IRQ0_ATTR_VALUE         0x00000000U
#define EXP_IRQ0_CTL_VALUE          0x000000D3U

#define EXP_WDT_TIMEOUT_VALUE       10U

#define EXP_WDT_CTRL_VALUE          \
    (WDT_CTRL_ENABLE |              \
     WDT_CTRL_RESET_EN |(WDT_SCOPE_CLUSTER | !WDT_NOP_SCOPE) )


int main(void)
{
    uint32_t actual_irq0_enable;
    uint32_t actual_irq0_attr;
    uint32_t actual_irq0_ctl;

    uint32_t actual_wdt_timeout;
    uint32_t actual_wdt_ctrl;


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
     * ============================================================ */

    asm volatile (
        "li t0, 0xFC000000\n"
        "csrrs x0, mie, t0\n"
    );


    info_print(0x1111);


    /* ============================================================
     * Configure Interrupt Controller IRQ0
     *
     * IRQ0 = WDT interrupt/reset path
     * ============================================================ */


    /* ============================================================
     * Enable IRQ0
     * ============================================================ */

    mmio_write(
        IRQ0_ENABLE_REG_ADDR,
        EXP_IRQ0_ENABLE_VALUE
    );

    actual_irq0_enable =
        mmio_read(IRQ0_ENABLE_REG_ADDR);

    if (actual_irq0_enable != EXP_IRQ0_ENABLE_VALUE)
        error_print(0);
    else
        info_print(1);


    

    /* ============================================================
     * Configure IRQ0 Control
     *
     * Expected control value = 0xD3
     * ============================================================ */

    mmio_write(
        IRQ0_CTL_REG_ADDR,
        EXP_IRQ0_CTL_VALUE
    );

    actual_irq0_ctl =
        mmio_read(IRQ0_CTL_REG_ADDR);

    if (actual_irq0_ctl != EXP_IRQ0_CTL_VALUE)
        error_print(2);
    else
        info_print(3);


    info_print(0x2222);


    /* ============================================================
     * Configure WDT Timeout
     * ============================================================ */

    mmio_write(
        WDT_BASE_ADDR + WDT_TIMEOUT_ADDR,
        EXP_WDT_TIMEOUT_VALUE
    );


    /* ============================================================
     * Read WDT Timeout
     * ============================================================ */

    actual_wdt_timeout =
        mmio_read(
            WDT_BASE_ADDR + WDT_TIMEOUT_ADDR
        );


    /* Self-check */

    if (actual_wdt_timeout != EXP_WDT_TIMEOUT_VALUE)
        error_print(3);
    else
        info_print(4);


    info_print(0x3333);
   
    for (int i = 0; i < 5000; i++);


    /* ============================================================
     * Enable WDT
     *
     * - WDT enable
     * - Reset enable
     * - Cluster scope
     * ============================================================ */

    mmio_write(
        WDT_BASE_ADDR + WDT_CTRL_ADDR,
        EXP_WDT_CTRL_VALUE
    );


    /* ============================================================
     * Read WDT Control Register
     * ============================================================ */

    actual_wdt_ctrl =
        mmio_read(
            WDT_BASE_ADDR + WDT_CTRL_ADDR
        );


    /* ============================================================
     * Self-check WDT control
     *
     * If this register contains status/RO bits, replace the
     * direct comparison with a mask for writable bits.
     * ============================================================ */

    if (actual_wdt_ctrl != EXP_WDT_CTRL_VALUE)
        error_print(4);
    else
        info_print(5);


    info_print(0x4444);


    /* ============================================================
     * Configuration complete.
     *
     * Inform SV/UVM that:
     *   1. IRQ0 is configured
     *   2. WDT timeout is configured
     *   3. WDT is enabled
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x5555);


}
