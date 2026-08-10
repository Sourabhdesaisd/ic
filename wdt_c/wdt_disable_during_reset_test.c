#include "peripheral.h"

int main()
{
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 10);

    mmio_write(WDT_BASE_ADDR + WDT_RESET_WIDTH_ADDR, 15);

    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    while (!(mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR) &
             WDT_STATUS_TIMEOUT_FLAG));

    /* Disable WDT while reset pulse is active */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR, 0);

    send_handshake_to_sv();
}
