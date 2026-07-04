#include "peripheral.h"

int main(void)
{
    uint32_t status_before;
    uint32_t status_after;

    /* Program timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 5);

    /* Enable watchdog */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Wait for timeout */
    while (!(mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR) &
             WDT_STATUS_TIMEOUT_FLAG));

    /* Read status */
    status_before =
        mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR);

    /* Clear timeout flag */
    mmio_write(WDT_BASE_ADDR + WDT_STATUS_ADDR,
               WDT_STATUS_TIMEOUT_FLAG);

    /* Read again */
    status_after =
        mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR);

    send_handshake_to_sv ();

}
