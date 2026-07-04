#include "peripheral.h"

int main()
{
    uint32_t count1;
    uint32_t count2;
    uint32_t count3;

    /* Program timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 50);

    /* Enable WDT */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    count1 = mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);
    count2 = mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    /* Disable WDT */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR, 0);

    count3 = mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    /* Enable again */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    send_handshake_to_sv ();
}
