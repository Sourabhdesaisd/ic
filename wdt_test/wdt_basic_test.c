#include "peripheral.h"

#define EXP_TIMEOUT_VALUE   20
#define EXP_TIMEOUT_FLAG    WDT_STATUS_TIMEOUT_FLAG

int main()
{
    uint32_t timeout_data;
    uint32_t status;
    uint32_t actual_timeout_flag;

    // Program timeout
    mmio_write(WDT_BASE_ADDR + WDT_TIMEOUT_ADDR,
               EXP_TIMEOUT_VALUE);

    // Read timeout register
    timeout_data = mmio_read(WDT_BASE_ADDR +
                             WDT_TIMEOUT_ADDR);

    // Self checking logic
    if (timeout_data != EXP_TIMEOUT_VALUE)
        error_print(0);
    else
        info_print(1);

    // Enable WDT
    mmio_write(WDT_BASE_ADDR + WDT_CTRL_ADDR,
               WDT_CTRL_ENABLE);

    // Wait for WDT timeout
    do
    {
        status = mmio_read(WDT_BASE_ADDR +
                           WDT_STATUS_ADDR);
    }
    while (!(status & WDT_STATUS_TIMEOUT_FLAG));

    // Get actual timeout flag
    actual_timeout_flag = status & WDT_STATUS_TIMEOUT_FLAG;

    // Self checking logic
    if (actual_timeout_flag != EXP_TIMEOUT_FLAG)
        error_print(1);
    else
        info_print(2);

    send_handshake_to_sv();
}
