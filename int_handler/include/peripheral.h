//==============================================================================
//========================================================
// File        : peripheral.h
//========================================================
// Company     : Kyros-Semi Pvt Ltd.
// Project     : Pinaka SoC Verification
// Description : Header file
//
// Author      : Ganesh K S(ganesh.ks@kyros-semi.com)
// Created On  : 29-May-2026
//
// Copyright (c) 2026 Kyros-Semi Pvt Ltd
// Confidential Proprietary Information
//==============================================================================

#include <stdint.h>
#include <stdio.h>
#ifndef PERIPHERAL_H
#define PERIPHERAL_H

#define INFO_PRINT_ADDR 0x0001FFF4
#define ERROR_PRINT_ADDR 0x0001FFF0

#define REG32(addr) (*(volatile unsigned int *)(addr))

//=======================================================
//   Defines
//======================================================
//Handshake defines
#define HANDSHAKE_ADDR 0x0001FFFC
#define HANDSHAKE_CODE 0xC0FFEE

//I2C addresses
#define I2C_BASE_ADDR     0x00084000
//I2C addresses
#define I2C_CTRL_OFFSET        0x00
#define I2C_SLV_ADDR_OFFSET    0x04
#define I2C_REG_ADDR_OFFSET    0x08
#define I2C_DATA_IN_OFFSET     0x0c
#define I2C_DATA_OUT_OFFSET    0x10
#define I2C_STATUS_OFFSET      0x14
#define I2C_CLKDIV_OFFSET      0x18

//SPI addresses
#define SPI_BASE_ADDR     0x00085000
#define SPI_CTRL_ADDR     0x00
#define SPI_TX_ADDR       0x04
#define SPI_STATUS_ADDR   0x08
#define SPI_RX_ADDR       0x0c
#define SPI_CLK_DIV_ADDR  0x10


//UART addresses
#define UART_BASE_ADDR     0x00083000
#define UART_RBR_ADDR      0x00   
#define UART_THR_ADDR      0x00  
#define UART_DLL_ADDR      0x20   
#define UART_DLH_ADDR      0x24   
#define UART_FCR_ADDR      0x08
#define UART_LCR_ADDR      0x0C
#define UART_LSR_ADDR      0x14
#define UART_MDR_ADDR      0x34
#define UART_INVALID_ADDR      0xCF

// LSR bits
#define UART_LSR_DR        (1 << 0)  
#define UART_LSR_THRE      (1 << 5)  
#define UART_LSR_TEMT      (1 << 6) 
#define UART_LSR_OE        (1 << 1)
#define UART_LSR_PE        (1 << 2)
#define UART_LSR_FE        (1 << 3)
#define UART_LSR_BI        (1 << 4)
#define UART_LSR_TX_FULL   (1 << 8)

// LCR bits
#define UART_LCR_DLAB      (1 << 7)
#define UART_LCR_5BIT       0x00
#define UART_LCR_6BIT       0x01
#define UART_LCR_7BIT       0x02
#define UART_LCR_8BIT       0x03
//#define UART_LCR_DLAB	    0x80
#define UART_LCR_STOP1      (0 << 2)
#define UART_LCR_STOP2      (1 << 2)
#define UART_LCR_PARITY_EN  (1 << 3)
#define UART_LCR_ODD_PAR    (0 << 4) 
#define UART_LCR_EVEN_PAR   (1 << 4)
#define UART_LCR_STICK_PAR  (1 << 5)
#define UART_LCR_BREAK_EN   (1 << 6)
#define UART_LCR_BREAK_DIS  0x40

// -- MDR oversampling ----------------------------------------------------------
#define UART_MDR_OSM_16X    (0x00)
#define UART_MDR_OSM_13X    (0x01)

// FCR bits
#define UART_FCR_FIFO_EN    (0x01)
#define UART_FCR_FIFO_DIS    (0x00)
#define UART_FCR_RX_RST     (1 << 1)
#define UART_FCR_TX_RST     (1 << 2)

// Baud divisors  (divisor = clk_hz / (16 * baud))
#define UART_BAUD_DIV_27         27    // ~115200 baud
#define UART_BAUD_DIV_163        163    // ~19200 baud
#define UART_BAUD_DIV_54         54   // ~57600  baud
#define UART_BAUD_DIV_81         81    // ~38400  baud
#define UART_BAUD_DIV_326        326  // ~9600   baud

