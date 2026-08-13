#include "peripheral.h"

int main()
{
    info_print(0x00000);
    
    uint32_t int_info;
    uint32_t nxtp_value;
    uint32_t mepc_value;
    uint32_t irq10_handler_seen;

    irq10_handler_seen = 0;

    info_print(0x1000);
 
    //-------------------------------------------------------
    // Enable Global Interrupt (mstatus.MIE = bit3)
    //-------------------------------------------------------
    asm volatile (
        "li   t0, 0x8\n"
        "csrrs x0, mstatus, t0\n"
    );

    //-------------------------------------------------------
    // Enable Machine External Interrupt (mie.MEIE = bit11)
    //-------------------------------------------------------
    asm volatile (
        "li   t0, 0x800\n"
        "csrrs x0, mie, t0\n"
    );
    
    info_print(0x1111);

    ///Enable GPIO 8 9 32'b 00001001 00000000 00000000 00000000 ----  150994944  in decimal 
    //8----  00000000 00000000 00000000 00100000  ---16
    //9----  00000000 00000000 00000000 00000100   ---4 
    //10---- 00100000 00000000 00000000 00000000  --- 32000
    //11---  00000100 00000000 00000000 00000000   --- 4000
    //12--   00000000 10000000 00000000 00000000  --- 12800
    //13 --- 00000000 00010000 00000000 00000000   --- 1600
    //
    //
    //////gpio 10 11 12 13 00000000000000000000001001001001  ------ 585  in decimal   
    //
    //
    mmio_write(GPIO_BASE_ADDR + GPIO_PINMUX0_ADDR, 150994944); 

    mmio_write(GPIO_BASE_ADDR + GPIO_PINMUX1_ADDR, 585 ); 
    

    //--------------------------------------------------
    // Enable IRQ10
    //--------------------------------------------------
    mmio_write(IRQ10_ENABLE_REG_ADDR, 0x00000001);

    //--------------------------------------------------
    // Program IRQ10 attributes
    //--------------------------------------------------
    mmio_write(IRQ10_ATTR_REG_ADDR, 0x00000000);

    //--------------------------------------------------
    // Program IRQ10 control
    //--------------------------------------------------
    mmio_write(IRQ10_CTL_REG_ADDR, 0x000000D3);

    info_print(0x2222);


     /*
     * ==========================================================
     * READ INTERRUPT CONTROLLER INFORMATION
     * ==========================================================
     *
     * Optional debug information.
     */

    int_info = mmio_read(INT_INFO_REG);

    info_print(int_info);


    /*
     * Read next pending/selected interrupt.
     */
    nxtp_value = mmio_read(INT_NXTP_REG);

    info_print(nxtp_value);


    //--------------------------------------------------
    // Inform SV that configuration is complete
    //--------------------------------------------------
    send_handshake_to_sv(1);

    info_print(0x3333);

}
