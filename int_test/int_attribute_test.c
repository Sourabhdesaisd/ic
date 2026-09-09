#include "peripheral.h"


/* ============================================================
 *  Interrupt Attribute Programming / Verification
 *
 * NOTE:
 *
 * As per the current Interrupt MMR register definition,
 * soc_int_attr[0:15] are READ-ONLY.
 *
 * Therefore:
 *
 *     IRQ0-IRQ15 : READ and CHECK only
 *
 * The attribute values are verified before interrupt service
 * and again after servicing IRQ10.
 *
 * This verifies that interrupt service does not corrupt the
 * attribute register.
 *
 * ============================================================ */


/* ============================================================
 * Expected Attribute Values
 * ============================================================ */

#define EXP_IRQ0_ATTR_VALUE       0x10U
#define EXP_IRQ1_ATTR_VALUE       0x11U
#define EXP_IRQ2_ATTR_VALUE       0x12U
#define EXP_IRQ3_ATTR_VALUE       0x13U
#define EXP_IRQ4_ATTR_VALUE       0x14U
#define EXP_IRQ5_ATTR_VALUE       0x15U
#define EXP_IRQ6_ATTR_VALUE       0x16U
#define EXP_IRQ7_ATTR_VALUE       0x17U
#define EXP_IRQ8_ATTR_VALUE       0x18U
#define EXP_IRQ9_ATTR_VALUE       0x19U
#define EXP_IRQ10_ATTR_VALUE      0x1AU
#define EXP_IRQ11_ATTR_VALUE      0x1BU
#define EXP_IRQ12_ATTR_VALUE      0x1CU
#define EXP_IRQ13_ATTR_VALUE      0x1DU
#define EXP_IRQ14_ATTR_VALUE      0x1EU
#define EXP_IRQ15_ATTR_VALUE      0x1FU


int main(void)
{
    uint32_t actual_attr;


    /* ============================================================
     * Test Start
     * ============================================================ */

    info_print(0x0000);


    /* ============================================================
     * Enable Global Machine Interrupt
     *
     * mstatus.MIE = 1
     * ============================================================ */

    asm volatile (
        "li t0, 0x8\n"
        "csrrs x0, mstatus, t0\n"
    );


    /* ============================================================
     * Enable Machine External Interrupt
     *
     * Keep the existing configuration.
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
        150994944U
    );

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR,
        585U
    );


    info_print(0x2000);


    /* ============================================================
     * IRQ0 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x10
     * ============================================================ */

    actual_attr = mmio_read(IRQ0_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ0_ATTR_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * IRQ1 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x11
     * ============================================================ */

    actual_attr = mmio_read(IRQ1_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ1_ATTR_VALUE)
        error_print(1);
    else
        info_print(2);


    /* ============================================================
     * IRQ2 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x12
     * ============================================================ */

    actual_attr = mmio_read(IRQ2_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ2_ATTR_VALUE)
        error_print(2);
    else
        info_print(3);


    /* ============================================================
     * IRQ3 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x13
     * ============================================================ */

    actual_attr = mmio_read(IRQ3_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ3_ATTR_VALUE)
        error_print(3);
    else
        info_print(4);


    /* ============================================================
     * IRQ4 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x14
     * ============================================================ */

    actual_attr = mmio_read(IRQ4_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ4_ATTR_VALUE)
        error_print(4);
    else
        info_print(5);


    /* ============================================================
     * IRQ5 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x15
     * ============================================================ */

    actual_attr = mmio_read(IRQ5_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ5_ATTR_VALUE)
        error_print(5);
    else
        info_print(6);


    /* ============================================================
     * IRQ6 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x16
     * ============================================================ */

    actual_attr = mmio_read(IRQ6_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ6_ATTR_VALUE)
        error_print(6);
    else
        info_print(7);


    /* ============================================================
     * IRQ7 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x17
     * ============================================================ */

    actual_attr = mmio_read(IRQ7_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ7_ATTR_VALUE)
        error_print(7);
    else
        info_print(8);


    /* ============================================================
     * IRQ8 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x18
     * ============================================================ */

    actual_attr = mmio_read(IRQ8_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ8_ATTR_VALUE)
        error_print(8);
    else
        info_print(9);


    /* ============================================================
     * IRQ9 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x19
     * ============================================================ */

    actual_attr = mmio_read(IRQ9_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ9_ATTR_VALUE)
        error_print(9);
    else
        info_print(10);


    /* ============================================================
     * IRQ10 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x1A
     *
     * This IRQ will also be used for interrupt-service check.
     * ============================================================ */

    actual_attr = mmio_read(IRQ10_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ10_ATTR_VALUE)
        error_print(10);
    else
        info_print(11);


    /* ============================================================
     * IRQ11 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x1B
     * ============================================================ */

    actual_attr = mmio_read(IRQ11_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ11_ATTR_VALUE)
        error_print(11);
    else
        info_print(12);


    /* ============================================================
     * IRQ12 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x1C
     * ============================================================ */

    actual_attr = mmio_read(IRQ12_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ12_ATTR_VALUE)
        error_print(12);
    else
        info_print(13);


    /* ============================================================
     * IRQ13 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x1D
     * ============================================================ */

    actual_attr = mmio_read(IRQ13_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ13_ATTR_VALUE)
        error_print(13);
    else
        info_print(14);


    /* ============================================================
     * IRQ14 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x1E
     * ============================================================ */

    actual_attr = mmio_read(IRQ14_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ14_ATTR_VALUE)
        error_print(14);
    else
        info_print(15);


    /* ============================================================
     * IRQ15 ATTRIBUTE
     *
     * RO
     *
     * Expected = 0x1F
     * ============================================================ */

    actual_attr = mmio_read(IRQ15_ATTR_REG_ADDR);

    if (actual_attr != EXP_IRQ15_ATTR_VALUE)
        error_print(15);
    else
        info_print(16);


    /* ============================================================
     * Configure IRQ10 for interrupt-service check
     *
     * ENABLE = 1
     * ATTR   = RO, no write
     * CTL    = programmable
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        0x00000001U
    );

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        0x000000D3U
    );


    info_print(0x2222);


    /* ============================================================
     * Inform SV that configuration is complete
     *
     * SV should generate IRQ10.
     * ============================================================ */

    send_handshake_to_sv(1);


    info_print(0x3000);


    /*
     * ============================================================
     * IRQ10 SERVICE
     *
     * CPU should enter irq10_handler().
     *
     * The handler should perform EOI/ACK according to the
     * interrupt-controller implementation.
     *
     * After returning from the handler, execution continues here.
     * ============================================================
     */


    /* ============================================================
     * Read IRQ10 ATTRIBUTE after interrupt service
     *
     * Expected value must still be 0x1A.
     *
     * This verifies that interrupt service did not corrupt
     * the attribute register.
     * ============================================================ */

    actual_attr = mmio_read(
        IRQ10_ATTR_REG_ADDR
    );


    if (actual_attr != EXP_IRQ10_ATTR_VALUE)
        error_print(17);
    else
        info_print(17);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x7007);

}
