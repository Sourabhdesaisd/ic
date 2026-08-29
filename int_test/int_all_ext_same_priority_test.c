#include "peripheral.h"

/* ============================================================
 * Expected GPIO PINMUX values
 * ============================================================ */

#define EXP_GPIO_PINMUX0_VALUE     150994944U
#define EXP_GPIO_PINMUX1_VALUE     585U


/* ============================================================
 * Expected IRQ register values
 * ============================================================ */

#define EXP_IRQ_ENABLE_VALUE       0x00000001U
#define EXP_IRQ_ATTR_VALUE         0x00000000U
#define EXP_IRQ_CTL_VALUE          0x000000D3U


int main()
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
     * ============================================================ */

    asm volatile (
        "li t0, 0xFC000000\n"
        "csrrs x0, mie, t0\n"
    );

    info_print(0x1111);


    /* ============================================================
     * GPIO PINMUX0 Configuration
     * ============================================================ */

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR,
        EXP_GPIO_PINMUX0_VALUE
    );

    actual_value =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR);

    if (actual_value != EXP_GPIO_PINMUX0_VALUE)
        error_print(0);
    else
        info_print(1);


    /* ============================================================
     * GPIO PINMUX1 Configuration
     * ============================================================ */

    mmio_write(
        GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR,
        EXP_GPIO_PINMUX1_VALUE
    );

    actual_value =
        mmio_read(GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR);

    if (actual_value != EXP_GPIO_PINMUX1_VALUE)
        error_print(1);
    else
        info_print(2);


    /* ============================================================
     * IRQ10 Configuration
     * ============================================================ */

    mmio_write(IRQ10_ENABLE_REG_ADDR,
               EXP_IRQ_ENABLE_VALUE);

    actual_value = mmio_read(IRQ10_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(2);
    else
        info_print(3);


   

    mmio_write(IRQ10_CTL_REG_ADDR,
               EXP_IRQ_CTL_VALUE);

    actual_value = mmio_read(IRQ10_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ_CTL_VALUE)
        error_print(4);
    else
        info_print(5);


    /* ============================================================
     * IRQ11 Configuration
     * ============================================================ */

    mmio_write(IRQ11_ENABLE_REG_ADDR,
               EXP_IRQ_ENABLE_VALUE);

    actual_value = mmio_read(IRQ11_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(5);
    else
        info_print(6);


    

    mmio_write(IRQ11_CTL_REG_ADDR,
               EXP_IRQ_CTL_VALUE);

    actual_value = mmio_read(IRQ11_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ_CTL_VALUE)
        error_print(7);
    else
        info_print(8);


    /* ============================================================
     * IRQ12 Configuration
     * ============================================================ */

    mmio_write(IRQ12_ENABLE_REG_ADDR,
               EXP_IRQ_ENABLE_VALUE);

    actual_value = mmio_read(IRQ12_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(8);
    else
        info_print(9);


   

    mmio_write(IRQ12_CTL_REG_ADDR,
               EXP_IRQ_CTL_VALUE);

    actual_value = mmio_read(IRQ12_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ_CTL_VALUE)
        error_print(10);
    else
        info_print(11);


    /* ============================================================
     * IRQ13 Configuration
     * ============================================================ */

    mmio_write(IRQ13_ENABLE_REG_ADDR,
               EXP_IRQ_ENABLE_VALUE);

    actual_value = mmio_read(IRQ13_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(11);
    else
        info_print(12);


    

    mmio_write(IRQ13_CTL_REG_ADDR,
               EXP_IRQ_CTL_VALUE);

    actual_value = mmio_read(IRQ13_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ_CTL_VALUE)
        error_print(13);
    else
        info_print(14);


    /* ============================================================
     * IRQ14 Configuration
     * ============================================================ */

    mmio_write(IRQ14_ENABLE_REG_ADDR,
               EXP_IRQ_ENABLE_VALUE);

    actual_value = mmio_read(IRQ14_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(14);
    else
        info_print(15);


    

    mmio_write(IRQ14_CTL_REG_ADDR,
               EXP_IRQ_CTL_VALUE);

    actual_value = mmio_read(IRQ14_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ_CTL_VALUE)
        error_print(16);
    else
        info_print(17);


    /* ============================================================
     * IRQ15 Configuration
     * ============================================================ */

    mmio_write(IRQ15_ENABLE_REG_ADDR,
               EXP_IRQ_ENABLE_VALUE);

    actual_value = mmio_read(IRQ15_ENABLE_REG_ADDR);

    if (actual_value != EXP_IRQ_ENABLE_VALUE)
        error_print(17);
    else
        info_print(18);



    mmio_write(IRQ15_CTL_REG_ADDR,
               EXP_IRQ_CTL_VALUE);

    actual_value = mmio_read(IRQ15_CTL_REG_ADDR);

    if (actual_value != EXP_IRQ_CTL_VALUE)
        error_print(19);
    else
        info_print(20);


    /* ============================================================
     * All configuration register checks passed
     *
     * SV/UVM can now generate the required GPIO interrupts.
     * ============================================================ */

    info_print(0x2222);

    send_handshake_to_sv(1);

    info_print(0x3333);


    /* ============================================================
     * Test configuration completed
     * ============================================================ */

}
