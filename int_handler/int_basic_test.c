#include "peripheral.h"

int main()
{
    info_print(0x00000);
    
    
    //-------------------------------------------------------
    // Enable Global Interrupt (mstatus.MIE = bit3)
    //-------------------------------------------------------
    asm volatile (
        "li   t0, 0x8\n"
        "csrrs x0, mstatus, t0\n"
    );

    //-------------------------------------------------------
    // Enable Machine External Interrupt (mie.MEIE = bit11)
    //-------------------------------------------------------
    asm volatile (
        "li   t0, 0x800\n"
        "csrrs x0, mie, t0\n"
    );
    
    info_print(0x1111);

    //--------------------------------------------------
    // Enable IRQ10
    //--------------------------------------------------
    mmio_write(IRQ10_ENABLE_REG_ADDR, 0x00000001);

    //--------------------------------------------------
    // Program IRQ10 attributes
    // (Use the correct value from spec)
    //--------------------------------------------------
    mmio_write(IRQ10_ATTR_REG_ADDR, 0x00000000);

    //--------------------------------------------------
    // Program IRQ10 control
    // (Use the correct value from spec)
    //--------------------------------------------------
    mmio_write(IRQ10_CTL_REG_ADDR, 0x000000D3);

    info_print(0x2222);

    //--------------------------------------------------
    // Inform SV that configuration is complete
    //--------------------------------------------------
    send_handshake_to_sv(1);

    info_print(0x3333);

}
