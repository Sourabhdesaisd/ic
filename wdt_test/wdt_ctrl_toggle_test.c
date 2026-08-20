#include "peripheral.h"

int main()
{
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 20);

    /* Enable */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    /* Disable */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR, 0);

    mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    /* Enable */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);
    /* Enable */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    send_handshake_to_sv();
}
