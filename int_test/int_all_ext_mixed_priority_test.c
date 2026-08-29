#include "peripheral.h"

/* ============================================================
 * Expected GPIO PINMUX values
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE     150994944U
#define EXP_GPIO_PINMUX1_VALUE     585U


/* ============================================================
 * IRQ10 Expected Values
 * Priority = 5
 * ============================================================ */

#define EXP_IRQ10_ENABLE_VALUE     0x00000001U
#define EXP_IRQ10_ATTR_VALUE       0x00000000U
#define EXP_IRQ10_CTL_VALUE        0x00000053U


/* ============================================================
 * IRQ11 Expected Values
 * Priority = 5
 * ============================================================ */

#define EXP_IRQ11_ENABLE_VALUE     0x00000001U
#define EXP_IRQ11_ATTR_VALUE       0x00000000U
#define EXP_IRQ11_CTL_VALUE        0x00000053U


/* ============================================================
 * IRQ12 Expected Values
 * Priority = 10
 * ============================================================ */

#define EXP_IRQ12_ENABLE_VALUE     0x00000001U
#define EXP_IRQ12_ATTR_VALUE       0x00000000U
#define EXP_IRQ12_CTL_VALUE        0x000000A3U


/* ============================================================
 * IRQ13 Expected Values
 * Priority = 10
 * ============================================================ */

#define EXP_IRQ13_ENABLE_VALUE     0x00000001U
#define EXP_IRQ13_ATTR_VALUE       0x00000000U
#define EXP_IRQ13_CTL_VALUE        0x000000A3U


/* ============================================================
 * IRQ14 Expected Values
 * Priority = 2
 * ============================================================ */

#define EXP_IRQ14_ENABLE_VALUE     0x00000001U
#define EXP_IRQ14_ATTR_VALUE       0x00000000U
#define EXP_IRQ14_CTL_VALUE        0x00000023U


/* ============================================================
 * IRQ15 Expected Values
 * Priority = 2
 * ============================================================ */

#define EXP_IRQ15_ENABLE_VALUE     0x00000001U
#define EXP_IRQ15_ATTR_VALUE       0x00000000U
#define EXP_IRQ15_CTL_VALUE        0x00000023U


