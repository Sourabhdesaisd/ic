
#include "peripheral.h"

int main()
{
    uint32_t reset_cause;

    /* Program a small timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 5);

    /* Enable watchdog */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Wait until timeout occurs */
    while (!(mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR) &
             WDT_STATUS_TIMEOUT_FLAG));

    /* Read RESET_CAUSE register */
    reset_cause =
        mmio_read(WDT_BASE_ADDR + WDT_RESET_CAUSE_ADDR);

    send_handshake_to_sv ();
    

}
