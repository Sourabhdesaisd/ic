#include "peripheral.h"

int main()
{
    uint32_t seed = 0x12345678;

    uint32_t timeout;
    uint32_t window;
    uint32_t reset_width;
    uint32_t wait_cycles;

    uint32_t status;
    uint32_t count;
    uint32_t boot;
    uint32_t cause;

    uint32_t ctrl;

    int i;
    int j;

    /*---------------------------------------------*/
    /* Initial Configuration                       */
    /*---------------------------------------------*/

    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR,100);

    mmio_write(WDT_BASE_ADDR + WDT_WINDOW_ADDR,50);

    mmio_write(WDT_BASE_ADDR + WDT_RESET_WIDTH_ADDR,32);

    ctrl =
        WDT_CTRL_ENABLE |
        WDT_CTRL_RESET_EN;

    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               ctrl);

    /*---------------------------------------------*/
    /* Random Stress                               */
    /*---------------------------------------------*/

    for(i=0;i<100;i++)
    {
        /* Random number */

        seed = seed * 1664525 + 1013904223;

        timeout = (seed & 0xFF) + 20;

        seed = seed * 1664525 + 1013904223;

        window = (seed & 0x7F) + 10;

        seed = seed * 1664525 + 1013904223;

        reset_width = (seed & 0x3F) + 1;

        seed = seed * 1664525 + 1013904223;

        wait_cycles = (seed & 0x1F) + 1;

        /*--------------------------------------*/
        /* Enable with random configuration     */
        /*--------------------------------------*/

        ctrl =
            WDT_CTRL_ENABLE |
            WDT_CTRL_RESET_EN;

        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
            ctrl |= WDT_CTRL_WINDOW_EN;

        if(seed & 2)
            ctrl |= WDT_CTRL_DBG_FREEZE_EN;

        mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
                   ctrl);

        /*--------------------------------------*/
        /* Random Timeout                       */
        /*--------------------------------------*/

        mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR,
                   timeout);

        /*--------------------------------------*/
        /* Random Window                        */
        /*--------------------------------------*/

        mmio_write(WDT_BASE_ADDR + WDT_WINDOW_ADDR,
                   window);

        /*--------------------------------------*/
        /* Random Reset Width                   */
        /*--------------------------------------*/

        mmio_write(WDT_BASE_ADDR + WDT_RESET_WIDTH_ADDR,
                   reset_width);

        /*--------------------------------------*/
        /* Random Valid Refresh                 */
        /*--------------------------------------*/

        seed = seed * 1664525 + 1013904223;

        if(((seed >> 8) & 0x03) == 0)
        

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
                       WDT_REFRESH_KEY1);

            mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
                       WDT_REFRESH_KEY2);
        }

        /*--------------------------------------*/
        /* Random Invalid Refresh               */
        /*--------------------------------------*/

        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
                       0x55);

            mmio_write(WDT_BASE_ADDR + WDT_REFRESH_ADDR,
                       0xAA);
        }



        /*--------------------------------------------------*/
        /* Random Lock */
        /*--------------------------------------------------*/
        
        seed = seed * 1664525 + 1013904223;
        
        if(seed & 4)
        {
            ctrl = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);
        
            ctrl |= WDT_CTRL_LOCK_EN;
        
            mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
                       ctrl);
        
            mmio_write(WDT_BASE_ADDR + WDT_LOCK_ADDR,
                       WDT_LOCK_KEY);
        }

        /*--------------------------------------------------*/
        /* Random Unlock */
        /*--------------------------------------------------*/
        
        seed = seed * 1664525 + 1013904223;
        
        if(seed & 8)
        {
            mmio_write(WDT_BASE_ADDR + WDT_LOCK_ADDR,
                       WDT_UNLOCK_KEY);
        
            ctrl = mmio_read(WDT_BASE_ADDR + WDT_CTRL_ADDR);
        
            ctrl &= ~WDT_CTRL_LOCK_EN;
        
            mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
                       ctrl);
        }

        /*--------------------------------------*/
        /* Read Registers                       */
        /*--------------------------------------*/

        status =
            mmio_read(WDT_BASE_ADDR + WDT_STATUS_ADDR);

        count =
            mmio_read(WDT_BASE_ADDR + WDT_COUNT_ADDR);

        cause =
            mmio_read(WDT_BASE_ADDR + WDT_RESET_CAUSE_ADDR);

        boot =
            mmio_read(WDT_BASE_ADDR + WDT_BOOT_STATUS_ADDR);

        /*--------------------------------------*/
        /* Random Status Clear                  */
        /*--------------------------------------*/

        seed = seed * 1664525 + 1013904223;

        if(seed & 1)
        {
            mmio_write(WDT_BASE_ADDR + WDT_STATUS_ADDR,
                       WDT_STATUS_TIMEOUT_FLAG |
                       WDT_STATUS_WINDOW_VIOLATION |
                       WDT_STATUS_REFRESH_ERROR |
                       WDT_STATUS_RESET_ISSUED);
        }

        /*-----------------------------------------*/
        /* Random Boot Status */
        /*-----------------------------------------*/
        
        seed = seed * 1664525 + 1013904223;
        
        if(seed & 3)
        {
            uint32_t boot_ctrl = 0;
        
            /* Randomly set Recovery Boot Request */
            if(seed & 4)
                boot_ctrl |= WDT_BOOT_RECOVERY_BOOT_REQ;
        
            /* Randomly clear Previous WDT Reset */
            if(seed & 5)
                boot_ctrl |= WDT_BOOT_PREV_RESET_WDT;
        
            mmio_write(WDT_BASE_ADDR + WDT_BOOT_STATUS_ADDR,
                       boot_ctrl);
        }

        /*-----------------------------------------*/
        /* Random Reset Scope */
        /*-----------------------------------------*/
        
        seed = seed * 1664525 + 1013904223;
        
        /* Random value: 0,1,2,3 */
        ctrl &= ~(3 << 6);
        ctrl |= ((seed & 0x3) << 6);
        
        mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
                   ctrl);

        /*--------------------------------------*/
        /* Occasionally Disable then Enable     */
        /*--------------------------------------*/

        seed = seed * 1664525 + 1013904223;

        if((seed & 0x0F) == 0)
        {
            mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,0);

            for(j=0;j<5;j++)
                asm volatile("nop");

            mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
                       ctrl);
        }

        /*--------------------------------------*/
        /* Random Delay                         */
        /*--------------------------------------*/

        for(j=0;j<wait_cycles;j++)
        {
            asm volatile("nop");
        }
    }

    send_handshake_to_sv();

}
