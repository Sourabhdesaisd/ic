#include "peripheral.h"

int main()
{
    info_print(0x00000);

    //------------------------------------------------------------
    // Enable Global Machine Interrupt
    //------------------------------------------------------------
    asm volatile (
        "li t0, 0x8\n"
        "csrrs x0, mstatus, t0\n"
    );

    //------------------------------------------------------------
    // Enable Machine External Interrupt
    //------------------------------------------------------------
    asm volatile (
        "li t0, 0xFC000000\n"
        "csrrs x0, mie, t0\n"
    );

    info_print(0x1111);

    
    /*
     * ==========================================================
     * GPIO PINMUX CONFIGURATION
     * ==========================================================
     *
     * Existing configuration from your test.
     *
     * GPIO PINMUX0 = 150994944
     * * GPIO PINMUX1 = 585        = 0x00000249
     *
     * This configuration is required for the GPIO interrupt
     * path used by the external interrupt.
     */

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR,
        150994944U
    );

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR,
        585U
    );

    info_print(0x2000);

    //------------------------------------------------------------
    // Enable IRQ12
    //------------------------------------------------------------
    mmio_write(IRQ12_ENABLE_REG_ADDR, 0x00000001);

    //------------------------------------------------------------
    // Program IRQ12 attributes
    //------------------------------------------------------------
    mmio_write(IRQ12_ATTR_REG_ADDR, 0x00000000);

    //------------------------------------------------------------
    // Program IRQ12 control
    //------------------------------------------------------------
    mmio_write(IRQ12_CTL_REG_ADDR, 0x000000D3);

    info_print(0x2222);

    //------------------------------------------------------------
    //------------------------------------------------------------
    send_handshake_to_sv(1);

    info_print(0x3333);


}
