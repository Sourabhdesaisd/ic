#include "peripheral.h"

int main()
{
    uint32_t last_pc;

    /* Program a small timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 5);

    /* Enable watchdog */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Wait until timeout occurs */
    while (!(mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR) &
             WDT_STATUS_TIMEOUT_FLAG));

    /* Read LAST_PC register */
    last_pc = mmio_read(WDT_BASE_ADDR + WDT_LAST_PC_ADDR);

    send_handshake_to_sv ();
    

}
