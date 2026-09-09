#include "peripheral.h"


/* ============================================================
 * TC004 : Per-IRQ Enable Mask
 *
 * IRQ0 - IRQ9
 *     ENABLE registers are RO.
 *     Interrupt controller is not reset by SoC reset.
 *     Therefore, read the existing value and compare with
 *     the expected initial value.
 *
 * IRQ10 - IRQ15
 *     ENABLE registers are RW.
 *     Test both ENABLE and DISABLE operations.
 *
 * ============================================================ */


/* ============================================================
 * Expected Initial Values
 *
 * Based on Interrupt Controller INITIAL VALUE:
 *
 * IRQ0  ENABLE = 0x01
 * IRQ1  ENABLE = 0x01
 * IRQ2  ENABLE = 0x01
 * IRQ3  ENABLE = 0x01
 * IRQ4  ENABLE = 0x01
 * IRQ5  ENABLE = 0x01
 * IRQ6  ENABLE = 0x01
 * IRQ7  ENABLE = 0x01
 * IRQ8  ENABLE = 0x01
 * IRQ9  ENABLE = 0x01
 *
 * IRQ10-IRQ15 ENABLE = 0x00
 * ============================================================ */

#define EXP_IRQ0_ENABLE_INITIAL     0x01U
#define EXP_IRQ1_ENABLE_INITIAL     0x01U
#define EXP_IRQ2_ENABLE_INITIAL     0x01U
#define EXP_IRQ3_ENABLE_INITIAL     0x01U
#define EXP_IRQ4_ENABLE_INITIAL     0x01U
#define EXP_IRQ5_ENABLE_INITIAL     0x01U
#define EXP_IRQ6_ENABLE_INITIAL     0x01U
#define EXP_IRQ7_ENABLE_INITIAL     0x01U
#define EXP_IRQ8_ENABLE_INITIAL     0x01U
#define EXP_IRQ9_ENABLE_INITIAL     0x01U


/* ============================================================
 * RW IRQ Expected Values
 * ============================================================ */

#define EXP_IRQ_ENABLE              0x01U
#define EXP_IRQ_DISABLE             0x00U


