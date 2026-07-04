#include "peripheral.h"

int main()
{
    uint32_t status;

    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 20);

    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Invalid refresh sequence */
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0x12);

    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR, 0x34);

    status = mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR);

    send_handshake_to_sv ();
    

}
