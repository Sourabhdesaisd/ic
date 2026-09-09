#include "peripheral.h"

#define CHECK_REG(addr, expected, error_id, pass_id) \
do {                                                 \
    actual = mmio_read(addr);                        \
    if (actual != (expected))                        \
        error_print(error_id);                      \
    else                                             \
        info_print(pass_id);                        \
} while (0)


int main()
{
    uint32_t actual;

    info_print(0x00000);

    /* ============================================================
     *
     * SoC Reset Initialization
     *
     * Interrupt Controller is NOT reset by SoC reset.
     *
     * Therefore these are the expected INITIAL values after
     * SoC reset/release.
     * ============================================================ */


    /* ============================================================
     * SoC Interrupt Controller Registers
     * ============================================================ */

    /* soc_cfg */
    CHECK_REG(
        INT_CFG_REG,
        0x07U,
        0,
        1
    );

    /* soc_info */
    CHECK_REG(
        INT_INFO_REG,
        0x10U,
        1,
        2
    );

    /* soc_nxtp_int */
    CHECK_REG(
        INT_NXTP_REG,
        0x10U,
        2,
        3
    );

    /* soc_ack */
    CHECK_REG(
        INT_ACK_REG,
        0x00U,
        3,
        4
    );

    /* soc_eoi */
    CHECK_REG(
        INT_EOI_REG,
        0x00U,
        4,
        5
    );


    /* ============================================================
     * IRQ0
     * ============================================================ */

    CHECK_REG(IRQ0_PENDING_REG_ADDR, 0x00U,  10, 11);
    CHECK_REG(IRQ0_ENABLE_REG_ADDR,  0x01U,  12, 13);
    CHECK_REG(IRQ0_ATTR_REG_ADDR,    0x10U,  14, 15);
    CHECK_REG(IRQ0_CTL_REG_ADDR,     0xFFU, 16, 17);


    /* ============================================================
     * IRQ1
     * ============================================================ */

    CHECK_REG(IRQ1_PENDING_REG_ADDR, 0x00U,  18, 19);
    CHECK_REG(IRQ1_ENABLE_REG_ADDR,  0x01U,  20, 21);
    CHECK_REG(IRQ1_ATTR_REG_ADDR,    0x11U,  22, 23);
    CHECK_REG(IRQ1_CTL_REG_ADDR,     0xFFU, 24, 25);


    /* ============================================================
     * IRQ2
     * ============================================================ */

    CHECK_REG(IRQ2_PENDING_REG_ADDR, 0x00U,  26, 27);
    CHECK_REG(IRQ2_ENABLE_REG_ADDR,  0x01U,  28, 29);
    CHECK_REG(IRQ2_ATTR_REG_ADDR,    0x12U,  30, 31);
    CHECK_REG(IRQ2_CTL_REG_ADDR,     0xFFU, 32, 33);


    /* ============================================================
     * IRQ3
     * ============================================================ */

    CHECK_REG(IRQ3_PENDING_REG_ADDR, 0x00U,  34, 35);
    CHECK_REG(IRQ3_ENABLE_REG_ADDR,  0x01U,  36, 37);
    CHECK_REG(IRQ3_ATTR_REG_ADDR,    0x13U,  38, 39);
    CHECK_REG(IRQ3_CTL_REG_ADDR,     0xFFU, 40, 41);


    /* ============================================================
     * IRQ4
     * ============================================================ */

    CHECK_REG(IRQ4_PENDING_REG_ADDR, 0x00U,  42, 43);
    CHECK_REG(IRQ4_ENABLE_REG_ADDR,  0x01U,  44, 45);
    CHECK_REG(IRQ4_ATTR_REG_ADDR,    0x14U,  46, 47);
    CHECK_REG(IRQ4_CTL_REG_ADDR,     0xFFU, 48, 49);


    /* ============================================================
     * IRQ5
     * ============================================================ */

    CHECK_REG(IRQ5_PENDING_REG_ADDR, 0x00U,  50, 51);
    CHECK_REG(IRQ5_ENABLE_REG_ADDR,  0x01U,  52, 53);
    CHECK_REG(IRQ5_ATTR_REG_ADDR,    0x15U,  54, 55);
    CHECK_REG(IRQ5_CTL_REG_ADDR,     0xFFU, 56, 57);


    /* ============================================================
     * IRQ6
     * ============================================================ */

    CHECK_REG(IRQ6_PENDING_REG_ADDR, 0x00U,  58, 59);
    CHECK_REG(IRQ6_ENABLE_REG_ADDR,  0x01U,  60, 61);
    CHECK_REG(IRQ6_ATTR_REG_ADDR,    0x16U,  62, 63);
    CHECK_REG(IRQ6_CTL_REG_ADDR,     0xFFU, 64, 65);


    /* ============================================================
     * IRQ7
     * ============================================================ */

    CHECK_REG(IRQ7_PENDING_REG_ADDR, 0x00U,  66, 67);
    CHECK_REG(IRQ7_ENABLE_REG_ADDR,  0x01U,  68, 69);
    CHECK_REG(IRQ7_ATTR_REG_ADDR,    0x17U,  70, 71);
    CHECK_REG(IRQ7_CTL_REG_ADDR,     0xFFU, 72, 73);


    /* ============================================================
     * IRQ8
     * ============================================================ */

    CHECK_REG(IRQ8_PENDING_REG_ADDR, 0x00U,  74, 75);
    CHECK_REG(IRQ8_ENABLE_REG_ADDR,  0x01U,  76, 77);
    CHECK_REG(IRQ8_ATTR_REG_ADDR,    0x18U,  78, 79);
    CHECK_REG(IRQ8_CTL_REG_ADDR,     0xFFU, 80, 81);


    /* ============================================================
     * IRQ9
     * ============================================================ */

    CHECK_REG(IRQ9_PENDING_REG_ADDR, 0x00U,  82, 83);
    CHECK_REG(IRQ9_ENABLE_REG_ADDR,  0x01U,  84, 85);
    CHECK_REG(IRQ9_ATTR_REG_ADDR,    0x19U,  86, 87);
    CHECK_REG(IRQ9_CTL_REG_ADDR,     0xFFU, 88, 89);


    /* ============================================================
     * IRQ10
     * ============================================================ */

    CHECK_REG(IRQ10_PENDING_REG_ADDR, 0x00U,  90, 91);
    CHECK_REG(IRQ10_ENABLE_REG_ADDR,  0x00U,  92, 93);
    CHECK_REG(IRQ10_ATTR_REG_ADDR,    0x1AU,  94, 95);
    CHECK_REG(IRQ10_CTL_REG_ADDR,     0x0FU,  96, 97);


    /* ============================================================
     * IRQ11
     * ============================================================ */

    CHECK_REG(IRQ11_PENDING_REG_ADDR, 0x00U,  98, 99);
    CHECK_REG(IRQ11_ENABLE_REG_ADDR,  0x00U, 100, 101);
    CHECK_REG(IRQ11_ATTR_REG_ADDR,    0x1BU, 102, 103);
    CHECK_REG(IRQ11_CTL_REG_ADDR,     0x0FU, 104, 105);


    /* ============================================================
     * IRQ12
     * ============================================================ */

    CHECK_REG(IRQ12_PENDING_REG_ADDR, 0x00U, 106, 107);
    CHECK_REG(IRQ12_ENABLE_REG_ADDR,  0x00U, 108, 109);
    CHECK_REG(IRQ12_ATTR_REG_ADDR,    0x1CU, 110, 111);
    CHECK_REG(IRQ12_CTL_REG_ADDR,     0x0FU, 112, 113);


    /* ============================================================
     * IRQ13
     * ============================================================ */

    CHECK_REG(IRQ13_PENDING_REG_ADDR, 0x00U, 114, 115);
    CHECK_REG(IRQ13_ENABLE_REG_ADDR,  0x00U, 116, 117);
    CHECK_REG(IRQ13_ATTR_REG_ADDR,    0x1DU, 118, 119);
    CHECK_REG(IRQ13_CTL_REG_ADDR,     0x0FU, 120, 121);


    /* ============================================================
     * IRQ14
     * ============================================================ */

    CHECK_REG(IRQ14_PENDING_REG_ADDR, 0x00U, 122, 123);
    CHECK_REG(IRQ14_ENABLE_REG_ADDR,  0x00U, 124, 125);
    CHECK_REG(IRQ14_ATTR_REG_ADDR,    0x1EU, 126, 127);
    CHECK_REG(IRQ14_CTL_REG_ADDR,     0x0FU, 128, 129);


    /* ============================================================
     * IRQ15
     * ============================================================ */

    CHECK_REG(IRQ15_PENDING_REG_ADDR, 0x00U, 130, 131);
    CHECK_REG(IRQ15_ENABLE_REG_ADDR,  0x00U, 132, 133);
    CHECK_REG(IRQ15_ATTR_REG_ADDR,    0x1FU, 134, 135);
    CHECK_REG(IRQ15_CTL_REG_ADDR,     0x0FU, 136, 137);


    /* ============================================================
     * ============================================================ */

    info_print(0x2222);

    send_handshake_to_sv(1);

    info_print(0x3333);

    return 0;
}
