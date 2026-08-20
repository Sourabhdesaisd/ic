#include "peripheral.h"

int main()
{
    uint32_t count_before;
    uint32_t count_freeze;
    uint32_t count_after;

    /* Program timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 20);

    /* Enable watchdog with Debug Freeze */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN |
               WDT_CTRL_DBG_FREEZE_EN);

    /* Read counter before debug halt */
    count_before =
        mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    /*
     * TB forces:
     * debug_halted = 1
     */

    for (int i = 0; i < 5000; i++);

    /* Read counter while debug halt is asserted */
    count_freeze =
        mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    /*
     * TB forces:
     * debug_halted = 0
     */

    for (int i = 0; i < 5000; i++);

    /* Read counter after debug halt is released */
    count_after =
        mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

    send_handshake_to_sv ();

}
