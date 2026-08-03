//==============================================================================
//========================================================
// File        : tb_top.v
//========================================================
// Company     : Kyros-Semi Pvt Ltd.
// Project     : Pinaka SoC Verification
// Description : Verifiation Top module
// 
// Author      : Ganesh K S(ganesh.ks@kyros-semi.com)
// Created On  : 29-May-2026
//
// Copyright (c) 2026 Kyros-Semi Pvt Ltd
// Confidential Proprietary Information
//==============================================================================
import tb_sync_pkg::*;
import uvm_pkg::*;
import tb_pkg::*;
//`include "axi_if.sv"
`include "i2c_if.sv"
`include "spi_if.sv"
`include "uart_if.sv"
//`include "apb_interface.sv"
module tb;
//  EXTERNAL CLOCK
reg  rc_clk         ;
reg  external_clk   ;
reg  pll_clk        ;
//  POWER ON RESET
reg   power_on_rst   ;   
reg   pll_lock_done  ; 

bit tclk ;
bit trst_n ;

bit debug_mode_select ;
bit debug_data_in ;
bit debug_data_out ;


// CONFIG REGISTER OUT TO THE ANALOG TOP
wire  [2:0]       ppl_config_reg_out              ;                          
wire  [31:0]      ds_adc_config0_reg_out          ;                     
wire  [15:0]      ds_adc_config1_reg_out          ;

// TRIM REGISTER OUT TO THE ANALOG TOP

wire  [17:0]      ds_adc_trim_reg_out             ;                         
wire  [2:0]       sar_adc_trim_reg_out            ;                               
wire  [11:0]      vtc_tdc_trim_reg_out            ;                        
wire  [2:0]       cs_dac_trim_reg_out             ;                         
wire  [2:0]       c_dac_trim_reg_out              ;                         
wire  [2:0]       opamp3v3_trim_reg_out           ;                        
wire  [2:0]       opampint_trim_reg_out           ;                          
wire  [2:0]       opamp2v5_trim_reg_out           ;

//                      FROM THE GPIO PAD

reg       [16:0]      gpio_pad_in                ;

//                      TO THE GPIO PAD

wire      [16:0]      gpio_pad_out               ;
wire      [16:0]      gpio_pad_oe                ;

//                  TO THE ANALOG BLOCKS

wire      [31:0]      gpio_pullup_out            ;                   
wire      [31:0]      gpio_pulldown_out          ;                        
wire      [31:0]      gpio_opendrain_out         ;                          
wire      [31:0]      gpio_scmitt_out            ;                          
wire      [31:0]      gpio_drv0_out              ;                            
wire      [31:0]      gpio_drv1_out              ;                              
wire      [31:0]      gpio_int_en_out            ;                             
wire      [31:0]      gpio_int_status_out        ;                         
wire      [31:0]      gpio_rise_en_out           ;                         
wire      [31:0]      gpio_fall_en_out           ;                          
wire      [31:0]      gpio_high_en_out           ;                           
wire      [31:0]      gpio_low_en_out            ;                            
wire      [31:0]      gpio_lock_out              ;                             
wire      [31:0]      gpio_sel_out               ;


//================================================================
logic GPIO9_drv, GPIO9_oe;
logic GPIO10_drv, GPIO10_oe;
logic GPIO11_drv, GPIO11_oe;

initial begin
    tclk=0;
    rc_clk=0;
    external_clk=0;
    pll_clk=0;
    handshake_from_c_to_sv=0;
    handshake_from_sv_to_c=0;
end

initial begin
    pll_lock_done = 1 ; power_on_rst = 1 ; trst_n = 0;
    #1200
    pll_lock_done = 1 ; power_on_rst = 1 ;
end


always #20 tclk=~tclk;
always #5 rc_clk=~rc_clk;
always #20 external_clk=~external_clk;
always #10 pll_clk=~pll_clk;

//axi_if axi_vif(clk,reset);
i2c_if i2c_vif(tb.u_pinaka.axi2apb_instance.pclk,power_on_rst);
spi_if spi_vif();
uart_if uart_vif(tb.u_pinaka.axi2apb_instance.pclk,power_on_rst);
jtag_if vif();

intf int_vif(tb.u_pinaka.axi2apb_instance.pclk,power_on_rst);

