//`timescale 1ns / 1ps
//memory mapped register - register file

module soc_mmr_reg_file
(
input 				soc_clk				,
input 				soc_rst				,
input 				soc_mmr_write_en_i		,//store write enable
input  [15:0]			soc_mmr_write_addr_i		,//store write address
input  [7:0]			soc_mmr_write_data_i		,//store write data
input  				soc_int_pending_valid_i 	,	
input  [15:0] 	    		soc_int_pending_bit_i		,//soc interrupt pending bits
input  [15:0]	    		global_int_enable_bit_i		,//soc interrupt enable signal
input 				global_int_enable_valid_i	,
input 				soc_ack_valid_i			,//from soc 
input  [7:0] 			soc_ack_int_id_i		,
input 				soc_nxtp_valid_i		,	
input  [7 :0]			soc_nxtp_id_i			,
input 				soc_eoi_valid_i			,
input  [7 :0]			soc_eoi_id_i			,
output [7 :0] 			soc_ack_int_id_o		,
output [7 :0]   		soc_eoi_o			,
output [7 :0]   		soc_cfg_o			,
output [7 :0] 			soc_info_o			,
output [7 :0]			soc_nxtp_o			,
output [31:0]			irq0_ctrl_o 			,		
output [31:0]			irq1_ctrl_o 			,
output [31:0]			irq2_ctrl_o 			,
output [31:0]			irq3_ctrl_o 			,
output [31:0]			irq4_ctrl_o 			,
output [31:0]			irq5_ctrl_o 			,
output [31:0]			irq6_ctrl_o 			,
output [31:0]			irq7_ctrl_o 			,
output [31:0]			irq8_ctrl_o 			,
output [31:0]			irq9_ctrl_o 			,
output [31:0]			irq10_ctrl_o			,
output [31:0]			irq11_ctrl_o			,
output [31:0]			irq12_ctrl_o			,
output [31:0]			irq13_ctrl_o			,
output [31:0]			irq14_ctrl_o			,
output [31:0]			irq15_ctrl_o			,
//    output [31:0]			irq16_ctrl_o			,
//    output [31:0]			irq17_ctrl_o			,
//    output [31:0]			irq18_ctrl_o			,
//    output [31:0]			irq19_ctrl_o			,
//    output [31:0]			irq20_ctrl_o			,
//    output [31:0]			irq21_ctrl_o			,
//    output [31:0]			irq22_ctrl_o			,
//    output [31:0]			irq23_ctrl_o			,
//    output [31:0]			irq24_ctrl_o			,
//    output [31:0]			irq25_ctrl_o			,
//    output [31:0]			irq26_ctrl_o			,
//    output [31:0]			irq27_ctrl_o			,
//    output [31:0]			irq28_ctrl_o			,
//    output [31:0]			irq29_ctrl_o			,
//    output [31:0]			irq30_ctrl_o			,
//    output [31:0]			irq31_ctrl_o			,
//    output [31:0]			irq32_ctrl_o			,
//    output [31:0]			irq33_ctrl_o			,
//    output [31:0]			irq34_ctrl_o			,
//    output [31:0]			irq35_ctrl_o			,
//    output [31:0]			irq36_ctrl_o			,
//    output [31:0]			irq37_ctrl_o			,
//    output [31:0]			irq38_ctrl_o			,
//    output [31:0]			irq39_ctrl_o			,
//    output [31:0]			irq40_ctrl_o			,
//    output [31:0]			irq41_ctrl_o			,
//    output [31:0]			irq42_ctrl_o			,
//    output [31:0]			irq43_ctrl_o			,
//    output [31:0]			irq44_ctrl_o			,
//    output [31:0]			irq45_ctrl_o			,
//    output [31:0]			irq46_ctrl_o			,
//    output [31:0]			irq47_ctrl_o			,

//output [31:0] 			wdt_counter_o			,		
//output [31:0] 			wdt_ctrl_o			,
//output 			wdt_irq_o			,
//output [31:0] 			wdt_timeout_reg_o   ,
//input debug_mode_valid_i              ,
//input debug_mode_reset_i              ,
//input debug_ndm_reset_i               ,
//input wdt_reset_i                     ,
output [15:0] 			soc_int_en_o			//to soc 

);
//localparam NMBITS = 2'b00;
//localparam NLBITS = 4'b0011;
//localparam NVBITS = 1'b1;
//localparam NUM_IRQ 	= 8'd16;
//
//assign soc_info_o = {NUM_IRQ};
//assign soc_cfg_o = {1'b0,NMBITS,NLBITS,NVBITS};