//-------------------------------------------------------------
// UART HELPER API  implemented in peripheral.c
// Baud rate
void    uart_set_baud   (uint32_t divisor);
 
// Init
void    uart_init       (uint32_t divisor, uint32_t lcr_val, uint32_t fcr_val, uint32_t ndr_val);
void    uart_init_default(void);         // 115200, 8N1, FIFO enabled
 
// TX
void    uart_tx_byte    (uint8_t data);  // polls TX_FULL before write
void    uart_wait_tx_not_full(void);
void    uart_wait_thre  (void);
void    uart_wait_temt  (void);
 
// RX
uint8_t uart_rx_byte    (void);          // polls DR then reads RBR
void    uart_wait_dr    (void);
 
// Register read shortcuts
uint32_t uart_read_lsr  (void);
uint32_t uart_read_lcr  (void);
uint32_t uart_read_dll  (void);
uint32_t uart_read_dlh  (void);
uint32_t uart_read_mdr  (void);
uint32_t uart_read_fcr  (void);

//PTE Memory addresses
#define PTE_BASE_ADDR 	 0x00024000

//=====================================================
// WDT addresses
// WATCHDOG_MIN_ADDRESS = 32'h0008_7000
//=====================================================
#define WDT_BASE_ADDR            0x00087000

#define WDT_CTRL_ADDR            0x000
#define WDT_TIMEOUT_ADDR         0x004
#define WDT_WINDOW_ADDR          0x008
#define WDT_REFRESH_ADDR         0x00C
#define WDT_STATUS_ADDR          0x010
#define WDT_LOCK_ADDR            0x014
#define WDT_COUNT_ADDR           0x018
#define WDT_RESET_CAUSE_ADDR     0x01C
#define WDT_LAST_PC_ADDR         0x020
#define WDT_BOOT_STATUS_ADDR     0x024
#define WDT_RESET_WIDTH_ADDR     0x028

// CTRL bits
#define WDT_CTRL_ENABLE          (1 << 0)
#define WDT_CTRL_RESET_EN        (1 << 1)
#define WDT_CTRL_WINDOW_EN       (1 << 2)
#define WDT_CTRL_DBG_FREEZE_EN   (1 << 3)
#define WDT_CTRL_LOCK_EN         (1 << 4)

// RESET_SCOPE encoding in CTRL[7:6]
#define WDT_SCOPE_CORE           (0 << 6)
#define WDT_SCOPE_CLUSTER        (1 << 6)
#define WDT_SCOPE_SUBSYSTEM      (2 << 6)
#define WDT_SCOPE_SOC            (3 << 6)

// STATUS bits
#define WDT_STATUS_TIMEOUT_FLAG      (1 << 0)
#define WDT_STATUS_WINDOW_VIOLATION  (1 << 1)
#define WDT_STATUS_REFRESH_ERROR     (1 << 2)
#define WDT_STATUS_RESET_ISSUED      (1 << 3)

// BOOT_STATUS bits
#define WDT_BOOT_PREV_RESET_WDT      (1 << 0)
#define WDT_BOOT_RECOVERY_BOOT_REQ   (1 << 1)

// Refresh keys
#define WDT_REFRESH_KEY1         0xA5
#define WDT_REFRESH_KEY2         0x5A

// Lock key
#define WDT_UNLOCK_KEY           0x1ACCE551
#define WDT_LOCK_KEY             0x00000000

//===========================================================
//GPIO0 - GPIO8
//==========================================================
#define GPIO_BASE_ADDR     0x00086000
#define GPIO_PINMUX0_ADDR  0x4C
#define GPIO_PINMUX1_ADDR  0x50

#define PINMUX_PERIPHERAL  0x1

//UART PINMUX CFG
#define UART_PINMUX_CFG  ((PINMUX_PERIPHERAL << 0)  | \
                          (PINMUX_PERIPHERAL << 2)) 


//SPI PINMUX CFG
#define SPI_PINMUX_CFG   ((PINMUX_PERIPHERAL << 4)  | \
                          (PINMUX_PERIPHERAL << 6)  | \
                          (PINMUX_PERIPHERAL << 8) | \
                          (PINMUX_PERIPHERAL << 10))