//Pinaka top Instantiation
pinaka u_pinaka(

.TCK(vif.tclk) ,
.TRSTN(vif.trst_n) ,
.TMS(vif.tms) ,
.TDO(vif.tdo) ,
.TDI(vif.tdi) ,

.gpio_pad_in (gpio_pad_in) ,
.gpio_pad_out ( gpio_pad_out ) ,                  
.gpio_pad_oe  ( gpio_pad_oe ) ,                  
.gpio_pullup_out ( gpio_pullup_out ) ,                                  
.gpio_pulldown_out ( gpio_pulldown_out ) ,                                     
.gpio_opendrain_out ( gpio_opendrain_out ) ,                                      
.gpio_scmitt_out(gpio_scmitt_out) ,                                       
.gpio_drv0_out(gpio_drv0_out) ,                                            
.gpio_drv1_out( gpio_drv1_out) ,                                               
.gpio_int_en_out ( gpio_int_en_out ) ,                                             
.gpio_int_status_out ( gpio_int_status_out ) ,                                    
.gpio_rise_en_out ( gpio_rise_en_out ) ,                                       
.gpio_fall_en_out ( gpio_fall_en_out ) ,                                        
.gpio_high_en_out ( gpio_high_en_out ) ,                                         
.gpio_low_en_out  ( gpio_low_en_out ) ,                                          
.gpio_lock_out  ( gpio_lock_out ) ,                                             
.gpio_sel_out ( gpio_sel_out),

.rc_clk(rc_clk) ,
.external_clk(external_clk) ,
.pll_clk(pll_clk) ,

.power_on_rst(power_on_rst) ,
.pll_lock_done(pll_lock_done),
.ppl_config_reg_out( ppl_config_reg_out) ,                                    
.ds_adc_config0_reg_out ( ds_adc_config0_reg_out) ,                           
.ds_adc_config1_reg_out  (ds_adc_config1_reg_out) ,        
.ds_adc_trim_reg_out  ( ds_adc_trim_reg_out ) ,                                    
.sar_adc_trim_reg_out  ( sar_adc_trim_reg_out ) ,                                         
.vtc_tdc_trim_reg_out  (vtc_tdc_trim_reg_out) ,                                  
.cs_dac_trim_reg_out  ( cs_dac_trim_reg_out ) ,                                    
.c_dac_trim_reg_out  (  c_dac_trim_reg_out ) ,                                   
.opamp3v3_trim_reg_out ( opamp3v3_trim_reg_out ) ,                                  
.opampint_trim_reg_out ( opampint_trim_reg_out ) ,                                    
.opamp2v5_trim_reg_out (opamp2v5_trim_reg_out )
);

//gpio_pad_in assignment
assign uart_vif.txd = gpio_pad_in[0];

assign gpio_pad_in[1] = uart_vif.rxd;

assign spi_vif.mosi = gpio_pad_in[2];

assign spi_vif.sclk = gpio_pad_in[4];

assign spi_vif.ss = gpio_pad_in[5];

assign gpio_pad_in[3] =spi_vif.miso;

assign i2c_vif.sda_out = gpio_pad_in[6];

assign gpio_pad_in[7] = i2c_vif.sda_in;

assign i2c_vif.scl = gpio_pad_in[8];

assign gpio_pad_in[9]  = GPIO9_oe  ? GPIO9_drv  : 1'bz;
assign gpio_pad_in[10] = GPIO10_oe ? GPIO10_drv : 1'bz;
assign gpio_pad_in[11] = GPIO11_oe ? GPIO11_drv : 1'bz;

//-------------------------------------------------------------------------------
initial begin

 GPIO9_oe  = 1;
 GPIO9_drv = 0;

 GPIO10_oe  = 1;
 GPIO10_drv = 0;

 GPIO11_oe  = 1;
 GPIO11_drv = 0;
 uvm_event_pool::get_global("BOOT_LOAD_DONE").wait_trigger();

 $display("[%0t] Boot loading completed", $time);

 GPIO11_drv = 1;
 GPIO11_oe  = 1;

end


assign spi_vif.cpol = tb.u_pinaka.spi_wrapper_instance.spi_cpol;
assign spi_vif.cpha = tb.u_pinaka.spi_wrapper_instance.spi_cpha;


initial begin
    uvm_config_db#(virtual i2c_if)::set(null,"*","i2c_vif",i2c_vif);

   uvm_config_db#(virtual spi_if)::set(null,"*","spi_vif",spi_vif);

   uvm_config_db#(virtual uart_if)::set(null,"*","uart_vif",uart_vif);

   uvm_config_db #(virtual jtag_if)::set(null,"*","vif",vif);

    uvm_config_db#(virtual intf)::set(null,"*","vif",int_vif);

    run_test("soc_base_test");
end 


//handshake block
initial begin
    forever begin
        @(posedge tb.u_pinaka.axi_slave_wrapper_data_mem_instance.ACLK);
        if(u_pinaka.axi_slave_wrapper_data_mem_instance.u_data_memory.mem[16380]=='hC0FFEE)
        begin
            handshake_from_c_to_sv=1;
            $display("HANDSHAKE : Requets Received from C");
            u_pinaka.axi_slave_wrapper_data_mem_instance.u_data_memory.mem[16380]='h00000000;            
        end

        if(handshake_from_sv_to_c==1)
        begin
            u_pinaka.axi_slave_wrapper_data_mem_instance.u_data_memory.mem[16380]='h7EA;
            $display("HANDSHAKE : Request Sent from SV to C");
            handshake_from_sv_to_c=0;
        end
    end
end

initial begin
	$shm_open("wave.shm");
	$shm_probe("ACTMF");
end

endmodule




