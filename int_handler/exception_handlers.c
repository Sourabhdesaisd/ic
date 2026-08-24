//==============================================================================
//========================================================
// File        : exception_handlers.c
//========================================================
// Company     : Kyros-Semi Pvt Ltd.
// Project     : Pinaka SoC Verification
// Description : List of exception handlers
// 
// Author      : Ganesh K S(ganesh.ks@kyros-semi.com)
// Created On  : 29-May-2026
//
// Copyright (c) 2026 Kyros-Semi Pvt Ltd
// Confidential Proprietary Information
//==============================================================================



#include <stdint.h>


//---------------------------------------------------------------------
/*
 * IRQ0: Watchdog Timer interrupt.
 *
 * Interrupt source:
 *     WDT timeout
 *
 * Expected SoC connection:
 *     WDT -> ext_int0_i -> Interrupt Controller -> CPU
 *
 * Linker places this handler at:
 *     0x0000_C000
 */

void irq0_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq0_handler"),
                   used,
                   aligned(4)));

void irq0_handler(void)
{
    /*
     * WDT interrupt has reached the CPU.
     *
     * Keep the first version simple.
     * We only prove that the CPU successfully entered
     * the IRQ0 handler.
     */
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));    /*
     * IMPORTANT:
     * Do not add mret here.
     *
     * The GCC:
     *
     *     interrupt("machine")
     *
     * attribute generates the interrupt return sequence.
     */
}

//-------------------------------------------------------------------------
/*
 * IRQ1: PTW Timeout Event.
 *
 * The PTW generates the timeout_event due to delayed/stalled PTE response.
 * CPU directly jumps to 0x0000_C400.
 */
void irq1_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq1_handler"),
                   used,
                   aligned(4)));

void irq1_handler(void)
{
    //jump to the return address to continue test
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));    
}

//-------------------------------------------------------------------------
/*
 * IRQ2: Memory Page Fault.
 *
 * The virtual address does not match any valid data memory. 
 * OR The virtual address points Invalid Data memory Address
 * CPU directly jumps to 0x0000_C800.
 */
void irq2_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq2_handler"),
                   used,
                   aligned(4)));

void irq2_handler(void)
{
    //jump to the return address to continue test
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));    
}

//-------------------------------------------------------------------------
/*
 * IRQ3: Memory Read Permission Fault
 *
 * The Virtual address does not have read permission on any valid data memory.
 * CPU directly jumps to 0x0000_CC00.
 */
void irq3_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq3_handler"),
                   used,
                   aligned(4)));

void irq3_handler(void)
{
    //jump to the return address to continue test
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));    
}

//-------------------------------------------------------------------------
/*
 * IRQ4: Memory Write Permission Fault
 *
 * The Virtual address does not have write permission on any valid data memory.
 * CPU directly jumps to 0x0000_D000.
 */
void irq4_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq4_handler"),
                   used,
                   aligned(4)));

void irq4_handler(void)
{
    //jump to the return address to continue test
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));    
}

//-------------------------------------------------------------------------
/*
 * IRQ5: Data-memory address decode error.
 *
 * The address does not match any valid memory/peripheral slave.
 * CPU directly jumps to 0x0000_D400.
 */
void irq5_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq5_handler"),
                   used,
                   aligned(4)));

void irq5_handler(void)
{
    //jump to the return address to continue test
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));    
}
//---------------------------------------------------------------------------

/*
 * IRQ6: Data-memory slave address decode error.
 *
 * The address selects a valid slave, but the offset inside the
 * slave is reserved or unsupported.
 * CPU directly jumps to 0x0000_D800.
 */
void irq6_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq6_handler"),
                   used,
                   aligned(4)));

void irq6_handler(void)
{
    //jump to the return address to continue test
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));}
//----------------------------------------------------------------------------

//-------------------------------------------------------------------------
/*
 * IRQ7: Instruction Page Faults.
 *
 * The address does not match any valid Instruction memory.
 *  OR The virtual address points Invalid Instruction memory Address
 * CPU directly jumps to 0x0000_DC00.
 */
void irq7_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq7_handler"),
                   used,
                   aligned(4)));

