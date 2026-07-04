#include "peripheral.h"

int main()
{
    uint32_t count1;
    uint32_t count2;

    /* Program initial timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 50);

    /* Enable WDT */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Read current count */
    count1 = mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    /* Update timeout while WDT is running */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 100);

    /* Read updated count */
    count2 = mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    send_handshake_to_sv();
}
