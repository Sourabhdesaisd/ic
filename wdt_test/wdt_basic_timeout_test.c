#include "peripheral.h"

/* Simple CPU delay */
static inline void delay_cycles(unsigned int cycles)
{
    while (cycles--)
    {
        __asm__ volatile("nop");
    }
}

int main()
{
    uint32_t status;

    /* Program timeout */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR, 20);

    /* Enable WDT + Reset */
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    /* Wait for timeout */
   // delay_cycles(10);

    /* Read status */
    status = mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR);

    send_handshake_to_sv ();
    

}
