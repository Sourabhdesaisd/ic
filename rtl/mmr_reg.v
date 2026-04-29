//memory mapped register - register file
module zic_mmr_reg_file
(
input 				zic_clk				,
input 				zic_rst				,
input 				zic_mmr_write_en_i		,//store write enable
input  [15:0]			zic_mmr_write_addr_i		,//store write address
input  [31:0]			zic_mmr_write_data_i		,//store write data
input  				zic_int_pending_valid_i 	,	
input  [47:0] 	    		zic_int_pending_bit_i		,// interrupt pending bits
input  [47:0]	    		global_int_enable_bit_i		,// interrupt enable signal
input 				global_int_enable_valid_i	,
input 				zic_ack_valid_i			,//from ic 
input  [7:0] 			zic_ack_int_id_i		,
input 				zic_nxtp_valid_i		,	
input  [7 :0]			zic_nxtp_id_i			,
input 				zic_eoi_valid_i			,
input  [7 :0]			zic_eoi_id_i			,
output [7 :0] 			zic_ack_int_id_o		,
output [7 :0]   		zic_eoi_o			,
output [7 :0]   		zic_cfg_o			,
output [31:0] 			zic_info_o			,
output [7 :0]			zic_nxtp_o			,
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
output [31:0]			irq16_ctrl_o			,
output [31:0]			irq17_ctrl_o			,
output [31:0]			irq18_ctrl_o			,
output [31:0]			irq19_ctrl_o			,
output [31:0]			irq20_ctrl_o			,
output [31:0]			irq21_ctrl_o			,
output [31:0]			irq22_ctrl_o			,
output [31:0]			irq23_ctrl_o			,
output [31:0]			irq24_ctrl_o			,
output [31:0]			irq25_ctrl_o			,
output [31:0]			irq26_ctrl_o			,
output [31:0]			irq27_ctrl_o			,
output [31:0]			irq28_ctrl_o			,
output [31:0]			irq29_ctrl_o			,
output [31:0]			irq30_ctrl_o			,
output [31:0]			irq31_ctrl_o			,
output [31:0]			irq32_ctrl_o			,
output [31:0]			irq33_ctrl_o			,
output [31:0]			irq34_ctrl_o			,
output [31:0]			irq35_ctrl_o			,
output [31:0]			irq36_ctrl_o			,
output [31:0]			irq37_ctrl_o			,
output [31:0]			irq38_ctrl_o			,
output [31:0]			irq39_ctrl_o			,
output [31:0]			irq40_ctrl_o			,
output [31:0]			irq41_ctrl_o			,
output [31:0]			irq42_ctrl_o			,
output [31:0]			irq43_ctrl_o			,
output [31:0]			irq44_ctrl_o			,
output [31:0]			irq45_ctrl_o			,
output [31:0]			irq46_ctrl_o			,
output [31:0]			irq47_ctrl_o			,
output [47:0] 			zic_int_en_o			//to ic 
);

zic_mmr_ack  
zic_mmr_ack_inst
(
.zic_clk			(zic_clk		),
.zic_rst			(zic_rst		),
.zic_mmr_write_addr		(zic_mmr_write_addr_i	),
.zic_mmr_write_data		(zic_mmr_write_data_i	),
.zic_mmr_write_en		(zic_mmr_write_en_i	),
.zic_ack_valid			(zic_ack_valid_i	),//from ic 
.zic_ack_int_id_i		(zic_ack_int_id_i	),
.zic_ack_int_id_o		(zic_ack_int_id_o	)

);
zic_mmr_cfg #(.CFG_MMR_ADDR(16'h0000)) 
zic_mmr_cfg_inst
(
.zic_clk			        (zic_clk		),
.zic_rst			        (zic_rst		),
.zic_mmr_write_addr		    (zic_mmr_write_addr_i	),
.zic_mmr_write_data		    (zic_mmr_write_data_i	),
.zic_mmr_write_en		    (zic_mmr_write_en_i	),
.zic_cfg_o			        (zic_cfg_o		)
);


