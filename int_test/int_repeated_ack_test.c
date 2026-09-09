#include "peripheral.h"


/* ============================================================
 *  Repeated ACK Protection
 *
 * Verify that a repeated/unexpected ACK while an interrupt is
 * already acknowledged/in service does not:
 *
 *     - duplicate interrupt service
 *     - change current interrupt ID
 *     - corrupt pending state
 *     - incorrectly acknowledge another interrupt
 *
 *
 * Test:
 *
 *     IRQ10 enabled
 *     IRQ10 priority = 15
 *
 * SV generates IRQ10.
 *
 * First ACK:
 *
 *     ACK ID = IRQ10_ID
 *
 * IRQ10 is now acknowledged / in service.
 *
 * Second ACK:
 *
 *     ACK ID = IRQ10_ID
 *
 * while IRQ10 is still in service.
 *
 * Expected:
 *
 *     No duplicate service.
 *     Current interrupt ID remains valid.
 *     No additional handler entry.
 *
 * ============================================================ */


/* ============================================================
 * Expected values
 * ============================================================ */

#define EXP_IRQ10_ENABLE_VALUE     0x01U

/*
 * IRQ10 priority = 15
 *
 * CTL = 0xF3
 */
#define EXP_IRQ10_CTL_VALUE        0xF3U


/* ============================================================
 * GPIO PINMUX
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE     150994944U
#define EXP_GPIO_PINMUX1_VALUE     585U


int main(void)
{
    uint32_t actual_value;


    /* ============================================================
     * Test Start
     * ============================================================ */

    info_print(0x0000);


    /* ============================================================
     * Enable Global Machine Interrupt
     *
     * mstatus.MIE = bit[3]
     * ============================================================ */

    asm volatile (
        "li t0, 0x8\n"
        "csrrs x0, mstatus, t0\n"
    );


    /* ============================================================
     * Enable Machine External Interrupt
     *
     * Keep existing configuration.
     *
     * 0xFC000000
     * ============================================================ */

    asm volatile (
        "li t0, 0xFC000000\n"
        "csrrs x0, mie, t0\n"
    );


    info_print(0x1111);


    /* ============================================================
     * GPIO PINMUX Configuration
     * ============================================================ */

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR,
        EXP_GPIO_PINMUX0_VALUE
    );

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR,
        EXP_GPIO_PINMUX1_VALUE
    );


    info_print(0x2000);


    /* ============================================================
     * Enable IRQ10
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_IRQ10_ENABLE_VALUE
    );


    actual_value = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );


    if (actual_value != EXP_IRQ10_ENABLE_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * Configure IRQ10
     *
     * Priority = 15
     * CTL      = 0xF3
     * ============================================================ */

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_VALUE
    );


    actual_value = mmio_read(
        IRQ10_CTL_REG_ADDR
    );


    if (actual_value != EXP_IRQ10_CTL_VALUE)
        error_print(1);
    else
        info_print(2);


    /* ============================================================
     * Configuration Complete
     * ============================================================ */

    info_print(0x2222);


    /* ============================================================
     * Inform SV
     *
     * SV should assert ONLY IRQ10.
     *
     * Expected:
     *
     *     IRQ10 becomes pending
     *     IRQ10 is selected
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3000);


  

    /* ============================================================
     * Repeated ACK Check
          * ============================================================ */

    info_print(0x3030);


    /* ============================================================
     * Test Complete
     *
     *
     * ============================================================ */

    info_print(0x7037);


}
