#include "peripheral.h"

int main()
{
    info_print(0x0000);

    
    //----------------------------------------------------------
    // Configure Interrupt Controller IRQ0
    //
    // IRQ0 = WDT reset
    // IRQ0 ID = 16
    //----------------------------------------------------------

    mmio_write(IRQ0_PENDING_REG_ADDR, 0x12345678);
    mmio_write(IRQ0_ENABLE_REG_ADDR,  0x09876543);
    mmio_write(IRQ0_ATTR_REG_ADDR,    0x54678159);
    mmio_write(IRQ0_CTL_REG_ADDR,     0x12900876);


    mmio_read(IRQ0_PENDING_REG_ADDR );
    mmio_read(IRQ0_ENABLE_REG_ADDR  );
    mmio_read(IRQ0_ATTR_REG_ADDR    );
    mmio_read(IRQ0_CTL_REG_ADDR     );
    


        //----------------------------------------------------------
    //----------------------------------------------------------

    send_handshake_to_sv(1);

    info_print(0x5555);


}