zic_mmr_info #(.INFO_MMR_ADDR(16'h0004)) 
zic_mmr_info_inst(
.zic_clk			(zic_clk		),
.zic_rst			(zic_rst		),
.zic_mmr_write_addr		(zic_mmr_write_addr_i	),
.zic_mmr_write_data		(zic_mmr_write_data_i	),
.zic_mmr_write_en		(zic_mmr_write_en_i	),
.zic_info_o			(zic_info_o		)
);


zic_mmr_eoi 
zic_eoi_cfg_inst(
.zic_clk			(zic_clk		),
.zic_rst			(zic_rst		),
.zic_eoi_valid		(zic_eoi_valid_i	),
.zic_eoi_id			(zic_eoi_id_i		),
.zic_eoi_o			(zic_eoi_o		)
);

zic_mmr_nxtp 
zic_mmr_nxtp_inst
(
.zic_clk			(zic_clk		),
.zic_rst			(zic_rst		),
.zic_nxtp_valid		(zic_nxtp_valid_i	),
.zic_nxtp_id		(zic_nxtp_id_i		),
.zic_nxtp_o			(zic_nxtp_o		)
);

zic_mmr_ctrl zic_mmr_ctrl_inst
(
.zic_clk			(zic_clk			),
.zic_rst			(zic_rst			),
.zic_mmr_write_addr		(zic_mmr_write_addr_i		),
.zic_mmr_write_data		(zic_mmr_write_data_i		),
.zic_mmr_write_en		(zic_mmr_write_en_i		),
.zic_int_pending_bit		(zic_int_pending_bit_i		),
.zic_int_pending_valid		(zic_int_pending_valid_i	),
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
.irq16_ctrl_o			(irq16_ctrl_o			),
.irq17_ctrl_o			(irq17_ctrl_o			),
.irq18_ctrl_o			(irq18_ctrl_o			),
.irq19_ctrl_o			(irq19_ctrl_o			),
.irq20_ctrl_o			(irq20_ctrl_o			),
.irq21_ctrl_o			(irq21_ctrl_o			),
.irq22_ctrl_o			(irq22_ctrl_o			),
.irq23_ctrl_o			(irq23_ctrl_o			),
.irq24_ctrl_o			(irq24_ctrl_o			),
.irq25_ctrl_o			(irq25_ctrl_o			),
.irq26_ctrl_o			(irq26_ctrl_o			),
.irq27_ctrl_o			(irq27_ctrl_o			),
.irq28_ctrl_o			(irq28_ctrl_o			),
.irq29_ctrl_o			(irq29_ctrl_o			),
.irq30_ctrl_o			(irq30_ctrl_o			),
.irq31_ctrl_o			(irq31_ctrl_o			),
.irq32_ctrl_o			(irq32_ctrl_o			),
.irq33_ctrl_o			(irq33_ctrl_o			),
.irq34_ctrl_o			(irq34_ctrl_o			),
.irq35_ctrl_o			(irq35_ctrl_o			),
.irq36_ctrl_o			(irq36_ctrl_o			),
.irq37_ctrl_o			(irq37_ctrl_o			),
.irq38_ctrl_o			(irq38_ctrl_o			),
.irq39_ctrl_o			(irq39_ctrl_o			),
.irq40_ctrl_o			(irq40_ctrl_o			),
.irq41_ctrl_o			(irq41_ctrl_o			),
.irq42_ctrl_o			(irq42_ctrl_o			),
.irq43_ctrl_o			(irq43_ctrl_o			),
.irq44_ctrl_o			(irq44_ctrl_o			),
.irq45_ctrl_o			(irq45_ctrl_o			),
.irq46_ctrl_o			(irq46_ctrl_o			),
.irq47_ctrl_o			(irq47_ctrl_o			),
.zic_int_en_o			(zic_int_en_o			)
);
endmodule

