
#include "peripheral.h"

int main()
{
    uint32_t timeout_before;
    uint32_t timeout_after;

    /* Program timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 100);

    /* Enable WDT */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE);

    /* Read programmed timeout */
    timeout_before = mmio_read(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR);

    /* Lock watchdog */
    mmio_write(WDT_BASE_ADDR + WDT_LOCK_ADDR,
               WDT_LOCK_KEY);

    /* Try to modify timeout (should be ignored) */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 200);

    /* Read timeout again */
    timeout_after = mmio_read(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR);

    send_handshake_to_sv ();
    

}