soc_mmr_ack  
soc_mmr_ack_inst
(
.soc_clk			(soc_clk		),
.soc_rst			(soc_rst		),
//.wdt_reset_i        (wdt_reset_i),
//.soc_mmr_write_addr		(soc_mmr_write_addr_i	),
//.soc_mmr_write_data		(soc_mmr_write_data_i	),
//.soc_mmr_write_en		(soc_mmr_write_en_i	),
.soc_ack_valid			(soc_ack_valid_i	),//from soc 
.soc_ack_int_id_i		(soc_ack_int_id_i	),
.soc_eoi_valid		(soc_eoi_valid_i	),
//.debug_mode_valid_i             (debug_mode_valid_i         ),
//.debug_mode_reset_i             (debug_mode_reset_i        ),
//.debug_ndm_reset_i              (debug_ndm_reset_i               ),
.soc_ack_int_id_o		(soc_ack_int_id_o	)

);



soc_mmr_cfg //#(.CFG_MMR_ADDR(16'h0000)) 
soc_mmr_cfg_inst
(
.soc_clk			        (soc_clk		),
.soc_rst			        (soc_rst		),
//.wdt_reset_i        (wdt_reset_i),
//.soc_mmr_write_addr		    (soc_mmr_write_addr_i	),
//.soc_mmr_write_data		    (soc_mmr_write_data_i	),
//.soc_mmr_write_en		    (soc_mmr_write_en_i	),
//.debug_mode_valid_i             (debug_mode_valid_i         ),
//.debug_mode_reset_i             (debug_mode_reset_i        ),
//.debug_ndm_reset_i              (debug_ndm_reset_i               ),
.soc_cfg_o			        (soc_cfg_o		)

);


soc_mmr_info //#(.INFO_MMR_ADDR(16'h0004)) 
soc_mmr_info_inst(
.soc_clk			(soc_clk		),
.soc_rst			(soc_rst		),
//.wdt_reset_i        (wdt_reset_i),
//.soc_mmr_write_addr		(soc_mmr_write_addr_i	),
//.soc_mmr_write_data		(soc_mmr_write_data_i	),
//.soc_mmr_write_en		(soc_mmr_write_en_i	),
.soc_info_o			(soc_info_o		)
);


soc_mmr_eoi 
soc_eoi_cfg_inst(
.soc_clk			(soc_clk		),
.soc_rst			(soc_rst		),
//.wdt_reset_i        (wdt_reset_i),
.soc_eoi_valid		(soc_eoi_valid_i	),
.soc_eoi_id			(soc_eoi_id_i		),
//.debug_mode_valid_i             (debug_mode_valid_i         ),
//.debug_mode_reset_i             (debug_mode_reset_i        ),
//.debug_ndm_reset_i              (debug_ndm_reset_i               ),
.soc_eoi_o			(soc_eoi_o		)

);

soc_mmr_nxtp 
soc_mmr_nxtp_inst
(
.soc_clk			(soc_clk		),
.soc_rst			(soc_rst		),
//.wdt_reset_i        (wdt_reset_i),
.soc_nxtp_valid		(soc_nxtp_valid_i	),
.soc_nxtp_id		(soc_nxtp_id_i		),
//.debug_mode_valid_i             (debug_mode_valid_i         ),
//.debug_mode_reset_i             (debug_mode_reset_i        ),
//.debug_ndm_reset_i              (debug_ndm_reset_i               ),
.soc_nxtp_o			(soc_nxtp_o		)

);

