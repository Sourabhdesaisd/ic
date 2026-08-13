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
        "li t0, 0x800\n"
        "csrrs x0, mie, t0\n"
    );

    info_print(0x1111);

    //------------------------------------------------------------
    // IRQ10 - Priority 13
    //------------------------------------------------------------
    mmio_write(IRQ10_ENABLE_REG_ADDR, 0x00000001);
    mmio_write(IRQ10_ATTR_REG_ADDR,   0x00000000);
    mmio_write(IRQ10_CTL_REG_ADDR,    0x000000D3);

    //------------------------------------------------------------
    // IRQ11 - Priority 13
    //------------------------------------------------------------
    mmio_write(IRQ11_ENABLE_REG_ADDR, 0x00000001);
    mmio_write(IRQ11_ATTR_REG_ADDR,   0x00000000);
    mmio_write(IRQ11_CTL_REG_ADDR,    0x000000D3);

    //------------------------------------------------------------
    // IRQ12 - Priority 13
    //------------------------------------------------------------
    mmio_write(IRQ12_ENABLE_REG_ADDR, 0x00000001);
    mmio_write(IRQ12_ATTR_REG_ADDR,   0x00000000);
    mmio_write(IRQ12_CTL_REG_ADDR,    0x000000D3);

    //------------------------------------------------------------
    // IRQ13 - Priority 13
    //------------------------------------------------------------
    mmio_write(IRQ13_ENABLE_REG_ADDR, 0x00000001);
    mmio_write(IRQ13_ATTR_REG_ADDR,   0x00000000);
    mmio_write(IRQ13_CTL_REG_ADDR,    0x000000D3);

    //------------------------------------------------------------
    // IRQ14 - Priority 13
    //------------------------------------------------------------
    mmio_write(IRQ14_ENABLE_REG_ADDR, 0x00000001);
    mmio_write(IRQ14_ATTR_REG_ADDR,   0x00000000);
    mmio_write(IRQ14_CTL_REG_ADDR,    0x000000D3);

    //------------------------------------------------------------
    // IRQ15 - Priority 13
    //------------------------------------------------------------
    mmio_write(IRQ15_ENABLE_REG_ADDR, 0x00000001);
    mmio_write(IRQ15_ATTR_REG_ADDR,   0x00000000);
    mmio_write(IRQ15_CTL_REG_ADDR,    0x000000D3);

    info_print(0x2222);

    //------------------------------------------------------------

    //------------------------------------------------------------
    send_handshake_to_sv(1);

    info_print(0x3333);


}
