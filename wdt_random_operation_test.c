#include "peripheral.h"

int main()
{
    uint32_t seed = 0x12345678;
    uint32_t timeout;
    uint32_t window;
    uint32_t wait_cycles;
    uint32_t status;
    uint32_t count;
    uint32_t boot;
    uint32_t cause;
    uint32_t ctrl;
    int i;
    int j;

    /* Initial configuration */
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR,100);

    mmio_write(WDT_BASE_ADDR + WDT_WINDOW_ADDR,50);

    mmio_write(WDT_BASE_ADDR + WDT_RESET_WIDTH_ADDR,32);

    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE |
               WDT_CTRL_RESET_EN);

    for(i=0;i<100;i++)
    {
        seed = seed * 1664525 + 1013904223;

        timeout = ((seed>>8)&0xFF)+20;

        window = timeout/2;

        wait_cycles = ((seed>>16)&0x1F)+1;

        /*--------------------------------------------------*/
        /* Random Enable */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            ctrl = WDT_CTRL_ENABLE |
                   WDT_CTRL_RESET_EN;

            if(seed & 2)
                ctrl |= WDT_CTRL_WINDOW_EN;

            if(seed & 4)
                ctrl |= WDT_CTRL_DBG_FREEZE_EN;

            mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
                       ctrl);
        }

        /*--------------------------------------------------*/
        /* Random Disable */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,0);
            mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,1);
            
        }

        /*--------------------------------------------------*/
        /* Random Timeout */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR,
                       timeout);
        }

        /*--------------------------------------------------*/
        /* Random Window */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR + WDT_WINDOW_ADDR,
                       window);
        }

        /*--------------------------------------------------*/
        /* Valid Refresh */
        /*--------------------------------------------------*/
           seed = seed * 1664525 + 1013904223;

if(((seed >> 8) & 0x03) == 0)
{
    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
               WDT_REFRESH_KEY1);

    mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
               WDT_REFRESH_KEY2);
}        /*--------------------------------------------------*/
        /* Invalid Refresh */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
                       0x55);

            mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
                       0xAA);
        }

        /*--------------------------------------------------*/
        /* Lock */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR + WDT_LOCK_ADDR,
                       WDT_LOCK_KEY);
        }

        /*--------------------------------------------------*/
        /* Unlock */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR + WDT_LOCK_ADDR,
                       WDT_UNLOCK_KEY);
        }

        /*--------------------------------------------------*/
        /* Reset Width */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR + WDT_RESET_WIDTH_ADDR,
                       ((seed>>20)&0x3F)+1);
        }

        /*--------------------------------------------------*/
        /* Status Read */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            status = mmio_read(WDT_BASE_ADDR +
                               WDT_STATUS_ADDR);
        }

        /*--------------------------------------------------*/
        /* Count Read */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            count = mmio_read(WDT_BASE_ADDR +
                              WDT_COUNT_ADDR);
        }

        /*--------------------------------------------------*/
        /* Reset Cause Read */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            cause = mmio_read(WDT_BASE_ADDR +
                              WDT_RESET_CAUSE_ADDR);
        }

        /*--------------------------------------------------*/
        /* Boot Status Read */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            boot = mmio_read(WDT_BASE_ADDR +
                             WDT_BOOT_STATUS_ADDR);
        }

        /*--------------------------------------------------*/
        /* Status Clear */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR +
                       WDT_STATUS_ADDR,
                       WDT_STATUS_TIMEOUT_FLAG |
                       WDT_STATUS_WINDOW_VIOLATION |
                       WDT_STATUS_REFRESH_ERROR |
                       WDT_STATUS_RESET_ISSUED);
        }

        /*--------------------------------------------------*/
        /* Boot Status Clear */
        /*--------------------------------------------------*/
        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR +
                       WDT_BOOT_STATUS_ADDR,
                       WDT_BOOT_PREV_RESET_WDT);
        }

        /*--------------------------------------------------*/
        /* Random Delay */
        /*--------------------------------------------------*/
        for(j=0;j<wait_cycles;j++)
        {
            asm volatile("nop");
        }
    }

    send_handshake_to_sv();

}