//I2C PINMUX CFG
#define I2C_PINMUX_CFG   ((PINMUX_PERIPHERAL << 12) | \
                          (PINMUX_PERIPHERAL << 14) | \
                          (PINMUX_PERIPHERAL << 16))
                      





//============================================================
// Interrupt Controller addresses
// MMR REGISTER MIN ADDRESS = 32'h0008_9000
//============================================================

#define INT_BASE_ADDR                 0x00089000

//------------------------------------------------------------
// Global Registers
//------------------------------------------------------------
#define INT_CFG_ADDR                  0x000
#define INT_INFO_ADDR                 0x004
#define INT_NXTP_ADDR                 0x008
#define INT_ACK_ADDR                  0x00C
#define INT_EOI_ADDR                  0x010

//-----------------------------------------------------------
// IRQ0 Registers
//-----------------------------------------------------------
#define IRQ0_PENDING_ADDR             0x014
#define IRQ0_ENABLE_ADDR              0x018
#define IRQ0_ATTR_ADDR                0x01C
#define IRQ0_CTL_ADDR                 0x020

//-----------------------------------------------------------
// IRQ1 Registers
//-----------------------------------------------------------
#define IRQ1_PENDING_ADDR             0x024
#define IRQ1_ENABLE_ADDR              0x028
#define IRQ1_ATTR_ADDR                0x02C
#define IRQ1_CTL_ADDR                 0x030

//-----------------------------------------------------------
// IRQ2 Registers
//-----------------------------------------------------------
#define IRQ2_PENDING_ADDR             0x034
#define IRQ2_ENABLE_ADDR              0x038
#define IRQ2_ATTR_ADDR                0x03C
#define IRQ2_CTL_ADDR                 0x040

//-----------------------------------------------------------
// IRQ3 Registers
//-----------------------------------------------------------
#define IRQ3_PENDING_ADDR             0x044
#define IRQ3_ENABLE_ADDR              0x048
#define IRQ3_ATTR_ADDR                0x04C
#define IRQ3_CTL_ADDR                 0x050

//-----------------------------------------------------------
// IRQ4 Registers
//-----------------------------------------------------------
#define IRQ4_PENDING_ADDR             0x054
#define IRQ4_ENABLE_ADDR              0x058
#define IRQ4_ATTR_ADDR                0x05C
#define IRQ4_CTL_ADDR                 0x060

//-----------------------------------------------------------
// IRQ5 Registers
//-----------------------------------------------------------
#define IRQ5_PENDING_ADDR             0x064
#define IRQ5_ENABLE_ADDR              0x068
#define IRQ5_ATTR_ADDR                0x06C
#define IRQ5_CTL_ADDR                 0x070

//-----------------------------------------------------------
// IRQ6 Registers
//-----------------------------------------------------------
#define IRQ6_PENDING_ADDR             0x074
#define IRQ6_ENABLE_ADDR              0x078
#define IRQ6_ATTR_ADDR                0x07C
#define IRQ6_CTL_ADDR                 0x080

//-----------------------------------------------------------
// IRQ7 Registers
//-----------------------------------------------------------
#define IRQ7_PENDING_ADDR             0x084
#define IRQ7_ENABLE_ADDR              0x088
#define IRQ7_ATTR_ADDR                0x08C
#define IRQ7_CTL_ADDR                 0x090

//-----------------------------------------------------------
// IRQ8 Registers
//-----------------------------------------------------------
#define IRQ8_PENDING_ADDR             0x094
#define IRQ8_ENABLE_ADDR              0x098
#define IRQ8_ATTR_ADDR                0x09C
#define IRQ8_CTL_ADDR                 0x0A0

//-----------------------------------------------------------
// IRQ9 Registers
//-----------------------------------------------------------
#define IRQ9_PENDING_ADDR             0x0A4
#define IRQ9_ENABLE_ADDR              0x0A8
#define IRQ9_ATTR_ADDR                0x0AC
#define IRQ9_CTL_ADDR                 0x0B0

//-----------------------------------------------------------
// IRQ10 Registers
//-----------------------------------------------------------
#define IRQ10_PENDING_ADDR            0x0B4
#define IRQ10_ENABLE_ADDR             0x0B8
#define IRQ10_ATTR_ADDR               0x0BC
#define IRQ10_CTL_ADDR                0x0C0