void irq7_handler(void)
{
    //jump to the return address to continue test
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));    
}

//-------------------------------------------------------------------------
/*
 * IRQ8: Instruction Execute Permission Faults
 *
 * The Virtual address does not have execute permission on any valid instruction memory.
 * CPU directly jumps to 0x0000_E000.
 */
void irq8_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq8_handler"),
                   used,
                   aligned(4)));

void irq8_handler(void)
{
    //jump to the return address to continue test
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));    
}



///////
//
void irq9_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq9_handler"),
                   used,
                   aligned(4)));

void irq9_handler(void)
{
    //jump to the return address to continue test
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));    
}







/* ============================================================
 * IRQ10
 *
 * ID      : 26
 * Vector  : 0x0000_E800
 * Source  : GPIO Interrupt 0
 *
 * RTL connection:
 *
 *     gpio_int_ctrl_irq[0]
 *              |
 *              v
 *          ext_int10_i
 * ============================================================ */

void irq10_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq10_handler"),
                   used,
                   aligned(4)));

void irq10_handler(void)
{
   
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));
    /*
     * IRQ10 reached the CPU.
     *
     * IRQ10 architectural interrupt ID = 26.
     */

    /*
     * Simulation marker:
     * proves that PC reached 0x0000_E800
     * and executed this handler.
     */
    //info_print(0xA010);

    /*
     * End Of Interrupt.
     *
     * IRQ10 ID = 26 = 0x1A.
     */
  //  mmio_write(INT_EOI_REG, IRQ10_ID);

    /*
     * Do NOT write mret manually.
     *
     * GCC interrupt("machine") generates the
     * machine interrupt return sequence.
     */
}

/* ============================================================
 * IRQ11
 *
 * ID      : 27
 * Vector  : 0x0000_EC00
 * Source  : GPIO Interrupt 1
 * ============================================================ */

void irq11_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq11_handler"),
                   used,
                   aligned(4)));

void irq11_handler(void)
{
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));
    //info_print(0xA011);

    /*
     * GPIO IRQ1 source clear to be added after
     * GPIO register definition is confirmed.
     */
}


/* ============================================================
 * IRQ12
 *
 * ID      : 28
 * Vector  : 0x0000_F000
 * Source  : GPIO Interrupt 2
 * ============================================================ */

void irq12_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq12_handler"),
                   used,
                   aligned(4)));

void irq12_handler(void)
{
   unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));
    // info_print(0xA012);

    /*
     * GPIO IRQ2 source clear to be added after
     * GPIO register definition is confirmed.
     */
}


/* ============================================================
 * IRQ13
 *
 * ID      : 29
 * Vector  : 0x0000_F400
 * Source  : GPIO Interrupt 3
 * ============================================================ */

void irq13_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq13_handler"),
                   used,
                   aligned(4)));

void irq13_handler(void)
{
  
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));
    // info_print(0xA013);

    /*
     * GPIO IRQ3 source clear to be added after
     * GPIO register definition is confirmed.
     */
}


/* ============================================================
 * IRQ14
 *
 * ID      : 30
 * Vector  : 0x0000_F800
 * Source  : GPIO Interrupt 4
 * ============================================================ */

void irq14_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq14_handler"),
                   used,
                   aligned(4)));

void irq14_handler(void)
{
   
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));
    // info_print(0xA014);

    /*
     * GPIO IRQ4 source clear to be added after
     * GPIO register definition is confirmed.
     */
}


/* ============================================================
 * IRQ15
 *
 * ID      : 31
 * Vector  : 0x0000_FC00
 * Source  : GPIO Interrupt 5
 * ============================================================ */

void irq15_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq15_handler"),
                   used,
                   aligned(4)));

void irq15_handler(void)
{
   
    unsigned int mepc;

    asm volatile ("csrr %0, mepc" : "=r"(mepc));

    mepc += 4;

    asm volatile ("csrw mepc, %0" :: "r"(mepc));

    // info_print(0xA015);

    /*
     * GPIO IRQ5 source clear to be added after
     * GPIO register definition is confirmed.
     */
}


