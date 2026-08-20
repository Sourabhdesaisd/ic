#include "peripheral.h"

int main()
{
    uint32_t boot_status;

    /* Program timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 5);

    /* Enable watchdog */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Wait until watchdog timeout occurs */
    while (!(mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR) &
             WDT_STATUS_TIMEOUT_FLAG));
    



    /* Read boot status */
    boot_status = mmio_read(WDT_BASE_ADDR + WDT_BOOT_STATUS_ADDR);

    mmio_write(WDT_BASE_ADDR + WDT_BOOT_STATUS_ADDR, 0x1);
    
    
    mmio_write(WDT_BASE_ADDR + WDT_BOOT_STATUS_ADDR, 0x2);

    /* Read again */
    boot_status = mmio_read(WDT_BASE_ADDR + WDT_BOOT_STATUS_ADDR);

    send_handshake_to_sv ();
    

}