//-----------------------------------------------------------
// IRQ11 Registers
//-----------------------------------------------------------
#define IRQ11_PENDING_ADDR            0x0C4
#define IRQ11_ENABLE_ADDR             0x0C8
#define IRQ11_ATTR_ADDR               0x0CC
#define IRQ11_CTL_ADDR                0x0D0

//-----------------------------------------------------------
// IRQ12 Registers
//-----------------------------------------------------------
#define IRQ12_PENDING_ADDR            0x0D4
#define IRQ12_ENABLE_ADDR             0x0D8
#define IRQ12_ATTR_ADDR               0x0DC
#define IRQ12_CTL_ADDR                0x0E0

//-----------------------------------------------------------
// IRQ13 Registers
//-----------------------------------------------------------
#define IRQ13_PENDING_ADDR            0x0E4
#define IRQ13_ENABLE_ADDR             0x0E8
#define IRQ13_ATTR_ADDR               0x0EC
#define IRQ13_CTL_ADDR                0x0F0

//-----------------------------------------------------------
// IRQ14 Registers
//-----------------------------------------------------------
#define IRQ14_PENDING_ADDR            0x0F4
#define IRQ14_ENABLE_ADDR             0x0F8
#define IRQ14_ATTR_ADDR               0x0FC
#define IRQ14_CTL_ADDR                0x100

//-----------------------------------------------------------
// IRQ15 Registers
//-----------------------------------------------------------
#define IRQ15_PENDING_ADDR            0x104
#define IRQ15_ENABLE_ADDR             0x108
#define IRQ15_ATTR_ADDR               0x10C
#define IRQ15_CTL_ADDR                0x110


//============================================================
// Interrupt Controller Register Bit Definitions
//============================================================

//------------------------------------------------------------
// INT_CFG Register (0x0000)
//------------------------------------------------------------
#define INT_CFG_ENABLE                 (1 << 0)
#define INT_CFG_DEBUG_ENABLE           (1 << 1)

//------------------------------------------------------------
// INT_INFO Register (0x0004)
//------------------------------------------------------------
#define INT_INFO_NUM_IRQ_MASK          0x000000FF
#define INT_INFO_VERSION_MASK          0x0000FF00

//------------------------------------------------------------
// INT_NXTP Register (0x0008)
//------------------------------------------------------------
#define INT_NXTP_ID_MASK               0x000000FF

//------------------------------------------------------------
// INT_ACK Register (0x000C)
//------------------------------------------------------------
#define INT_ACK_ID_MASK                0x000000FF

//------------------------------------------------------------
// INT_EOI Register (0x0010)
//------------------------------------------------------------
#define INT_EOI_ID_MASK                0x000000FF

//------------------------------------------------------------
// IRQ Control Register (IRQx_CTL)
//------------------------------------------------------------
#define IRQ_PENDING_BIT                (1 << 0)
#define IRQ_ENABLE_BIT                 (1 << 1)
#define IRQ_TRIGGER_LEVEL              (0 << 2)
#define IRQ_TRIGGER_EDGE               (1 << 2)

#define IRQ_POLARITY_LOW               (0 << 3)
#define IRQ_POLARITY_HIGH              (1 << 3)

#define IRQ_PRIORITY_MASK              (0xF << 4)
#define IRQ_PRIORITY_SHIFT             4



//------------------------------------------------------------
// Interrupt IDs
//------------------------------------------------------------
#define IRQ0_ID      16
#define IRQ1_ID      17
#define IRQ2_ID      18
#define IRQ3_ID      19
#define IRQ4_ID      20
#define IRQ5_ID      21
#define IRQ6_ID      22
#define IRQ7_ID      23
#define IRQ8_ID      24
#define IRQ9_ID      25
#define IRQ10_ID     26
#define IRQ11_ID     27
#define IRQ12_ID     28
#define IRQ13_ID     29
#define IRQ14_ID     30
#define IRQ15_ID     31


#define FIRST_IRQ_ID      16
#define LAST_IRQ_ID       31
#define TOTAL_IRQS        16


//============================================================
// Interrupt Controller Field Definitions
//============================================================

//------------------------------------------------------------
// soc_cfg (0x000)
//------------------------------------------------------------
#define INT_CFG_MASK                  0x000000FF
#define INT_CFG_SHIFT                 0

