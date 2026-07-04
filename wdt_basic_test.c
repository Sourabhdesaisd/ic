#include "peripheral.h"

int main()
{
    uint32_t status;

    /* Program timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 20);

    /* Enable WDT */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE);

    /* Read status */
    status = mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR);

    send_handshake_to_sv ();
    

}