int main()
{
    uint32_t expected_enable;
    uint32_t actual_enable;


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
     * Use the same configuration as your existing interrupt tests.
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
     * IRQ0
     *
     * ENABLE is RO.
     * Read existing value after SoC reset.
     * ============================================================ */

    expected_enable = EXP_IRQ0_ENABLE_INITIAL;

    actual_enable = mmio_read(
        IRQ0_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * IRQ1
     *
     * ENABLE is RO.
     * ============================================================ */

    expected_enable = EXP_IRQ1_ENABLE_INITIAL;

    actual_enable = mmio_read(
        IRQ1_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(1);
    else
        info_print(2);


    /* ============================================================
     * IRQ2
     *
     * ENABLE is RO.
     * ============================================================ */

    expected_enable = EXP_IRQ2_ENABLE_INITIAL;

    actual_enable = mmio_read(
        IRQ2_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(2);
    else
        info_print(3);


    /* ============================================================
     * IRQ3
     *
     * ENABLE is RO.
     * ============================================================ */

    expected_enable = EXP_IRQ3_ENABLE_INITIAL;

    actual_enable = mmio_read(
        IRQ3_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(3);
    else
        info_print(4);


    /* ============================================================
     * IRQ4
     *
     * ENABLE is RO.
     * ============================================================ */

    expected_enable = EXP_IRQ4_ENABLE_INITIAL;

    actual_enable = mmio_read(
        IRQ4_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(4);
    else
        info_print(5);


    /* ============================================================
     * IRQ5
     *
     * ENABLE is RO.
     * ============================================================ */

    expected_enable = EXP_IRQ5_ENABLE_INITIAL;

    actual_enable = mmio_read(
        IRQ5_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(5);
    else
        info_print(6);


    /* ============================================================
     * IRQ6
     *
     * ENABLE is RO.
     * ============================================================ */

    expected_enable = EXP_IRQ6_ENABLE_INITIAL;

    actual_enable = mmio_read(
        IRQ6_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(6);
    else
        info_print(7);


    /* ============================================================
     * IRQ7
     *
     * ENABLE is RO.
     * ============================================================ */

    expected_enable = EXP_IRQ7_ENABLE_INITIAL;

    actual_enable = mmio_read(
        IRQ7_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(7);
    else
        info_print(8);


    /* ============================================================
     * IRQ8
     *
     * ENABLE is RO.
     * ============================================================ */

    expected_enable = EXP_IRQ8_ENABLE_INITIAL;

    actual_enable = mmio_read(
        IRQ8_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(8);
    else
        info_print(9);


    /* ============================================================
     * IRQ9
     *
     * ENABLE is RO.
     * Expected initial value = 0x00
     * ============================================================ */

    expected_enable = EXP_IRQ9_ENABLE_INITIAL;

    actual_enable = mmio_read(
        IRQ9_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(9);
    else
        info_print(10);


    /* ============================================================
     * IRQ10
     *
     * ENABLE is RW.
     *
     * First test ENABLE = 1
     * ============================================================ */

    expected_enable = EXP_IRQ_ENABLE;

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(10);
    else
        info_print(11);


    /* ============================================================
     * IRQ10
     *
     * Test DISABLE = 0
     * ============================================================ */

    expected_enable = EXP_IRQ_DISABLE;

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ10_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(11);
    else
        info_print(12);


    /* ============================================================
     * IRQ11
     *
     * ENABLE = 1
     * ============================================================ */

    expected_enable = EXP_IRQ_ENABLE;

    mmio_write(
        IRQ11_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ11_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(12);
    else
        info_print(13);


    /* ============================================================
     * IRQ11
     *
     * DISABLE = 0
     * ============================================================ */

    expected_enable = EXP_IRQ_DISABLE;

    mmio_write(
        IRQ11_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ11_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(13);
    else
        info_print(14);


    /* ============================================================
     * IRQ12
     *
     * ENABLE = 1
     * ============================================================ */

    expected_enable = EXP_IRQ_ENABLE;

    mmio_write(
        IRQ12_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ12_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(14);
    else
        info_print(15);


    /* ============================================================
     * IRQ12
     *
     * DISABLE = 0
     * ============================================================ */

    expected_enable = EXP_IRQ_DISABLE;

    mmio_write(
        IRQ12_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ12_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(15);
    else
        info_print(16);


    /* ============================================================
     * IRQ13
     *
     * ENABLE = 1
     * ============================================================ */

    expected_enable = EXP_IRQ_ENABLE;

    mmio_write(
        IRQ13_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ13_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(16);
    else
        info_print(17);


    /* ============================================================
     * IRQ13
     *
     * DISABLE = 0
     * ============================================================ */

    expected_enable = EXP_IRQ_DISABLE;

    mmio_write(
        IRQ13_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ13_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(17);
    else
        info_print(18);


    /* ============================================================
     * IRQ14
     *
     * ENABLE = 1
     * ============================================================ */

    expected_enable = EXP_IRQ_ENABLE;

    mmio_write(
        IRQ14_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ14_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(18);
    else
        info_print(19);


    /* ============================================================
     * IRQ14
     *
     * DISABLE = 0
     * ============================================================ */

    expected_enable = EXP_IRQ_DISABLE;

    mmio_write(
        IRQ14_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ14_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(19);
    else
        info_print(20);


    /* ============================================================
     * IRQ15
     *
     * ENABLE = 1
     * ============================================================ */

    expected_enable = EXP_IRQ_ENABLE;

    mmio_write(
        IRQ15_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ15_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(20);
    else
        info_print(21);


    /* ============================================================
     * IRQ15
     *
     * DISABLE = 0
     * ============================================================ */

    expected_enable = EXP_IRQ_DISABLE;

    mmio_write(
        IRQ15_ENABLE_REG_ADDR,
        expected_enable
    );

    actual_enable = mmio_read(
        IRQ15_ENABLE_REG_ADDR
    );

    if (actual_enable != expected_enable)
        error_print(21);
    else
        info_print(22);


    /* ============================================================
     * Test Complete
     * ============================================================ */

    info_print(0x2222);

    send_handshake_to_sv(1);

    info_print(0x3333);

}
