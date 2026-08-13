#include "peripheral.h"

int main()
{
    
    uint32_t satp_val = 0x80000090;
	uint32_t satp_rd;

    
    info_print(0x00000);
    
    
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

    ///load pte through jtag test 
    

   
   	asm volatile("csrrw %0, satp, %1" 
			:"=r"(satp_rd)
			: "r"(satp_val)
		);


    info_print(0x2222);
    

    mmio_write(PTE_BASE_ADDR + 8 , 13);

    ////for fault and permoisiion fault write dta to pte   ints / mem_page_fault=0  
    //mem_read_permission_fault=7  mem_write_permission_fault = 11   instruction_execute_permission_fault=13  
    

    send_handshake_to_sv(1);

    info_print(0x3333);

}
