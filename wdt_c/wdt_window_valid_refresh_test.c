#include "peripheral.h"

int main()
{
    uint32_t status;

    /* Program timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 25);

    /* Window value */
    mmio_write(WDT_BASE_ADDR + WDT_WINDOW_ADDR, 10);

    /* Enable WDT + Window Mode + Reset */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN |
               WDT_CTRL_WINDOW_EN);

    
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
               WDT_REFRESH_KEY1);

    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
               WDT_REFRESH_KEY2);

    status = mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR);

    send_handshake_to_sv ();

}
