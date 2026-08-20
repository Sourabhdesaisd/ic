#include "peripheral.h"

int main()
{
    uint32_t count1;
    uint32_t count2;

    /* Program timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 10);

    /* Enable WDT */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Disable WDT */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR, 0);

    count1 = mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    /* Valid refresh sequence */
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0xA5);
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0x5A);

    count2 = mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    send_handshake_to_sv();
}
