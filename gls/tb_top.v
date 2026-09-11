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
`include "apb_if.sv"
`include "gpio_apb_if.sv"
`include "gpio_if.sv"


module tb;
//  EXTERNAL CLOCK
reg  xtal_in    ;   
reg  rc_clk         ;
reg  pll_clk        ;
//  POWER ON RESET
reg   power_on_rst   ;   
reg   pll_lock_done  ;
reg   hard_reset ;
bit  [23:0]  cifb_vout_m00_reg_in ;
bit  [23:0]  ciff_vout_m00_reg_in ;
bit  [11:0]  sar_vout_m00_reg_in  ;
bit  [11:0]  tdc_vout_m00_reg_in  ;

bit tclk ;
bit trst_n ;

bit saved_pte_resp_valid;
bit [31:0] saved_pte_rdata;

bit debug_mode_select ;
bit debug_data_in ;
bit debug_data_out ;

logic GPIO1_drv, GPIO1_oe;

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

reg       [22:0]      gpio_pad_in                ;

//                   TO THE GPIO PAD

wire      [22:0]      gpio_pad_out               ;
wire      [22:0]      gpio_pad_oe                ;

//                  TO THE ANALOG BLOCKS
/*
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
*/

wire    [22:0] gpio_pull_en_out  ;
wire                  analog_2_digital_dbg_1    ;
wire                  analog_2_digital_dbg_2    ;
wire                  analog_2_digital_dbg_3    ;
wire                  analog_2_digital_dbg_4    ;
wire                  analog_2_digital_dbg_5    ;
wire                  analog_2_digital_dbg_6    ;
wire                  analog_2_digital_dbg_7    ;

//          OTHER REGISTERS TO ANALOG TOP 
/*
wire                  bg_rstb_mxx_reg_out       ;
wire                  cdac_rstb_mxx_reg_out     ;
wire      [11:0]      cdac_vin_mxx_reg_out      ;
wire                  cifb_rstb_mxx_reg_out     ;
wire                  ciff_rstb_mxx_reg_out     ;
wire                  csdac_rstb_mxx_reg_out    ;
wire      [11:0]      csdac_vin_mxx_reg_out     ;
wire                  ldo_12a_rstb_mxx_reg_out  ;
wire                  ldo_12b_rstb_mxx_reg_out  ;
wire                  ldo_18a_rstb_mxx_reg_out  ;
wire                  ldo_18b_rstb_mxx_reg_out  ;
wire                  ldo_25a_rstb_mxx_reg_out  ;
wire                  ldo_25b_rstb_mxx_reg_out  ;
wire                  osc_rstb_mxx_reg_out      ;
wire                  pll_rstb_mxx_reg_out      ;
wire                  por_rstb_mxx_reg_out      ;
wire                  sar_rstb_mxx_reg_out      ;
wire                  tdc_rstb_mxx_reg_out      ;
wire                  vmon_rst_mxx_reg_out      ;
*/
//              POSTBOOT ANALOG REGISTER OUT

wire      [50:0]      analog_postboot_reg0            ;
wire      [50:0]      analog_postboot_reg1            ;
wire      [16:0]      analog_postboot_reg2            ;
wire      [11:0]      analog_postboot_reg3            ;
wire      [11:0]      analog_postboot_reg4            ;


//              PREBOOT ANALOG REGISTER OUT

wire      [29:0]      analog_preboot_reg0             ;
wire      [15:0]      analog_preboot_reg1             ;


////////GLS
//
wire [50:0] analog_postboot_reserved_reg ;

wire      [31:0]      analog_calibrate_reg0 ;
wire      [31:0]      analog_calibrate_reg1 ;
wire      [31:0]      analog_calibrate_reg2 ;
wire      [31:0]      analog_calibrate_reg3 ;
wire      [31:0]      analog_calibrate_reg4 ;
wire      [31:0]      analog_calibrate_reg5 ;


assign pll_lock_done=1 ;



//clk/reset initialization
initial begin
    //tclk=0;
    rc_clk=0;
    pll_clk=0;
    xtal_in=0;
 //   $deposit(tb.u_pinaka.basic_isa_instance_pc[31:0], 32'b0);
  //  reset_n_drv=0;
   // reset_n=0;
    //tck_delay=10ns;
    handshake_from_c_to_sv=0;
    handshake_from_sv_to_c=0;
    hard_reset=0;
    power_on_rst=1;
#100
    hard_reset=1;
end


// Clock generation
always #1    xtal_in = ~xtal_in;
always #1.25 pll_clk = ~pll_clk;
always #0.5 rc_clk = ~rc_clk;
/*
// RC clock:
// During boot loading  -> toggle every 0.5
// After boot loading   -> toggle every 2.5
initial begin
    forever begin

        if (~ u_chip_top.pinaka_top_instance.boot_load_enable && u_chip_top.pinaka_top_instance.core_rstn )
            #10000 rc_clk = ~rc_clk;
        else
            #0.5 rc_clk = ~rc_clk;

    end
end
*/
//axi_if axi_vif(clk,reset);
i2c_if i2c_vif(tb.u_pinaka.axi2apb_instance.pclk,power_on_rst);
spi_if spi_vif();
uart_if uart_vif(tb.u_pinaka.axi2apb_instance.pclk,power_on_rst);
jtag_if vif();
apb_if apb_vif();
intf int_vif(tb.u_pinaka.axi2apb_instance.pclk);
gpio_if #(NUM_GPIO) gpio_vif (.clk(tb.u_pinaka.axi2apb_instance.pclk));
gpio_apb_if gpio_apb_vif();




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
/*.gpio_pullup_out ( gpio_pullup_out ) ,                                  
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
*/
.gpio_pull_en_out(gpio_pull_en_out),

.rc_clk(rc_clk) ,
.xtal_clk(external_clk) ,
.pll_clk(pll_clk) ,

.power_on_rst(power_on_rst) ,
.pll_lock_done(pll_lock_done),
.hard_reset (hard_reset)    ,
//.ppl_config_reg_out( ppl_config_reg_out) ,                                    
//.ds_adc_config0_reg_out ( ds_adc_config0_reg_out) ,                           
//.ds_adc_config1_reg_out  (ds_adc_config1_reg_out) ,        
//.ds_adc_trim_reg_out  ( ds_adc_trim_reg_out ) ,                                    
//.sar_adc_trim_reg_out  ( sar_adc_trim_reg_out ) ,                                         
//.vtc_tdc_trim_reg_out  (vtc_tdc_trim_reg_out) ,                                  
//.cs_dac_trim_reg_out  ( cs_dac_trim_reg_out ) ,                                    
//.c_dac_trim_reg_out  (  c_dac_trim_reg_out ) ,                                   
//.opamp3v3_trim_reg_out ( opamp3v3_trim_reg_out ) ,                                  
//.opampint_trim_reg_out ( opampint_trim_reg_out ) ,                                    
//.opamp2v5_trim_reg_out (opamp2v5_trim_reg_out ),

.analog_2_digital_dbg_1 (analog_2_digital_dbg_1) ,
.analog_2_digital_dbg_2 (analog_2_digital_dbg_2) ,
.analog_2_digital_dbg_3 (analog_2_digital_dbg_3) ,
.analog_2_digital_dbg_4 (analog_2_digital_dbg_4) ,
.analog_2_digital_dbg_5 (analog_2_digital_dbg_5) ,
.analog_2_digital_dbg_6 (analog_2_digital_dbg_6) ,
//.analog_2_digital_dbg_7 (analog_2_digital_dbg_7)

//.bg_rstb_mxx_reg_out           (bg_rstb_mxx_reg_out)       ,             
//.cdac_rstb_mxx_reg_out         (cdac_rstb_mxx_reg_out)       ,             
//.cdac_vin_mxx_reg_out          (cdac_vin_mxx_reg_out)       ,             
//.cifb_rstb_mxx_reg_out         (cifb_rstb_mxx_reg_out)       ,             
//.ciff_rstb_mxx_reg_out         (ciff_rstb_mxx_reg_out)       ,             
//.csdac_rstb_mxx_reg_out        (csdac_rstb_mxx_reg_out)       ,             
//.csdac_vin_mxx_reg_out         (csdac_vin_mxx_reg_out)       ,             
//.ldo_12a_rstb_mxx_reg_out      (ldo_12a_rstb_mxx_reg_out)       ,             
//.ldo_12b_rstb_mxx_reg_out      (ldo_12b_rstb_mxx_reg_out)       ,             
//.ldo_18a_rstb_mxx_reg_out      (ldo_18a_rstb_mxx_reg_out)       ,             
//.ldo_18b_rstb_mxx_reg_out      (ldo_18b_rstb_mxx_reg_out)       ,             
//.ldo_25a_rstb_mxx_reg_out      (ldo_25a_rstb_mxx_reg_out)       ,             
//.ldo_25b_rstb_mxx_reg_out      (ldo_25b_rstb_mxx_reg_out)       ,             
//.osc_rstb_mxx_reg_out          (osc_rstb_mxx_reg_out)       ,             
//.pll_rstb_mxx_reg_out          (pll_rstb_mxx_reg_out)       ,             
//.por_rstb_mxx_reg_out          (por_rstb_mxx_reg_out)       ,             
//.sar_rstb_mxx_reg_out          (sar_rstb_mxx_reg_out)       ,             
//.tdc_rstb_mxx_reg_out          (tdc_rstb_mxx_reg_out)       ,             
//.vmon_rst_mxx_reg_out          (vmon_rst_mxx_reg_out)       ,
//
.analog_postboot_reg0           (analog_postboot_reg0)      ,
.analog_postboot_reg1           (analog_postboot_reg1)      ,
.analog_postboot_reg2           (analog_postboot_reg2)      ,
.analog_postboot_reg3           (analog_postboot_reg3)      ,
.analog_postboot_reg4           (analog_postboot_reg4)      ,


.analog_preboot_reg0           (analog_preboot_reg0)      ,
.analog_preboot_reg1           (analog_preboot_reg1)      ,

.cifb_vout_m00_reg_in            (cifb_vout_m00_reg_in)      ,
.ciff_vout_m00_reg_in            (ciff_vout_m00_reg_in)      ,
.sar_vout_m00_reg_in             (sar_vout_m00_reg_in)      ,
.tdc_vout_m00_reg_in             (tdc_vout_m00_reg_in)    ,



.analog_calibrate_reg0    (analog_calibrate_reg0),
.analog_calibrate_reg1    (analog_calibrate_reg1),
.analog_calibrate_reg2    (analog_calibrate_reg2),
.analog_calibrate_reg3    (analog_calibrate_reg3),
.analog_calibrate_reg4    (analog_calibrate_reg4),
.analog_calibrate_reg5    (analog_calibrate_reg5),

.analog_postboot_reserved_reg  (analog_postboot_reserved_reg)
);

assign spi_vif.cpol = u_pinaka.spi_wrapper_instance_spi_cpol;

/*
assign spi_vif.cpha = u_chip_top.pinaka_top_instance.spi_wrapper_instance.spi_cpha;


//for connecting i2c signals to interface
assign i2c_vif.pslverr = u_chip_top.pinaka_top_instance.i2c_wrapper_instance.pslverr;
assign i2c_vif.pready = u_chip_top.pinaka_top_instance.i2c_wrapper_instance.pready;
assign i2c_vif.prdata = u_chip_top.pinaka_top_instance.i2c_wrapper_instance.prdata;
assign i2c_vif.psel = u_chip_top.pinaka_top_instance.i2c_wrapper_instance.psel;
assign i2c_vif.pwrite = u_chip_top.pinaka_top_instance.i2c_wrapper_instance.pwrite;
assign i2c_vif.penable = u_chip_top.pinaka_top_instance.i2c_wrapper_instance.penable;
assign i2c_vif.paddr = u_chip_top.pinaka_top_instance.i2c_wrapper_instance.paddr;
assign i2c_vif.pwdata = u_chip_top.pinaka_top_instance.i2c_wrapper_instance.pwdata;



// -------------------------
// Connect DUT signals to UART interface
// -------------------------

assign apb_vif.pclk    = u_chip_top.pinaka_top_instance.uart_wrapper_instance.pclk;
assign apb_vif.presetn = u_chip_top.pinaka_top_instance.uart_wrapper_instance.presetn;

assign apb_vif.psel    = u_chip_top.pinaka_top_instance.uart_wrapper_instance.psel;
assign apb_vif.penable = u_chip_top.pinaka_top_instance.uart_wrapper_instance.penable;
assign apb_vif.pwrite  = u_chip_top.pinaka_top_instance.uart_wrapper_instance.pwrite;

assign apb_vif.paddr   = u_chip_top.pinaka_top_instance.uart_wrapper_instance.paddr;
assign apb_vif.pwdata  = u_chip_top.pinaka_top_instance.uart_wrapper_instance.pwdata;

assign apb_vif.prdata  = u_chip_top.pinaka_top_instance.uart_wrapper_instance.prdata;
assign apb_vif.pready  = u_chip_top.pinaka_top_instance.uart_wrapper_instance.pready;
assign apb_vif.pslverr = u_chip_top.pinaka_top_instance.uart_wrapper_instance.pslverr;

// -------------------------
// Connect DUT signals to GPIO interface
// -------------------------

assign gpio_apb_vif.pclk    = u_chip_top.pinaka_top_instance.gpio_top_reg_instance.gpio_regfile_instance.pclk;
assign gpio_apb_vif.presetn = u_chip_top.pinaka_top_instance.gpio_top_reg_instance.gpio_regfile_instance.presetn;

assign gpio_apb_vif.psel    = u_chip_top.pinaka_top_instance.gpio_top_reg_instance.gpio_regfile_instance.psel;
assign gpio_apb_vif.penable = u_chip_top.pinaka_top_instance.gpio_top_reg_instance.gpio_regfile_instance.penable;
assign gpio_apb_vif.pwrite  = u_chip_top.pinaka_top_instance.gpio_top_reg_instance.gpio_regfile_instance.pwrite;

assign gpio_apb_vif.paddr   = u_chip_top.pinaka_top_instance.gpio_top_reg_instance.gpio_regfile_instance.paddr;
assign gpio_apb_vif.pwdata  = u_chip_top.pinaka_top_instance.gpio_top_reg_instance.gpio_regfile_instance.pwdata;

assign gpio_apb_vif.prdata  = u_chip_top.pinaka_top_instance.gpio_top_reg_instance.gpio_regfile_instance.prdata;
assign gpio_apb_vif.pready  = u_chip_top.pinaka_top_instance.gpio_top_reg_instance.gpio_regfile_instance.pready;
assign gpio_apb_vif.pslverr = u_chip_top.pinaka_top_instance.gpio_top_reg_instance.gpio_regfile_instance.pslverr;

//wdt ext intruppt 


   
assign gpio8 = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[26:24]==3'd001) ? (int_vif.gpio_pad_in[0]) :1'bz;
assign gpio9 = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[29:27]==3'd001) ? (int_vif.gpio_pad_in[1]) :1'bz;
assign gpio10 = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[2:0]==3'd001) ? (int_vif.gpio_pad_in[2]) :1'bz;
assign gpio11 = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[5:3]==3'd001) ? (int_vif.gpio_pad_in[3]) :1'bz;
assign gpio12 = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[8:6]==3'd001) ? (int_vif.gpio_pad_in[4]) :1'bz;
assign gpio13 = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[11:9]==3'd001) ? (int_vif.gpio_pad_in[5]) :1'bz;

   
*/


//------------------------------------------------------------------------------
initial begin
    
 gpio_pad_in = 23'b000_0000_0000_0000_0000_0000 ; #100000
 uvm_event_pool::get_global("BOOT_LOAD_DONE").wait_trigger();

 $display("[%0t] Boot loading completed", $time);
 //tck_delay=25ns;
    gpio_pad_in = 23'b000_0000_0000_0000_0000_0010 ;
 
 #250ns
    gpio_pad_in = 23'b000_0000_0000_0000_0000_0000 ;


end

//assign gpio1 = GPIO1_oe ? GPIO1_drv : 1'bz;

/*
assign spi_vif.cpol = tb.u_pinaka.spi_wrapper_instance.spi_cpol;
assign spi_vif.cpha = tb.u_pinaka.spi_wrapper_instance.spi_cpha;

*/

/*
//for connecting i2c signals to interface
assign i2c_vif.pslverr = u_pinaka.i2c_wrapper_instance.pslverr;
assign i2c_vif.pready = u_pinaka.i2c_wrapper_instance.pready;
assign i2c_vif.prdata = u_pinaka.i2c_wrapper_instance.prdata;
assign i2c_vif.psel = u_pinaka.i2c_wrapper_instance.psel;
assign i2c_vif.pwrite = u_pinaka.i2c_wrapper_instance.pwrite;
assign i2c_vif.penable = u_pinaka.i2c_wrapper_instance.penable;
assign i2c_vif.paddr = u_pinaka.i2c_wrapper_instance.paddr;
assign i2c_vif.pwdata = u_pinaka.i2c_wrapper_instance.pwdata;



// -------------------------
   // Connect DUT signals to interface
   // -------------------------

   assign apb_vif.pclk    = u_pinaka.uart_wrapper_instance.pclk;
   assign apb_vif.presetn = u_pinaka.uart_wrapper_instance.presetn;

   assign apb_vif.psel    = u_pinaka.uart_wrapper_instance.psel;
   assign apb_vif.penable = u_pinaka.uart_wrapper_instance.penable;
   assign apb_vif.pwrite  = u_pinaka.uart_wrapper_instance.pwrite;

   assign apb_vif.paddr   = u_pinaka.uart_wrapper_instance.paddr;
   assign apb_vif.pwdata  = u_pinaka.uart_wrapper_instance.pwdata;

   assign apb_vif.prdata  = u_pinaka.uart_wrapper_instance.prdata;
   assign apb_vif.pready  = u_pinaka.uart_wrapper_instance.pready;
   assign apb_vif.pslverr = u_pinaka.uart_wrapper_instance.pslverr;


   assign gpio_pad_in[13:8] = int_vif.gpio_pad_in[5:0];
   */

initial begin
    uvm_config_db#(virtual i2c_if)::set(null,"*","i2c_vif",i2c_vif);

   uvm_config_db#(virtual spi_if)::set(null,"*","spi_vif",spi_vif);

   uvm_config_db#(virtual uart_if)::set(null,"*","uart_vif",uart_vif);

   uvm_config_db #(virtual jtag_if)::set(null,"*","vif",vif);

   uvm_config_db#(virtual intf)::set(null,"*","vif",int_vif);

   uvm_config_db#(virtual apb_if)::set(null,"*","apb_vif",apb_vif);

   uvm_config_db#(virtual gpio_apb_if)::set(null,"*","gpio_apb_vif",gpio_apb_vif);

   uvm_config_db#(virtual gpio_if)::set(null,"*","gpio_vif",gpio_vif);

   
    run_test("soc_base_test");
end 


//handshake block
initial begin
    forever begin
        @(posedge u_pinaka.memory_clk);
        if(u_pinaka.axi_slave_wrapper_data_mem_instance_u_data_memory_u_sram7.mem[2047]=='hC0FFEE)
        begin
            handshake_from_c_to_sv=1;
            $display("HANDSHAKE : Requets Received from C");
            u_pinaka.axi_slave_wrapper_data_mem_instance_u_data_memory_u_sram7.mem[2047]='h00000000;            
        end

        if(handshake_from_sv_to_c==1)
        begin
            u_pinaka.axi_slave_wrapper_data_mem_instance_u_data_memory_u_sram7.mem[2047]='h7EA;
            $display("HANDSHAKE : Request Sent from SV to C");
            handshake_from_sv_to_c=0;
        end
    end
end


//C print mechanism
//C info print
always @(u_pinaka.axi_slave_wrapper_data_mem_instance_u_data_memory_u_sram7.mem[2045]) begin
   $display("[C_PRINT][INFO]:%h",u_pinaka.axi_slave_wrapper_data_mem_instance_u_data_memory_u_sram7.mem[2045]);
end

//C error print
always @(u_pinaka.axi_slave_wrapper_data_mem_instance_u_data_memory_u_sram7.mem[2044]) begin
   $display("[C_PRINT][ERROR]:%h",u_pinaka.axi_slave_wrapper_data_mem_instance_u_data_memory_u_sram7.mem[2044]);
end


/*
assign uart_vif.txd = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[8:6]==3'd0) ?gpio2:1'b1;
assign gpio3 = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[11:9]==3'd0) ? (uart_vif.loopback_en ? uart_vif.txd: uart_vif.rxd) :1'bz;

//SPI signals
assign spi_vif.mosi = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[14:12]==3'd0) ?gpio4:1'b0;
assign gpio5 =(u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[17:15]==3'd0) ?spi_vif.miso:1'bz;
assign spi_vif.sclk = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[20:18]==3'd0) ?gpio6:1'b0;
assign spi_vif.ss = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[23:21]==3'd0) ?gpio7:1'b1;


//I2C signals
assign i2c_vif.sda =(u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[2:0]==3'd1 && u_chip_top.pinaka_top_instance.gpio_pad_oe[0]) ? gpio0:1'bz;
assign gpio0 =(u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[2:0]==3'd1 && u_chip_top.pinaka_top_instance.gpio_pad_oe[0]==0)? i2c_vif.sda : 1'bz;
assign i2c_vif.scl = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[5:3]==3'd1) ? gpio1:1'b1;

//GPIO
assign gpio_vif.gpio_dir = u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg;
//GPIO signals

assign gpio_vif.gpio[0] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[0] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[2:0]==3'd4)) ? gpio0 : 1'bz;
assign gpio_vif.gpio[1] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[1] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[5:3]==3'd4)) ? gpio1 : 1'bz;
assign gpio_vif.gpio[2] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[2] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[8:6]==3'd4)) ? gpio2 : 1'bz;
assign gpio_vif.gpio[3] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[3] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[11:9]==3'd4)) ? gpio3 : 1'bz;
assign gpio_vif.gpio[4] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[4] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[14:12]==3'd4))? gpio4 : 1'bz;
assign gpio_vif.gpio[5] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[5] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[17:15]==3'd4))? gpio5 : 1'bz;
assign gpio_vif.gpio[6] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[6] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[20:18]==3'd4)) ? gpio6 : 1'bz;
assign gpio_vif.gpio[7] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[7] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[23:21]==3'd4)) ? gpio7 : 1'bz;
assign gpio_vif.gpio[8] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[8] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[26:24]==3'd4)) ? gpio8 : 1'bz;
assign gpio_vif.gpio[9] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[9] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[29:27]==3'd4)) ? gpio9 : 1'bz;
assign gpio_vif.gpio[10] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[10] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[2:0]==3'd4)) ? gpio10 : 1'bz;
assign gpio_vif.gpio[11] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[11] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[5:3]==3'd4)) ? gpio11 : 1'bz;
assign gpio_vif.gpio[12] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[12] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[8:6]==3'd4)) ? gpio12 : 1'bz;
assign gpio_vif.gpio[13] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[13] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[11:9]==3'd4)) ? gpio13 : 1'bz;
assign gpio_vif.gpio[14] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[14] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[14:12]==3'd4)) ? gpio14 : 1'bz;
assign gpio_vif.gpio[15] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[15] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[17:15]==3'd4)) ? gpio15 : 1'bz;
assign gpio_vif.gpio[16] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[16] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[20:18]==3'd4)) ? gpio16 : 1'bz;
assign gpio_vif.gpio[17] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[17] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[23:21]==3'd4)) ? gpio17 : 1'bz;
assign gpio_vif.gpio[18] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[18] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[26:24]==3'd4)) ? gpio18 : 1'bz;
assign gpio_vif.gpio[19] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[19] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[29:27]==3'd4)) ? gpio19 : 1'bz;
assign gpio_vif.gpio[20] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[20] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux2[2:0]==3'd4)) ? gpio20 : 1'bz;
assign gpio_vif.gpio[21] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[21] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux2[5:3]==3'd4)) ? gpio21 : 1'bz;
assign gpio_vif.gpio[22] = (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[22] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux2[8:6]==3'd4)) ? gpio22 : 1'bz;
assign gpio0 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[0] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[2:0]==3'd4)) ? gpio_vif.gpio[0] : 1'bz;
assign gpio1 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[1] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[5:3]==3'd4)) ? gpio_vif.gpio[1] : 1'bz;
assign gpio2 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[2] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[8:6]==3'd4)) ? gpio_vif.gpio[2] : 1'bz;
assign gpio3 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[3] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[11:9]==3'd4)) ? gpio_vif.gpio[3] : 1'bz;
assign gpio4 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[4] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[14:12]==3'd4)) ? gpio_vif.gpio[4] : 1'bz;
assign gpio5 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[5] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[17:15]==3'd4)) ? gpio_vif.gpio[5] : 1'bz;
assign gpio6 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[6] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[20:18]==3'd4)) ? gpio_vif.gpio[6] : 1'bz;
assign gpio7 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[7] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[23:21]==3'd4)) ? gpio_vif.gpio[7] : 1'bz;
assign gpio8 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[8] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[26:24]==3'd4)) ? gpio_vif.gpio[8] : 1'bz;
assign gpio9 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[9] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux0[29:27]==3'd4)) ? gpio_vif.gpio[9] : 1'bz;
assign gpio10 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[10] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[2:0]==3'd4)) ? gpio_vif.gpio[10] : 1'bz;
assign gpio11 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[11] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[5:3]==3'd4)) ? gpio_vif.gpio[11] : 1'bz;
assign gpio12 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[12] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[8:6]==3'd4)) ? gpio_vif.gpio[12] : 1'bz;
assign gpio13 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[13] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[11:9]==3'd4)) ? gpio_vif.gpio[13] : 1'bz;
assign gpio14 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[14] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[14:12]==3'd4)) ? gpio_vif.gpio[14] : 1'bz;
assign gpio15 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[15] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[17:15]==3'd4)) ? gpio_vif.gpio[15] : 1'bz;
assign gpio16 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[16] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[20:18]==3'd4)) ? gpio_vif.gpio[16] : 1'bz;
assign gpio17 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[17] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[23:21]==3'd4)) ? gpio_vif.gpio[17] : 1'bz;
assign gpio18 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[18] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[26:24]==3'd4)) ? gpio_vif.gpio[18] : 1'bz;
assign gpio19 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[19] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux1[29:27]==3'd4)) ? gpio_vif.gpio[19] : 1'bz;
assign gpio20 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[20] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux2[2:0]==3'd4)) ? gpio_vif.gpio[20] : 1'bz;
assign gpio21 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[21] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux2[5:3]==3'd4)) ? gpio_vif.gpio[21] : 1'bz;
assign gpio22 = (!u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.gpio_dir_reg[22] && (u_chip_top.pinaka_top_instance.gpio_top_reg_instance.pinmux_gpio_ss_instance.pinmux2[8:6]==3'd4)) ? gpio_vif.gpio[22] : 1'bz;

*/

initial begin
	$shm_open("wave.shm");
	$shm_probe("ACTMF");
end
endmodule