//------------------------------------------------------------
// soc_info (0x004)
//------------------------------------------------------------
#define INT_INFO_MASK                 0x000000FF
#define INT_INFO_SHIFT                0

//------------------------------------------------------------
// soc_nxtp_int (0x008)
//------------------------------------------------------------
#define INT_NXTP_IRQ_ID_MASK          0x000000FF
#define INT_NXTP_IRQ_ID_SHIFT         0

//------------------------------------------------------------
// soc_ack (0x00C)
//------------------------------------------------------------
#define INT_ACK_ID_MASK               0x000000FF
#define INT_ACK_ID_SHIFT              0

//------------------------------------------------------------
// soc_eoi (0x010)
//------------------------------------------------------------
#define INT_EOI_ID_MASK               0x000000FF
#define INT_EOI_ID_SHIFT              0

//------------------------------------------------------------
// IRQ Pending Register
//------------------------------------------------------------
#define IRQ_PENDING_MASK              0x000000FF
#define IRQ_PENDING_SHIFT             0

//------------------------------------------------------------
// IRQ Enable Register
//------------------------------------------------------------
#define IRQ_ENABLE_MASK               0x000000FF
#define IRQ_ENABLE_SHIFT              0

//------------------------------------------------------------
// IRQ Attribute Register
//------------------------------------------------------------
#define IRQ_ATTR_MASK                 0x000000FF
#define IRQ_ATTR_SHIFT                0

//------------------------------------------------------------
// IRQ Control Register
//------------------------------------------------------------
#define IRQ_CTL_MASK                  0x000000FF
#define IRQ_CTL_SHIFT                 0


//============================================================
// Interrupt Controller MMIO Access
//============================================================

#define INT_CFG_REG            (INT_BASE_ADDR + INT_CFG_ADDR)
#define INT_INFO_REG           (INT_BASE_ADDR + INT_INFO_ADDR)
#define INT_NXTP_REG           (INT_BASE_ADDR + INT_NXTP_ADDR)
#define INT_ACK_REG            (INT_BASE_ADDR + INT_ACK_ADDR)
#define INT_EOI_REG            (INT_BASE_ADDR + INT_EOI_ADDR)


//------------------------------------------------------------
// IRQ0 Registers
//------------------------------------------------------------
#define IRQ0_PENDING_REG_ADDR      (INT_BASE_ADDR + IRQ0_PENDING_ADDR)
#define IRQ0_ENABLE_REG_ADDR       (INT_BASE_ADDR + IRQ0_ENABLE_ADDR)
#define IRQ0_ATTR_REG_ADDR         (INT_BASE_ADDR + IRQ0_ATTR_ADDR)
#define IRQ0_CTL_REG_ADDR          (INT_BASE_ADDR + IRQ0_CTL_ADDR)

//------------------------------------------------------------
// IRQ1 Registers
//------------------------------------------------------------
#define IRQ1_PENDING_REG_ADDR      (INT_BASE_ADDR + IRQ1_PENDING_ADDR)
#define IRQ1_ENABLE_REG_ADDR       (INT_BASE_ADDR + IRQ1_ENABLE_ADDR)
#define IRQ1_ATTR_REG_ADDR         (INT_BASE_ADDR + IRQ1_ATTR_ADDR)
#define IRQ1_CTL_REG_ADDR          (INT_BASE_ADDR + IRQ1_CTL_ADDR)

//------------------------------------------------------------
// IRQ2 Registers
//------------------------------------------------------------
#define IRQ2_PENDING_REG_ADDR      (INT_BASE_ADDR + IRQ2_PENDING_ADDR)
#define IRQ2_ENABLE_REG_ADDR       (INT_BASE_ADDR + IRQ2_ENABLE_ADDR)
#define IRQ2_ATTR_REG_ADDR         (INT_BASE_ADDR + IRQ2_ATTR_ADDR)
#define IRQ2_CTL_REG_ADDR          (INT_BASE_ADDR + IRQ2_CTL_ADDR)

