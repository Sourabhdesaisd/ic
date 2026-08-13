//==============================================================================
//========================================================
// File        : peripheral.c
//========================================================
// Company     : Kyros-Semi Pvt Ltd.
// Project     : Pinaka SoC Verification
// Description : API functions to write/read into/from peripherals
//
// Author      : Ganesh K S(ganesh.ks@kyros-semi.com)
// Created On  : 29-May-2026
//
// Copyright (c) 2026 Kyros-Semi Pvt Ltd
// Confidential Proprietary Information
//============================================================================== 

#include "peripheral.h"

//========================================================
//  COMMON MMIO FUNCTIONS
//========================================================
//uint32_t hdsk_from_sv_to_c=0;
void mmio_write(uint32_t addr, uint32_t data)
{
    *((volatile uint32_t *)addr) = data;
}

uint32_t mmio_read(uint32_t addr)
{
    return *((volatile uint32_t *)addr);
}

void send_handshake_to_sv()
{
    *((volatile uint32_t *)HANDSHAKE_ADDR)=HANDSHAKE_CODE;
}

uint32_t wait_for_handshake_from_sv()
{
uint32_t status;
do {
status=*((volatile uint32_t *)HANDSHAKE_ADDR);
info_print(status);
}
while(status!=0x7EA);

//    if(status==0x7EA)
//	{
//	//	info_print(*((volatile uint32_t *)HANDSHAKE_ADDR));
//       		return 1;
//	}
//    else 
//	{
//		//info_print(*((volatile uint32_t *)HANDSHAKE_ADDR));
//        	return 0;
//	}
}

void info_print(uint32_t data)
{
    *(volatile uint32_t *)INFO_PRINT_ADDR=data;
}

void error_print(uint32_t data)
{
    *(volatile uint32_t *)ERROR_PRINT_ADDR=data;
}
//--------------------------------------------------------------------
//#include <stdarg.h>

//#define SIM_PUTC_ADDR 0x0001FFF0u
//#define REG32(addr) (*(volatile unsigned int *)(addr))

//void sim_putchar(char c)
//{
//    REG32(SIM_PUTC_ADDR) = (unsigned int)c;
//}
//
//void sim_puts_raw(const char *s)
//{
//    while (*s) sim_putchar(*s++);
//}
//
//void sim_print_hex(unsigned int val, int width, int uppercase)
//{
//    const char *hex = uppercase ? "0123456789ABCDEF" : "0123456789abcdef";
//    int started = 0;
//
//    for (int i = 7; i >= 0; i--) {
//        unsigned int nibble = (val >> (i * 4)) & 0xF;
//
//        if (width == 8 || nibble != 0 || started || i == 0) {
//            sim_putchar(hex[nibble]);
//            started = 1;
//        }
//    }
//}
//
//void sim_printf(const char *str)
//{
//    sim_putchar('1');
//
//    while (*str)
//    {
//        sim_putchar('2');
//        sim_putchar(*str);
//        str++;
//    }
//
//    sim_putchar('3');
//}
//void sim_printf(const char *fmt, ...)
//{
//    va_list args;
//    va_start(args, fmt);
//
//    while (*fmt) {
//        if (*fmt != '%') {
//            sim_putchar(*fmt++);
//            continue;
//        }
//
//        fmt++;
//
//        int width = 0;
//
//        if (*fmt == '0') {
//            fmt++;
//            if (*fmt >= '0' && *fmt <= '9') {
//                width = *fmt - '0';
//                fmt++;
//            }
//        }
//
//        switch (*fmt) {
//            case 's': {
//                char *s = va_arg(args, char *);
//                sim_puts_raw(s ? s : "(null)");
//                break;
//            }
//
//            case 'c': {
//                char c = (char)va_arg(args, int);
//                sim_putchar(c);
//                break;
//            }
//
//            case 'x': {
//                unsigned int val = va_arg(args, unsigned int);
//                sim_print_hex(val, width, 0);
//                break;
//            }
//
//            case 'X': {
//                unsigned int val = va_arg(args, unsigned int);
//                sim_print_hex(val, width, 1);
//                break;
//            }
//
//            case '%': {
//                sim_putchar('%');
//                break;
//            }
//
//            default: {
//                sim_putchar('%');
//                sim_putchar(*fmt);
//                break;
//            }
//        }
//
//        fmt++;
//    }
//
//    va_end(args);
//}
//
//// ============================================================================
// UART HELPER IMPLEMENTATIONS
// ============================================================================
 
void uart_set_baud(uint32_t divisor)
{
    	mmio_write(UART_BASE_ADDR + UART_LCR_ADDR, UART_LCR_DLAB);    	
	mmio_write(UART_BASE_ADDR + UART_DLL_ADDR,  divisor & 0xFFu);
   	mmio_write(UART_BASE_ADDR + UART_DLH_ADDR, (divisor >> 8) & 0xFFu);
}
 
void uart_init(uint32_t divisor, uint32_t lcr_val, uint32_t fcr_val, uint32_t mdr_val)
{
    uart_set_baud(divisor);
    mmio_write(UART_BASE_ADDR + UART_LCR_ADDR, lcr_val);
  //  mmio_write(UART_BASE_ADDR + UART_FCR_ADDR, 0xFE);
    mmio_write(UART_BASE_ADDR + UART_FCR_ADDR, fcr_val);
    mmio_write(UART_BASE_ADDR + UART_MDR_ADDR, mdr_val);
}
 
void uart_init_default(void)
{
    uart_init(UART_BAUD_DIV_27, UART_LCR_8BIT+UART_LCR_PARITY_EN+UART_LCR_STOP1+UART_LCR_EVEN_PAR, 0x01,UART_MDR_OSM_16X);
}
 
// -- Register read shortcuts ---------------------------------------------------
 
uint32_t uart_read_lsr(void)
{
    return mmio_read(UART_BASE_ADDR + UART_LSR_ADDR);                
}
 
uint32_t uart_read_lcr(void)
{
    return mmio_read(UART_BASE_ADDR + UART_LCR_ADDR);
}
uint32_t uart_read_mdr(void)
{
    return mmio_read(UART_BASE_ADDR + UART_MDR_ADDR);
}

 uint32_t uart_read_fcr(void)
{
    return mmio_read(UART_BASE_ADDR + UART_FCR_ADDR);
}

uint32_t uart_read_dll(void)
{
    return mmio_read(UART_BASE_ADDR + UART_DLL_ADDR);
}
 
uint32_t uart_read_dlh(void)
{
    return mmio_read(UART_BASE_ADDR + UART_DLH_ADDR);
}
 
// -- Poll helpers --------------------------------------------------------------
 
void uart_wait_tx_not_full(void)
{
    while ((uart_read_lsr() & UART_LSR_TX_FULL)==0);
}
 
void uart_wait_thre(void)
{
    while ((uart_read_lsr() & UART_LSR_THRE)==0);
}
 
void uart_wait_temt(void)
{
    while ((uart_read_lsr() & UART_LSR_TEMT)==0);
}
 
void uart_wait_dr(void)
{
    while ((uart_read_lsr() & UART_LSR_DR)==0);
}
 
// -- TX / RX -------------------------------------------------------------------
 
void uart_tx_byte(uint8_t data)
{
    uart_wait_tx_not_full();
	info_print((uint32_t)data);
    mmio_write(UART_BASE_ADDR + UART_THR_ADDR, (uint32_t)data);
}
 
uint8_t uart_rx_byte(void)
{
    uart_wait_dr();
    return (uint8_t)(mmio_read(UART_BASE_ADDR + UART_RBR_ADDR) & 0xFFu);
}
