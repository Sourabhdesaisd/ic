//Interrupt reciever block 
//recieves the external interrupts and gives the pending interrupt vector
module interrupt_receive(input ic_clk,
  						  input ic_rst,
						  input ack_in,						//ack from core
						  input [7:0] ack_id,				//id from core
						  input [47:0] interrupt_enable,	//interrupt_enable from mmr
						  output reg[47:0] interrupt_pending_o,//interrupt pending to pr
						  input  ext_int0,	//external interrupts(48)					  
						  input  ext_int1,
						  input  ext_int2,
						  input  ext_int3,
						  input  ext_int4,
						  input  ext_int5,
						  input  ext_int6,
						  input  ext_int7,
						  input  ext_int8,
						  input  ext_int9,
						  input  ext_int10,
						  input  ext_int11,
						  input  ext_int12,
						  input  ext_int13,
						  input  ext_int14,
						  input  ext_int15,
						  input  ext_int16,
						  input  ext_int17,
						  input  ext_int18,
						  input  ext_int19,
						  input  ext_int20,
						  input  ext_int21,
						  input  ext_int22,
						  input  ext_int23,
						  input  ext_int24,
						  input  ext_int25,
						  input  ext_int26,
						  input  ext_int27,
						  input  ext_int28,
						  input  ext_int29,
						  input  ext_int30,
						  input  ext_int31,						  
						  input  ext_int32,
						  input  ext_int33,
						  input  ext_int34,
						  input  ext_int35,
						  input  ext_int36,
						  input  ext_int37,
						  input  ext_int38,
						  input  ext_int39,
						  input  ext_int40,
						  input  ext_int41,
						  input  ext_int42,
						  input  ext_int43,
						  input  ext_int44,
						  input  ext_int45,
						  input  ext_int46,
						  input  ext_int47);

//ID's of interrupts
localparam INT_ID_0 = 8'd16;
localparam INT_ID_1 = 8'd17;
localparam INT_ID_2 = 8'd18;
localparam INT_ID_3 = 8'd19;
localparam INT_ID_4 = 8'd20;
localparam INT_ID_5 = 8'd21;
localparam INT_ID_6 = 8'd22;
localparam INT_ID_7 = 8'd23;
localparam INT_ID_8 = 8'd24;
localparam INT_ID_9 = 8'd25;
localparam INT_ID_10 = 8'd26;
localparam INT_ID_11 = 8'd27;
localparam INT_ID_12 = 8'd28;
localparam INT_ID_13 = 8'd29;
localparam INT_ID_14 = 8'd30;
localparam INT_ID_15 = 8'd31;
localparam INT_ID_16 = 8'd32;
localparam INT_ID_17 = 8'd33;
localparam INT_ID_18 = 8'd34;
localparam INT_ID_19 = 8'd35;
localparam INT_ID_20 = 8'd36;
localparam INT_ID_21 = 8'd37;
localparam INT_ID_22 = 8'd38;
localparam INT_ID_23 = 8'd39;
localparam INT_ID_24 = 8'd40;
localparam INT_ID_25 = 8'd41;
localparam INT_ID_26 = 8'd42;
localparam INT_ID_27 = 8'd43;
localparam INT_ID_28 = 8'd44;
localparam INT_ID_29 = 8'd45;
localparam INT_ID_30 = 8'd46;
localparam INT_ID_31 = 8'd47;
localparam INT_ID_32 = 8'd48;
localparam INT_ID_33 = 8'd49;
localparam INT_ID_34 = 8'd50;
localparam INT_ID_35 = 8'd51;
localparam INT_ID_36 = 8'd52;
localparam INT_ID_37 = 8'd53;
localparam INT_ID_38 = 8'd54;
localparam INT_ID_39 = 8'd55;
localparam INT_ID_40 = 8'd56;
localparam INT_ID_41 = 8'd57;
localparam INT_ID_42 = 8'd58;
localparam INT_ID_43 = 8'd59;
localparam INT_ID_44 = 8'd60;
localparam INT_ID_45 = 8'd61;
localparam INT_ID_46 = 8'd62;
localparam INT_ID_47 = 8'd63;