//------------------------------------------------------------
// IRQ3 Registers
//------------------------------------------------------------
#define IRQ3_PENDING_REG_ADDR      (INT_BASE_ADDR + IRQ3_PENDING_ADDR)
#define IRQ3_ENABLE_REG_ADDR       (INT_BASE_ADDR + IRQ3_ENABLE_ADDR)
#define IRQ3_ATTR_REG_ADDR         (INT_BASE_ADDR + IRQ3_ATTR_ADDR)
#define IRQ3_CTL_REG_ADDR          (INT_BASE_ADDR + IRQ3_CTL_ADDR)

//------------------------------------------------------------
// IRQ4 Registers
//------------------------------------------------------------
#define IRQ4_PENDING_REG_ADDR      (INT_BASE_ADDR + IRQ4_PENDING_ADDR)
#define IRQ4_ENABLE_REG_ADDR       (INT_BASE_ADDR + IRQ4_ENABLE_ADDR)
#define IRQ4_ATTR_REG_ADDR         (INT_BASE_ADDR + IRQ4_ATTR_ADDR)
#define IRQ4_CTL_REG_ADDR          (INT_BASE_ADDR + IRQ4_CTL_ADDR)

//------------------------------------------------------------
// IRQ5 Registers
//------------------------------------------------------------
#define IRQ5_PENDING_REG_ADDR      (INT_BASE_ADDR + IRQ5_PENDING_ADDR)
#define IRQ5_ENABLE_REG_ADDR       (INT_BASE_ADDR + IRQ5_ENABLE_ADDR)
#define IRQ5_ATTR_REG_ADDR         (INT_BASE_ADDR + IRQ5_ATTR_ADDR)
#define IRQ5_CTL_REG_ADDR          (INT_BASE_ADDR + IRQ5_CTL_ADDR)

//------------------------------------------------------------
// IRQ6 Registers
//------------------------------------------------------------
#define IRQ6_PENDING_REG_ADDR      (INT_BASE_ADDR + IRQ6_PENDING_ADDR)
#define IRQ6_ENABLE_REG_ADDR       (INT_BASE_ADDR + IRQ6_ENABLE_ADDR)
#define IRQ6_ATTR_REG_ADDR         (INT_BASE_ADDR + IRQ6_ATTR_ADDR)
#define IRQ6_CTL_REG_ADDR          (INT_BASE_ADDR + IRQ6_CTL_ADDR)

//------------------------------------------------------------
// IRQ7 Registers
//------------------------------------------------------------
#define IRQ7_PENDING_REG_ADDR      (INT_BASE_ADDR + IRQ7_PENDING_ADDR)
#define IRQ7_ENABLE_REG_ADDR       (INT_BASE_ADDR + IRQ7_ENABLE_ADDR)
#define IRQ7_ATTR_REG_ADDR         (INT_BASE_ADDR + IRQ7_ATTR_ADDR)
#define IRQ7_CTL_REG_ADDR          (INT_BASE_ADDR + IRQ7_CTL_ADDR)

//------------------------------------------------------------
// IRQ8 Registers
//------------------------------------------------------------
#define IRQ8_PENDING_REG_ADDR      (INT_BASE_ADDR + IRQ8_PENDING_ADDR)
#define IRQ8_ENABLE_REG_ADDR       (INT_BASE_ADDR + IRQ8_ENABLE_ADDR)
#define IRQ8_ATTR_REG_ADDR         (INT_BASE_ADDR + IRQ8_ATTR_ADDR)
#define IRQ8_CTL_REG_ADDR          (INT_BASE_ADDR + IRQ8_CTL_ADDR)

//------------------------------------------------------------
// IRQ9 Registers
//------------------------------------------------------------
#define IRQ9_PENDING_REG_ADDR      (INT_BASE_ADDR + IRQ9_PENDING_ADDR)
#define IRQ9_ENABLE_REG_ADDR       (INT_BASE_ADDR + IRQ9_ENABLE_ADDR)
#define IRQ9_ATTR_REG_ADDR         (INT_BASE_ADDR + IRQ9_ATTR_ADDR)
#define IRQ9_CTL_REG_ADDR          (INT_BASE_ADDR + IRQ9_CTL_ADDR)

