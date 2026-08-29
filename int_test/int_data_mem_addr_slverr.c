#include "peripheral.h"

/* Variable is defined in exception_handlers.c */

extern volatile uint32_t irq6_handler_seen;

int main()
{
    info_print(0x0000);

    /* Clear previous handler status */

    irq6_handler_seen = 0U;

    /* Generate Data Memory Slave Error */

    mmio_write(INT_DATA_MEM_ADDR_SLVERROR, 10U);

    /* ========================================================
     * Self-check
     * ======================================================== */

    if (irq6_handler_seen != 1U)
    {
        error_print(0);
    }
    else
    {
        info_print(1);
    }

    info_print(0x9006);

    send_handshake_to_sv(1);

    return 0;
}
