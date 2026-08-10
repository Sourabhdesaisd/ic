#include "peripheral.h"

int main()
{
    uint32_t status;

    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 20);

    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Valid refresh sequence */
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
               WDT_REFRESH_KEY1);

    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
               WDT_REFRESH_KEY2);

    status = mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR);

    send_handshake_to_sv ();
    

}