//------------------------------------------------------------
// IRQ10 Registers
//------------------------------------------------------------
#define IRQ10_PENDING_REG_ADDR     (INT_BASE_ADDR + IRQ10_PENDING_ADDR)
#define IRQ10_ENABLE_REG_ADDR      (INT_BASE_ADDR + IRQ10_ENABLE_ADDR)
#define IRQ10_ATTR_REG_ADDR        (INT_BASE_ADDR + IRQ10_ATTR_ADDR)
#define IRQ10_CTL_REG_ADDR         (INT_BASE_ADDR + IRQ10_CTL_ADDR)

//------------------------------------------------------------
// IRQ11 Registers
//------------------------------------------------------------
#define IRQ11_PENDING_REG_ADDR     (INT_BASE_ADDR + IRQ11_PENDING_ADDR)
#define IRQ11_ENABLE_REG_ADDR      (INT_BASE_ADDR + IRQ11_ENABLE_ADDR)
#define IRQ11_ATTR_REG_ADDR        (INT_BASE_ADDR + IRQ11_ATTR_ADDR)
#define IRQ11_CTL_REG_ADDR         (INT_BASE_ADDR + IRQ11_CTL_ADDR)

//------------------------------------------------------------
// IRQ12 Registers
//------------------------------------------------------------
#define IRQ12_PENDING_REG_ADDR     (INT_BASE_ADDR + IRQ12_PENDING_ADDR)
#define IRQ12_ENABLE_REG_ADDR      (INT_BASE_ADDR + IRQ12_ENABLE_ADDR)
#define IRQ12_ATTR_REG_ADDR        (INT_BASE_ADDR + IRQ12_ATTR_ADDR)
#define IRQ12_CTL_REG_ADDR         (INT_BASE_ADDR + IRQ12_CTL_ADDR)

//------------------------------------------------------------
// IRQ13 Registers
//------------------------------------------------------------
#define IRQ13_PENDING_REG_ADDR     (INT_BASE_ADDR + IRQ13_PENDING_ADDR)
#define IRQ13_ENABLE_REG_ADDR      (INT_BASE_ADDR + IRQ13_ENABLE_ADDR)
#define IRQ13_ATTR_REG_ADDR        (INT_BASE_ADDR + IRQ13_ATTR_ADDR)
#define IRQ13_CTL_REG_ADDR         (INT_BASE_ADDR + IRQ13_CTL_ADDR)

//------------------------------------------------------------
// IRQ14 Registers
//------------------------------------------------------------
#define IRQ14_PENDING_REG_ADDR     (INT_BASE_ADDR + IRQ14_PENDING_ADDR)
#define IRQ14_ENABLE_REG_ADDR      (INT_BASE_ADDR + IRQ14_ENABLE_ADDR)
#define IRQ14_ATTR_REG_ADDR        (INT_BASE_ADDR + IRQ14_ATTR_ADDR)
#define IRQ14_CTL_REG_ADDR         (INT_BASE_ADDR + IRQ14_CTL_ADDR)

//------------------------------------------------------------
// IRQ15 Registers
//------------------------------------------------------------
#define IRQ15_PENDING_REG_ADDR     (INT_BASE_ADDR + IRQ15_PENDING_ADDR)
#define IRQ15_ENABLE_REG_ADDR      (INT_BASE_ADDR + IRQ15_ENABLE_ADDR)
#define IRQ15_ATTR_REG_ADDR        (INT_BASE_ADDR + IRQ15_ATTR_ADDR)
#define IRQ15_CTL_REG_ADDR         (INT_BASE_ADDR + IRQ15_CTL_ADDR)

//////////////INTRRUPT  INVALID  TEST ////////
//
//////invalid  addr 

#define INT_DATA_MEM_ADDR_ERROR         0x00000004

//#define WDT_BASE_ADDR            0x00087000
    ////invalid  addr for wdt 
//

#define INT_DATA_MEM_ADDR_SLVERROR         0x00087003

//#define INT_MEM_PAGE_FAULT_ADDR            PTE_bASE addr 



//========================================================
//  Common MMIO APIs
//========================================================
void mmio_write(uint32_t addr, uint32_t data);
uint32_t mmio_read(uint32_t addr);
void send_handshake_to_sv();
uint32_t wait_for_handshake_from_sv();
void info_print(uint32_t data);
void error_print(uint32_t data);

#define CHECK(expected, actual)             \
    do {                                    \
        if ((actual) == (expected))         \
            info_print(actual);             \
        else                                \
            error_print(actual);            \
    } while (0)
#endif


