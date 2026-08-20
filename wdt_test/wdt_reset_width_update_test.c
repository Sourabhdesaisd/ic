#include "peripheral.h"

int main()
{
    /* Program timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 10);

    /* Program initial reset width */
    mmio_write(WDT_BASE_ADDR + WDT_RESET_WIDTH_ADDR, 5);

    /* Enable WDT */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Update reset width while WDT is running */
    mmio_write(WDT_BASE_ADDR + WDT_RESET_WIDTH_ADDR, 15);

    /* Wait for timeout */
    while (!(mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR) &
             WDT_STATUS_TIMEOUT_FLAG));

    send_handshake_to_sv();
}
