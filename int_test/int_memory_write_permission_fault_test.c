//========================================================
// File        : soc_mmu_dtlb_test.c
//========================================================
// Company     : Kyros-Semi Pvt Ltd.
// Project     : Pinaka SoC Verification
// Description : MMU Data VPN Transaltion test with load and store including CSR SATP setup. Also to test read and write permission faults based on PTE setup.
// 
// Author      : Selvakumar R (selvakumar.r@kyros-semi.com)
// Created On  : 25-June-2026
//
// Copyright (c) 2026 Kyros-Semi Pvt Ltd
// Confidential Proprietary Information
//==============================================================================

#include "peripheral.h"

#define DMEM_START_ADDR  0x00010000
#define DMEM_END_ADDR  	 0x0001FFFF
#define PAGE_SIZE 4096

// Macros for CSR Access and Setup
#define WRITE_CSR(csr,wval,rval) 			\
	asm volatile ("csrrw %0," #csr ", %1" :"=r"(rval): "r"(wval))

#define READ_CSR(csr,rval) 		 		\
	asm volatile ("csrrs %0," #csr ", x0" : "=r"(rval))

	
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

//	read_data=mmio_read(0x00080000);
//	info_print(read_data);

	//Write
	WRITE_CSR(satp,satp_wval,satp_rval);

	//Read
	READ_CSR(satp,satp_rval);

	//Invalidate TLB
	asm volatile ("sfence.vma");


///write permission fault
//
    
    addr=0x00015000;
	ptr =(volatile uint32_t *)addr;
	*ptr=addr;




	//Disabling prefetch and timeout
	mmio_write(0x00080000, 0x00);

    	//Send handshake to SV
    	send_handshake_to_sv();
	
	return 0;
}

