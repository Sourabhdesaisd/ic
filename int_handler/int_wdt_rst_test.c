#include "peripheral.h"

int main()
{
    info_print(0x0000);

    //----------------------------------------------------------
    // Initialize interrupt trap handler
    //----------------------------------------------------------

 //   interrupt_init();

    //----------------------------------------------------------
    // Enable global machine interrupt
    //
    // mstatus.MIE = bit 3
    //----------------------------------------------------------

    asm volatile (
        "li t0, 0x8\n"
        "csrrs x0, mstatus, t0\n"
    );

    //----------------------------------------------------------
    // Enable machine external interrupt
    //
    // mie.MEIE = bit 11
    //----------------------------------------------------------

    asm volatile (
        "li t0, 0x800\n"
        "csrrs x0, mie, t0\n"
    );

    info_print(0x1111);

    //----------------------------------------------------------
    // Configure Interrupt Controller IRQ0
    //
    // IRQ0 = WDT reset
    // IRQ0 ID = 16
    //----------------------------------------------------------

    mmio_write(IRQ0_ENABLE_REG_ADDR, 0x00000001);

    mmio_write(IRQ0_ATTR_REG_ADDR, 0x00000000);

    //----------------------------------------------------------
    // IRQ0_CTL
    //
    // Enable
    // Level trigger
    // Low polarity
    // Priority = 13
    //
    // Use the same control value you already validated,
    // unless your WDT IRQ requires another polarity.
    //----------------------------------------------------------

    mmio_write(IRQ0_CTL_REG_ADDR, 0x000000D3);

    info_print(0x2222);

    //----------------------------------------------------------
    // Configure WDT
    //----------------------------------------------------------

    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 10);

    info_print(0x3333);

    //----------------------------------------------------------
    // Enable WDT + reset generation
    //----------------------------------------------------------

    mmio_write(
        WDT_BASE_ADDR + WDT_CTRL_ADDR,
        WDT_CTRL_ENABLE |
        WDT_CTRL_RESET_EN
    );

    info_print(0x4444);

    //----------------------------------------------------------
    //----------------------------------------------------------

    send_handshake_to_sv(1);

    info_print(0x5555);


}