//acknowledge mmr
module zic_mmr_ack #(parameter CFG_MMR_ACK = 16'h0804) 
(
input 		zic_clk			,
input 		zic_rst			,
input [15:0] 	zic_mmr_write_addr	,
input [31:0] 	zic_mmr_write_data	,
input 	     	zic_mmr_write_en	,
input 		zic_ack_valid		,//from ic 
input [7:0]	zic_ack_int_id_i	,
output [7:0]	zic_ack_int_id_o
);

reg [7:0] zic_ack_int_id_r;

always@(posedge zic_clk or negedge zic_rst )
begin
	if((!zic_rst) )
	begin
		zic_ack_int_id_r <= 8'd0;
	end
	else
	begin
		if(zic_ack_valid)
			begin
				zic_ack_int_id_r <= zic_ack_int_id_i;
			end
	end
end

assign zic_ack_int_id_o = zic_ack_int_id_r;
endmodule

//zic memory mapped configuration register
//defines how many previlege modes are supported
//defines how level and priority bits are devided

module zic_mmr_cfg #(parameter CFG_MMR_ADDR = 16'h0000) 
(
input 		zic_clk			,
input 		zic_rst			,
input [15:0] 	zic_mmr_write_addr	,
input [31:0] 	zic_mmr_write_data	,
input 	     	zic_mmr_write_en	,
output 	[7:0]   zic_cfg_o		
);

//reg [7:0] zic_cfg_r;

localparam NMBITS = 2'b00;
localparam NLBITS = 4'b0011;
localparam NVBITS = 1'b1;

assign zic_cfg_o = {1'b0,NMBITS,NLBITS,NVBITS};
endmodule
/////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////
//zic memory mapped information register
//has required information about zic

module zic_mmr_info #(parameter INFO_MMR_ADDR = 16'd0004) 
(
input 		zic_clk			,
input 		zic_rst			,
input [15:0] 	zic_mmr_write_addr	,
input [31:0] 	zic_mmr_write_data	,
input 	     	zic_mmr_write_en	,
output 	[31:0]   zic_info_o		
);

//reg [31:0] zic_info_r;
localparam NUM_TRIG	= 6'd0	;
localparam ZIC_INT_CTL	= 4'd6	;
localparam ARCH_VER	= 4'd0	;
localparam IMPL_VER	= 4'd0	;
localparam NUM_IRQ 	= 13'd48;


assign zic_info_o = {1'b0,NUM_TRIG,ZIC_INT_CTL,ARCH_VER,IMPL_VER,NUM_IRQ};
endmodule

//zic memory mapped end of interrupt id register
//stores the id of a interrup whose service is completed by the processor
module zic_mmr_eoi 
(
input 		zic_clk			,
input 		zic_rst			,
input 		zic_eoi_valid		,
input 	[7:0]	zic_eoi_id		,
output 	[7:0]   zic_eoi_o		
);

reg [7:0] zic_eoi_r;

always@(posedge zic_clk or negedge zic_rst )
begin
	if((!zic_rst) )
	begin
		zic_eoi_r <= 8'd0;
	end
	else
	begin
		if(zic_eoi_valid)
			begin
				zic_eoi_r <= zic_eoi_id;
			end
	end
end

assign zic_eoi_o = zic_eoi_r;
endmodule

//stores the level and priority of highest pending interrupt
//for software read purpose
module zic_mmr_nxtp 
(
input 		zic_clk			,
input 		zic_rst			,
input 		zic_nxtp_valid		,
input 	[7:0]	zic_nxtp_id		,
output 	[7:0]   zic_nxtp_o		
);

reg [7:0] zic_nxtp_r;

always@(posedge zic_clk or negedge zic_rst )
begin
	if((!zic_rst) )
	begin

		zic_nxtp_r <= 8'd0;
	end
	else
	begin
		if(zic_nxtp_valid)
			begin
				zic_nxtp_r <= zic_nxtp_id;
			end
	end
end

assign zic_nxtp_o = zic_nxtp_r;
endmodule


