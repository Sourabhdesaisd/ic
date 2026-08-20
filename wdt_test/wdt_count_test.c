#include "peripheral.h"

int main()
{
    uint32_t count1;
    uint32_t count2;
    uint32_t count3;

    /* Program timeout value */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 20);

    /* Enable watchdog */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Read current count */
    count1 = mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    /* Read again */
    count2 = mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    /* Perform valid refresh */
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
               WDT_REFRESH_KEY1);

    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
               WDT_REFRESH_KEY2);

    /* Read count after refresh */
    count3 = mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    send_handshake_to_sv ();
    

}
