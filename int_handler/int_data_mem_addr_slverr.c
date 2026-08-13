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

    ////invalid  addr for wdt not given

    mmio_write(INT_DATA_MEM_ADDR_SLVERROR, 10);
    

    send_handshake_to_sv(1);

    info_print(0x3333);

}
