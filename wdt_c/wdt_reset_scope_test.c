#include "peripheral.h"

int main()
{
    uint32_t ctrl_reg;

    /* Core */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN |
               WDT_SCOPE_CORE);

    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);

    /* Delay by repeated reads */
    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);
    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);

    /* Cluster */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN |
               WDT_SCOPE_CLUSTER);

    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);
    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);
    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);

    /* Subsystem */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN |
               WDT_SCOPE_SUBSYSTEM);

    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);
    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);
    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);

    /* SoC */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN |
               WDT_SCOPE_SOC);

    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);
    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);
    ctrl_reg = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);

    send_handshake_to_sv ();
    

 }
