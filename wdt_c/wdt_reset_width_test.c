#include "peripheral.h"

int main()
{
    uint32_t reset_width;

    /* Program reset pulse width */
    mmio_write(WDT_BASE_ADDR + WDT_RESET_WIDTH_ADDR, 10);

    /* Read back reset width */
    reset_width =
        mmio_read(WDT_BASE_ADDR + WDT_RESET_WIDTH_ADDR);

    /* Program watchdog timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 5);

    /* Enable watchdog */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Wait for timeout */
    while (!(mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR) &
             WDT_STATUS_TIMEOUT_FLAG));

    send_handshake_to_sv ();
    

}