wire int0; //wires for pending estimation   
wire int1; 
wire int2;
wire int3;
wire int4;
wire int5;
wire int6;
wire int7;
wire int8;
wire int9;
wire int10; 
wire int11;
wire int12;
wire int13;
wire int14;
wire int15;
wire int16;
wire int17;
wire int18;
wire int19;
wire int20;
wire int21;
wire int22;
wire int23;
wire int24;
wire int25;
wire int26;
wire int27;
wire int28;
wire int29;
wire int30;
wire int31;
wire int32;
wire int33;
wire int34;
wire int35;
wire int36;
wire int37;
wire int38;
wire int39;
wire int40;
wire int41;
wire int42;
wire int43;
wire int44;
wire int45;
wire int46;
wire int47;
//interrupt enabling and disabling(after service) logic
assign int0 = (interrupt_enable[0] 	 & !(ack_in && (ack_id == INT_ID_0))) ? ext_int0: 1'b0;
assign int1 = (interrupt_enable[1] 	 & !(ack_in && (ack_id == INT_ID_1))) ? ext_int1: 1'b0;
assign int2 = (interrupt_enable[2] 	 & !(ack_in && (ack_id == INT_ID_2))) ? ext_int2: 1'b0;
assign int3 = (interrupt_enable[3] 	 & !(ack_in && (ack_id == INT_ID_3))) ? ext_int3: 1'b0;
assign int4 = (interrupt_enable[4] 	 & !(ack_in && (ack_id == INT_ID_4))) ? ext_int4: 1'b0;
assign int5 = (interrupt_enable[5] 	 & !(ack_in && (ack_id == INT_ID_5))) ? ext_int5: 1'b0;
assign int6 = (interrupt_enable[6] 	 & !(ack_in && (ack_id == INT_ID_6))) ? ext_int6: 1'b0;
assign int7 = (interrupt_enable[7] 	 & !(ack_in && (ack_id == INT_ID_7))) ? ext_int7: 1'b0;
assign int8 = (interrupt_enable[8] 	 & !(ack_in && (ack_id == INT_ID_8))) ? ext_int8: 1'b0;
assign int9 = (interrupt_enable[9] 	 & !(ack_in && (ack_id == INT_ID_9))) ? ext_int9: 1'b0;
assign int10 = (interrupt_enable[10] & !(ack_in && (ack_id == INT_ID_10))) ? ext_int10: 1'b0;
assign int11 = (interrupt_enable[11] & !(ack_in && (ack_id == INT_ID_11))) ? ext_int11: 1'b0;
assign int12 = (interrupt_enable[12] & !(ack_in && (ack_id == INT_ID_12))) ? ext_int12: 1'b0;
assign int13 = (interrupt_enable[13] & !(ack_in && (ack_id == INT_ID_13))) ? ext_int13: 1'b0;
assign int14 = (interrupt_enable[14] & !(ack_in && (ack_id == INT_ID_14))) ? ext_int14: 1'b0;
assign int15 = (interrupt_enable[15] & !(ack_in && (ack_id == INT_ID_15))) ? ext_int15: 1'b0;
assign int16 = (interrupt_enable[16] & !(ack_in && (ack_id == INT_ID_16))) ? ext_int16: 1'b0;
assign int17 = (interrupt_enable[17] & !(ack_in && (ack_id == INT_ID_17))) ? ext_int17: 1'b0;
assign int18 = (interrupt_enable[18] & !(ack_in && (ack_id == INT_ID_18))) ? ext_int18: 1'b0;
assign int19 = (interrupt_enable[19] & !(ack_in && (ack_id == INT_ID_19))) ? ext_int19: 1'b0;
assign int20 = (interrupt_enable[20] & !(ack_in && (ack_id == INT_ID_20))) ? ext_int20: 1'b0;
assign int21 = (interrupt_enable[21] & !(ack_in && (ack_id == INT_ID_21))) ? ext_int21: 1'b0;
assign int22 = (interrupt_enable[22] & !(ack_in && (ack_id == INT_ID_22))) ? ext_int22: 1'b0;
assign int23 = (interrupt_enable[23] & !(ack_in && (ack_id == INT_ID_23))) ? ext_int23: 1'b0;
assign int24 = (interrupt_enable[24] & !(ack_in && (ack_id == INT_ID_24))) ? ext_int24: 1'b0;
assign int25 = (interrupt_enable[25] & !(ack_in && (ack_id == INT_ID_25))) ? ext_int25: 1'b0;
assign int26 = (interrupt_enable[26] & !(ack_in && (ack_id == INT_ID_26))) ? ext_int26: 1'b0;
assign int27 = (interrupt_enable[27] & !(ack_in && (ack_id == INT_ID_27))) ? ext_int27: 1'b0;
assign int28 = (interrupt_enable[28] & !(ack_in && (ack_id == INT_ID_28))) ? ext_int28: 1'b0;
assign int29 = (interrupt_enable[29] & !(ack_in && (ack_id == INT_ID_29))) ? ext_int29: 1'b0;
assign int30 = (interrupt_enable[30] & !(ack_in && (ack_id == INT_ID_30))) ? ext_int30: 1'b0;
assign int31 = (interrupt_enable[31] & !(ack_in && (ack_id == INT_ID_31))) ? ext_int31: 1'b0;
assign int32 = (interrupt_enable[32] & !(ack_in && (ack_id == INT_ID_32))) ? ext_int32: 1'b0;
assign int33 = (interrupt_enable[33] & !(ack_in && (ack_id == INT_ID_33))) ? ext_int33: 1'b0;
assign int34 = (interrupt_enable[34] & !(ack_in && (ack_id == INT_ID_34))) ? ext_int34: 1'b0;
assign int35 = (interrupt_enable[35] & !(ack_in && (ack_id == INT_ID_35))) ? ext_int35: 1'b0;
assign int36 = (interrupt_enable[36] & !(ack_in && (ack_id == INT_ID_36))) ? ext_int36: 1'b0;
assign int37 = (interrupt_enable[37] & !(ack_in && (ack_id == INT_ID_37))) ? ext_int37: 1'b0;
assign int38 = (interrupt_enable[38] & !(ack_in && (ack_id == INT_ID_38))) ? ext_int38: 1'b0;
assign int39 = (interrupt_enable[39] & !(ack_in && (ack_id == INT_ID_39))) ? ext_int39: 1'b0;
assign int40 = (interrupt_enable[40] & !(ack_in && (ack_id == INT_ID_40))) ? ext_int40: 1'b0;
assign int41 = (interrupt_enable[41] & !(ack_in && (ack_id == INT_ID_41))) ? ext_int41: 1'b0;
assign int42 = (interrupt_enable[42] & !(ack_in && (ack_id == INT_ID_42))) ? ext_int42: 1'b0;
assign int43 = (interrupt_enable[43] & !(ack_in && (ack_id == INT_ID_43))) ? ext_int43: 1'b0;
assign int44 = (interrupt_enable[44] & !(ack_in && (ack_id == INT_ID_44))) ? ext_int44: 1'b0;
assign int45 = (interrupt_enable[45] & !(ack_in && (ack_id == INT_ID_45))) ? ext_int45: 1'b0;
assign int46 = (interrupt_enable[46] & !(ack_in && (ack_id == INT_ID_46))) ? ext_int46: 1'b0;
assign int47 = (interrupt_enable[47] & !(ack_in && (ack_id == INT_ID_47))) ? ext_int47: 1'b0;


 always@(posedge ic_clk or ic_rst)//pending vectore formation
     begin
	      if(!ic_rst) 
		      interrupt_pending_o<= 48'b0;
		  else begin
		      
		      interrupt_pending_o<= {int47,int46,int45,int44,int43,int42,int41,int40,int39,int38,int37,int36,int35,int34,int33,int32,int31,int30,int29,int28,int27,int26,int25,int24,int23,int22,int21,int20,int19,int18,int17,int16,int15,int14,int13,int12,int11,int10,int9,int8,int7,int6,int5,int4,int3,int2,int1,int0};
		 
		   end
	  end
 
 endmodule