soc_mmr_ctrl soc_mmr_ctrl_inst
(
.soc_clk			(soc_clk			),
.soc_rst			(soc_rst			),
//.wdt_reset_i        (wdt_reset_i),
.soc_mmr_write_addr		(soc_mmr_write_addr_i		),
.soc_mmr_write_data		(soc_mmr_write_data_i		),
.soc_mmr_write_en		(soc_mmr_write_en_i		),
.soc_int_pending_bit		(soc_int_pending_bit_i		),
.soc_int_pending_valid		(soc_int_pending_valid_i	),
.global_int_enable_bit		(global_int_enable_bit_i	),
.global_int_enable_valid 	(global_int_enable_valid_i	),
.irq0_ctrl_o			(irq0_ctrl_o 			),
.irq1_ctrl_o			(irq1_ctrl_o 			),
.irq2_ctrl_o			(irq2_ctrl_o 			),
.irq3_ctrl_o			(irq3_ctrl_o 			),
.irq4_ctrl_o			(irq4_ctrl_o 			),
.irq5_ctrl_o			(irq5_ctrl_o 			),
.irq6_ctrl_o			(irq6_ctrl_o 			),
.irq7_ctrl_o			(irq7_ctrl_o 			),
.irq8_ctrl_o			(irq8_ctrl_o 			),
.irq9_ctrl_o			(irq9_ctrl_o 			),
.irq10_ctrl_o			(irq10_ctrl_o			),
.irq11_ctrl_o			(irq11_ctrl_o			),
.irq12_ctrl_o			(irq12_ctrl_o			),
.irq13_ctrl_o			(irq13_ctrl_o			),
.irq14_ctrl_o			(irq14_ctrl_o			),
.irq15_ctrl_o			(irq15_ctrl_o			),
//.irq16_ctrl_o			(irq16_ctrl_o			),
//.irq17_ctrl_o			(irq17_ctrl_o			),
//.irq18_ctrl_o			(irq18_ctrl_o			),
//.irq19_ctrl_o			(irq19_ctrl_o			),
//.irq20_ctrl_o			(irq20_ctrl_o			),
//.irq21_ctrl_o			(irq21_ctrl_o			),
//.irq22_ctrl_o			(irq22_ctrl_o			),
//.irq23_ctrl_o			(irq23_ctrl_o			),
//.irq24_ctrl_o			(irq24_ctrl_o			),
//.irq25_ctrl_o			(irq25_ctrl_o			),
//.irq26_ctrl_o			(irq26_ctrl_o			),
//.irq27_ctrl_o			(irq27_ctrl_o			),
//.irq28_ctrl_o			(irq28_ctrl_o			),
//.irq29_ctrl_o			(irq29_ctrl_o			),
//.irq30_ctrl_o			(irq30_ctrl_o			),
//.irq31_ctrl_o			(irq31_ctrl_o			),
//.irq32_ctrl_o			(irq32_ctrl_o			),
//.irq33_ctrl_o			(irq33_ctrl_o			),
//.irq34_ctrl_o			(irq34_ctrl_o			),
//.irq35_ctrl_o			(irq35_ctrl_o			),
//.irq36_ctrl_o			(irq36_ctrl_o			),
//.irq37_ctrl_o			(irq37_ctrl_o			),
//.irq38_ctrl_o			(irq38_ctrl_o			),
//.irq39_ctrl_o			(irq39_ctrl_o			),
//.irq40_ctrl_o			(irq40_ctrl_o			),
//.irq41_ctrl_o			(irq41_ctrl_o			),
//.irq42_ctrl_o			(irq42_ctrl_o			),
//.irq43_ctrl_o			(irq43_ctrl_o			),
//.irq44_ctrl_o			(irq44_ctrl_o			),
//.irq45_ctrl_o			(irq45_ctrl_o			),
//.irq46_ctrl_o			(irq46_ctrl_o			),
//.irq47_ctrl_o			(irq47_ctrl_o			),
//.debug_mode_valid_i             (debug_mode_valid_i         ),
//.debug_mode_reset_i             (debug_mode_reset_i        ),
//.debug_ndm_reset_i              (debug_ndm_reset_i               ),
.soc_int_en_o			(soc_int_en_o			)
);
endmodule

////////////////////////////////////////////////////
//acknowledge mmr
//stores the interrupt id value of requested interrupt
////////////////////////////////////////////////////
module soc_mmr_ack //#(parameter CFG_MMR_ACK = 16'h900C) 
(
input 		soc_clk			,
input 		soc_rst			,
//input       wdt_reset_i     ,
//input [15:0] 	soc_mmr_write_addr	,
//input [31:0] 	soc_mmr_write_data	,
//input 	     	soc_mmr_write_en	,
input 		soc_ack_valid		,//from soc 
input       soc_eoi_valid		,
input [7:0]	soc_ack_int_id_i	,
//input debug_mode_valid_i             ,
//input debug_mode_reset_i             ,
//input debug_ndm_reset_i       ,       
output [7:0]	soc_ack_int_id_o

);

reg [7:0] soc_ack_int_id_r;

always@(posedge soc_clk or negedge soc_rst )
begin
	if((!soc_rst) )
	begin
		soc_ack_int_id_r <= 8'd0;
	end
	else if(soc_ack_valid)
		begin
			soc_ack_int_id_r <= soc_ack_int_id_i;
		end
	else if(soc_eoi_valid)
        begin
		    soc_ack_int_id_r <= 8'd0;
	    end
end

assign soc_ack_int_id_o = soc_ack_int_id_r;
endmodule

////////////////////////////////////////////////////////////////////
//soc memory mapped configuration register
//defines how many previlege modes are supported
//defines how level and priority bits are devided

