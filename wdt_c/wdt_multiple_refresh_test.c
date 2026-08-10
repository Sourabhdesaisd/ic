#include "peripheral.h"

int main()
{
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 100);

    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Refresh 1 */
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0xA5);
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0x5A);

    /* Refresh 2 */
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0xA5);
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0x5A);

    /* Refresh 3 */
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0xA5);
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0x5A);

    /* Refresh 4 */
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0xA5);
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0x5A);

    send_handshake_to_sv();
}