int main()
{
    uint32_t actual_data;

    info_print(0x0000);


    /* ============================================================
     * Enable Global Machine Interrupt
     * ============================================================ */

    asm volatile (
        "li t0, 0x8\n"
        "csrrs x0, mstatus, t0\n"
    );


    /* ============================================================
     * Enable Machine External Interrupt
     * ============================================================ */

    asm volatile (
        "li t0, 0xFC000000\n"
        "csrrs x0, mie, t0\n"
    );

    info_print(0x1111);


    /* ============================================================
     * GPIO PINMUX0
     * ============================================================ */

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR,
        EXP_GPIO_PINMUX0_VALUE
    );

    actual_data =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR);

    if (actual_data != EXP_GPIO_PINMUX0_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * GPIO PINMUX1
     * ============================================================ */

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR,
        EXP_GPIO_PINMUX1_VALUE
    );

    actual_data =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR);

    if (actual_data != EXP_GPIO_PINMUX1_VALUE)
        error_print(1);
    else
        info_print(2);


    /* ============================================================
     * IRQ10 ENABLE
     * ============================================================ */

    mmio_write(
        IRQ10_ENABLE_REG_ADDR,
        EXP_IRQ10_ENABLE_VALUE
    );
    for (int i = 0; i < 10000; i++);

    actual_data = mmio_read(IRQ10_ENABLE_REG_ADDR);

    if (actual_data != EXP_IRQ10_ENABLE_VALUE)
        error_print(2);
    else
        info_print(3);


    

    /* IRQ10 CONTROL */

    mmio_write(
        IRQ10_CTL_REG_ADDR,
        EXP_IRQ10_CTL_VALUE
    );
    for (int i = 0; i < 5000; i++);

    actual_data = mmio_read(IRQ10_CTL_REG_ADDR);

    if (actual_data != EXP_IRQ10_CTL_VALUE)
        error_print(4);
    else
        info_print(5);


    /* ============================================================
     * IRQ11 ENABLE
     * ============================================================ */

    mmio_write(
        IRQ11_ENABLE_REG_ADDR,
        EXP_IRQ11_ENABLE_VALUE
    );
    for (int i = 0; i < 5000; i++);

    actual_data = mmio_read(IRQ11_ENABLE_REG_ADDR);

    if (actual_data != EXP_IRQ11_ENABLE_VALUE)
        error_print(5);
    else
        info_print(6);


    

    /* IRQ11 CONTROL */

    mmio_write(
        IRQ11_CTL_REG_ADDR,
        EXP_IRQ11_CTL_VALUE
    );
    for (int i = 0; i < 5000; i++);

    actual_data = mmio_read(IRQ11_CTL_REG_ADDR);

    if (actual_data != EXP_IRQ11_CTL_VALUE)
        error_print(7);
    else
        info_print(8);


    /* ============================================================
     * IRQ12 ENABLE
     * ============================================================ */

    mmio_write(
        IRQ12_ENABLE_REG_ADDR,
        EXP_IRQ12_ENABLE_VALUE
    );
    for (int i = 0; i < 5000; i++);

    actual_data = mmio_read(IRQ12_ENABLE_REG_ADDR);

    if (actual_data != EXP_IRQ12_ENABLE_VALUE)
        error_print(8);
    else
        info_print(9);


    
    /* IRQ12 CONTROL */

    mmio_write(
        IRQ12_CTL_REG_ADDR,
        EXP_IRQ12_CTL_VALUE
    );
    for (int i = 0; i < 5000; i++);

    actual_data = mmio_read(IRQ12_CTL_REG_ADDR);

    if (actual_data != EXP_IRQ12_CTL_VALUE)
        error_print(10);
    else
        info_print(11);


    /* ============================================================
     * IRQ13 ENABLE
     * ============================================================ */

    mmio_write(
        IRQ13_ENABLE_REG_ADDR,
        EXP_IRQ13_ENABLE_VALUE
    );
    for (int i = 0; i < 5000; i++);

    actual_data = mmio_read(IRQ13_ENABLE_REG_ADDR);

    if (actual_data != EXP_IRQ13_ENABLE_VALUE)
        error_print(11);
    else
        info_print(12);


    


    /* IRQ13 CONTROL */

    mmio_write(
        IRQ13_CTL_REG_ADDR,
        EXP_IRQ13_CTL_VALUE
    );
    for (int i = 0; i < 5000; i++);

    actual_data = mmio_read(IRQ13_CTL_REG_ADDR);

    if (actual_data != EXP_IRQ13_CTL_VALUE)
        error_print(13);
    else
        info_print(14);


    /* ============================================================
     * IRQ14 ENABLE
     * ============================================================ */

    mmio_write(
        IRQ14_ENABLE_REG_ADDR,
        EXP_IRQ14_ENABLE_VALUE
    );
    for (int i = 0; i < 5000; i++);

    actual_data = mmio_read(IRQ14_ENABLE_REG_ADDR);

    if (actual_data != EXP_IRQ14_ENABLE_VALUE)
        error_print(14);
    else
        info_print(15);


    

    /* IRQ14 CONTROL */

    mmio_write(
        IRQ14_CTL_REG_ADDR,
        EXP_IRQ14_CTL_VALUE
    );
    for (int i = 0; i < 5000; i++);

    actual_data = mmio_read(IRQ14_CTL_REG_ADDR);

    if (actual_data != EXP_IRQ14_CTL_VALUE)
        error_print(16);
    else
        info_print(17);


    /* ============================================================
     * IRQ15 ENABLE
     * ============================================================ */

    mmio_write(
        IRQ15_ENABLE_REG_ADDR,
        EXP_IRQ15_ENABLE_VALUE
    );
    for (int i = 0; i < 5000; i++);

    actual_data = mmio_read(IRQ15_ENABLE_REG_ADDR);

    if (actual_data != EXP_IRQ15_ENABLE_VALUE)
        error_print(17);
    else
        info_print(18);


    

    /* IRQ15 CONTROL */

    mmio_write(
        IRQ15_CTL_REG_ADDR,
        EXP_IRQ15_CTL_VALUE
    );
    for (int i = 0; i < 5000; i++);

    actual_data = mmio_read(IRQ15_CTL_REG_ADDR);

    if (actual_data != EXP_IRQ15_CTL_VALUE)
        error_print(19);
    else
        info_print(20);


    /* ============================================================
     * All configuration checks completed successfully
     * ============================================================ */

    info_print(0x2222);



    send_handshake_to_sv(1);


    info_print(0x3333);


    /* Test PASS */

    info_print(0x9000);

}
