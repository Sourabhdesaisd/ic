#include "peripheral.h"

int main()
{
    uint32_t mstatus_value;
    uint32_t mie_value;

    info_print(0x0000);


    /* ============================================================
     * Read Machine Status Register
     *
     * mstatus.MIE = bit[3]
     *
     * After reset:
     * MIE = 0
     * ============================================================ */

    asm volatile (
        "csrr %0, mstatus"
        : "=r"(mstatus_value)
    );

    if ((mstatus_value & 0x00000008U) != 0x00000000U)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * Enable Machine External Interrupt
     *
     * Use the same configuration as your existing interrupt tests.
     * ============================================================ */

    asm volatile (
        "li t0, 0xFC000000\n"
        "csrrs x0, mie, t0\n"
    );


    /* ============================================================
     * Read MIE after enabling
     *
     * Check that the programmed external interrupt enable bits
     * are actually set.
     *
     * 0xFC000000 = bits [31:26]
     * ============================================================ */

    asm volatile (
        "csrr %0, mie"
        : "=r"(mie_value)
    );

    if ((mie_value & 0xFC000000U) != 0xFC000000U)
        error_print(1);
    else
        info_print(2);


    /* ============================================================
     * Test point
     * ============================================================ */

    info_print(0x2222);




    send_handshake_to_sv(1);

    info_print(0x3333);

}
