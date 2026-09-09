//========================================================
// File        : soc_mmu_itlb_test.c
//========================================================
// Company     : Kyros-Semi Pvt Ltd.
// Project     : Pinaka SoC Verification
// Description : MMU Instruction VPN Transaltion test including CSR SATP setup. Also it includes execution permission fault test based on PTE setup.
// 
// Author      : Selvakumar R (selvakumar.r@kyros-semi.com)
// Created On  : 30-June-2026
//
// Copyright (c) 2026 Kyros-Semi Pvt Ltd
// Confidential Proprietary Information
//==============================================================================

#include "peripheral.h"

#define IMEM_START_ADDR  0x00000000
#define IMEM_END_ADDR  	 0x0000FFFF
#define PAGE_SIZE 4096

// Macros for CSR Access and Setup
#define WRITE_CSR(csr,wval,rval) 			\
	asm volatile ("csrrw %0," #csr ", %1" :"=r"(rval): "r"(wval))

#define READ_CSR(csr,rval) 		 		\
	asm volatile ("csrrs %0," #csr ", x0" : "=r"(rval))


/*__attribute__((section(".text.page0"), aligned(4096), noinline))
void page0(void){
    asm volatile("nop");
}
*/
/*
__attribute__((section(".text.page0"), aligned(0x1000), noinline))
void page0(void){
    asm volatile("nop");
}
*/

__attribute__((section(".text.page1"), noinline))
void page1(void){
    asm volatile("nop");
}

__attribute__((section(".text.page2"), noinline))
void page2(void){
    asm volatile("nop");
}

__attribute__((section(".text.page3"), noinline))
void page3(void){
    asm volatile("nop");
}

__attribute__((section(".text.page4"), noinline))
void page4(void){
    asm volatile("nop");
}

__attribute__((section(".text.page5"), noinline))
void page5(void){
    asm volatile("nop");
}

__attribute__((section(".text.page6"), noinline))
void page6(void){
    asm volatile("nop");
}

__attribute__((section(".text.page7"), noinline))
void page7(void){
    asm volatile("nop");
}

__attribute__((section(".text.page8"), noinline))
void page8(void){
    asm volatile("nop");
}

__attribute__((section(".text.page9"), noinline))
void page9(void){
    asm volatile("nop");
}

__attribute__((section(".text.page10"), noinline))
void page10(void){
    asm volatile("nop");
}

__attribute__((section(".text.page11"), noinline))
void page11(void){
    asm volatile("nop");
}

/*
__attribute__((section(".text.page12"), noinline))
void page12(void){
    asm volatile("nop");
}

__attribute__((section(".text.page13"), noinline))
void page13(void){
    asm volatile("nop");
}

__attribute__((section(".text.page14"), noinline))
void page14(void){
    asm volatile("nop");
}

__attribute__((section(".text.page15"), noinline))
void page15(void){
    asm volatile("nop");
}
*/
	
int main() {
	volatile uint32_t satp_wval = 0xAA800090; //To Enable MMU
	volatile uint32_t satp_rval;
	volatile uint32_t addr;
	volatile uint32_t *ptr;

	volatile uint32_t rd_data;
	uint32_t read_data;
	uint32_t prefetch_en = 0x01;
	uint32_t timeout_en = 0x02;
	uint32_t both_en = 0x03;

	wait_for_handshake_from_sv();


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


	//Enabling prefetch and timeout
	mmio_write(0x00080000, both_en );

	read_data=mmio_read(0x00080000);
	info_print(read_data);

	//Write
	WRITE_CSR(satp,satp_wval,satp_rval);

	//Read
	READ_CSR(satp,satp_rval);

	//Invalidate/flush TLB
	asm volatile ("sfence.vma");

 //   page3(); // ints page fault
    page6(); // ints page fault

 ///same
 //Invalidate/flush TLB
	asm volatile ("sfence.vma");

	//Disabling prefetch and timeout
	mmio_write(0x00080000, 0x00);

    info_print(0x11);
    

    	//Send handshake to SV
    	send_handshake_to_sv();

        
}