module soc_mmr_cfg //#(parameter CFG_MMR_ADDR = 16'h9000) 
(
input 		soc_clk			,
input 		soc_rst			,
//input       wdt_reset_i     ,
//input [15:0] 	soc_mmr_write_addr	,
//input [31:0] 	soc_mmr_write_data	,
//input 	     	soc_mmr_write_en	,
//input debug_mode_valid_i             ,
//input debug_mode_reset_i             ,
//input debug_ndm_reset_i              ,
output reg 	[7:0]   soc_cfg_o		


);

//reg [7:0] soc_cfg_r;

localparam NMBITS = 2'b00;
localparam NLBITS = 4'b0011;
localparam NVBITS = 1'b1;

always@(posedge soc_clk or negedge soc_rst) begin

    if(!soc_rst)
        soc_cfg_o <= {1'b0,NMBITS,NLBITS,NVBITS};// 8'b0000_0111
    else
        soc_cfg_o <= soc_cfg_o;

end

//assign soc_cfg_o = {1'b0,NMBITS,NLBITS,NVBITS};
endmodule
/////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////
//soc memory mapped information register
//has required information about soc

module soc_mmr_info //#(parameter INFO_MMR_ADDR = 16'd9004) 
(
input 		soc_clk			,
input 		soc_rst			,
//input       wdt_reset_i     ,
//input [15:0] 	soc_mmr_write_addr	,
//input [31:0] 	soc_mmr_write_data	,
//input 	     	soc_mmr_write_en	,
output reg	[7:0]   soc_info_o		
);

//reg [31:0] soc_info_r;
//localparam NUM_TRIG	= 6'd0	;
//localparam ZIC_INT_CTL	= 4'd6	;
//localparam ARCH_VER	= 4'd0	;
//localparam IMPL_VER	= 4'd0	;
localparam NUM_IRQ 	= 8'd16;

always@(posedge soc_clk or negedge soc_rst) begin
    if(!soc_rst)
        soc_info_o <= NUM_IRQ; //NUM_IRQ;
    else
        soc_info_o <= soc_info_o;
end

//assign soc_info_o = {1'b0,NUM_TRIG,ZIC_INT_CTL,ARCH_VER,IMPL_VER,NUM_IRQ};

endmodule

//////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
//soc memory mapped end of interrupt id register
//stores the id of a interrup whose service is completed by the processor
///////////////////////////////////////////////////////////////////////////////////

module soc_mmr_eoi //#(parameter EOI_MMR_ADDR = 16'd9010)
(
input 		soc_clk			,
input 		soc_rst			,
//input       wdt_reset_i     ,
input 		soc_eoi_valid		,
input 	[7:0]	soc_eoi_id		,
//input debug_mode_valid_i             ,
//input debug_mode_reset_i             ,
//input debug_ndm_reset_i              ,
output 	[7:0]   soc_eoi_o		

);

reg [7:0] soc_eoi_r;

always@(posedge soc_clk or negedge soc_rst )
begin
	if(!soc_rst)
	begin
		soc_eoi_r <= 8'd0;
	end
    //else if(debug_mode_reset_i |debug_ndm_reset_i| wdt_reset_i )
    //begin
    //    		soc_eoi_r <= 8'd0;
    //end
	else
	begin
		if(soc_eoi_valid)
			begin
				soc_eoi_r <= soc_eoi_id;
			end
	end
end

assign soc_eoi_o = soc_eoi_r;
endmodule

////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////
//stores the level and priority of highest pending interrupt
//for software read purpose
/////////////////////////////////////////////////////////////////////////////////

module soc_mmr_nxtp //#(parameter NXTP_MMR_ADDR = 16'd9008)
(
input 		soc_clk			,
input 		soc_rst			,
//input       wdt_reset_i     ,
input 		soc_nxtp_valid		,
input 	[7:0]	soc_nxtp_id		,
//input debug_mode_valid_i             ,
//input debug_mode_reset_i             ,
//input debug_ndm_reset_i              ,
output 	[7:0]   soc_nxtp_o		

);

reg [7:0] soc_nxtp_r;

always@(posedge soc_clk or negedge soc_rst )
begin
	if(!soc_rst)
	begin
		soc_nxtp_r <= 8'd0;
	end
    //else if(debug_mode_reset_i |debug_ndm_reset_i | wdt_reset_i )
    //begin
    //    		soc_nxtp_r <= 8'd0;
    //end
	else
	begin
		if(soc_nxtp_valid)
			begin
				soc_nxtp_r <= soc_nxtp_id;
			end
	end
end

assign soc_nxtp_o = soc_nxtp_r;
endmodule
