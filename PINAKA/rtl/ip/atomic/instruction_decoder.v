//						INSTRUCTION DECODER MODULE



module 		instruction_decoder 		(

							input 		[6:0] 	opcode 			,
							input 		[6:0] 	func7 			,
							input 		[2:0] 	func3	 		,
							
                                    			output 	reg 		sel_data_for_mem 	,
                                    			output 	reg 		write_reg_en 		,
                                    			output 	reg 		write_mem_en_amo 	,
                                    			output  reg		write_mem_en_store 	,
                                    			output 	reg 		set_reservation 	,	
                                    			output 	reg 	[2:0] 	alu_op 			,
							output 	reg 		is_non_atomic_inst	,
							output	reg 		is_lui_inst		,
							output	reg		is_addi_inst		,
							output 	reg 		is_auipc_inst		
                                    			
                                    		)							;



always@(opcode or func3 or func7)
begin


case(opcode)

// ATOMIC INSTRUCTION

7'b0101111 :
begin

// ATOMIC_32 INSTRUCTION

if(func3 == 3'b010)
begin

case(func7)

// LOAD INSTRUCTION

7'b0001000: begin

sel_data_for_mem 	=	1'b0 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b0 		;
set_reservation 	= 	1'b1 		;
alu_op 			= 	3'b000 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

// STORE INSTRUCTION

7'b0001100: begin

sel_data_for_mem 	=	1'b0 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b0 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b000 		;
write_mem_en_store 	= 	1'b1 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

// SWAP INSTRUCTION

7'b0000100: begin

sel_data_for_mem 	=	1'b0 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b1 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b000		;	
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

// ADD INSTRUCTION

7'b0000000: begin

sel_data_for_mem 	=	1'b1 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b1 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b000 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

// XOR INSTRUCTION

7'b0010000: begin

sel_data_for_mem 	=	1'b1 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b1 		;
set_reservation 	= 	1'b0		;
alu_op 			= 	3'b001 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

// AND INSTRUCTION

7'b0110000: begin

sel_data_for_mem 	=	1'b1 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b1 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b010 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

// OR INSTRUCTION

7'b0100000: begin

sel_data_for_mem 	=	1'b1 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b1 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b011 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

// SIGNED MIN INSTRUCTION

7'b1000000: begin

sel_data_for_mem 	=	1'b1 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	=	1'b1 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b100 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

// SIGNED MAX INSTRUCTION

7'b1010000: begin

sel_data_for_mem	=	1'b1 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b1 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b101 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

// UNSIGNED MIN INSTRUCTION

7'b1100000: begin

sel_data_for_mem 	=	1'b1 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b1 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b110 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

// UNSIGNED MAX INSTRUCTION

7'b1110000: begin

sel_data_for_mem 	=	1'b1 		;
write_reg_en		= 	1'b1 		;
write_mem_en_amo 	= 	1'b1 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b111 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

default : begin

sel_data_for_mem 	=	1'b0 		;	
write_reg_en 		= 	1'b0 		;
write_mem_en_amo 	= 	1'b0 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b000 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

endcase

end

else begin

sel_data_for_mem 	=	1'b0 		;
write_reg_en 		= 	1'b0 		;
write_mem_en_amo 	= 	1'b0 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b000 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

end

7'b0110111 : begin

sel_data_for_mem 	=	1'b0 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b0 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b000 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b1		;
is_lui_inst		= 	1'b1		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

7'b0010011 : begin

if(func3 == 3'b000)
begin

sel_data_for_mem 	=	1'b0 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b0 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b000 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b1		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b1 		;
is_auipc_inst		= 	1'b0		;

end

else begin

sel_data_for_mem 	=	1'b0 		;
write_reg_en 		= 	1'b0 		;
write_mem_en_amo 	= 	1'b0 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b000 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

end

7'b0010111 : begin

sel_data_for_mem 	=	1'b0 		;
write_reg_en 		= 	1'b1 		;
write_mem_en_amo 	= 	1'b0 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b000 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b1		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b1		;

end

default : begin

sel_data_for_mem 	=	1'b0 		;
write_reg_en 		= 	1'b0 		;
write_mem_en_amo 	= 	1'b0 		;
set_reservation 	= 	1'b0 		;
alu_op 			= 	3'b000 		;
write_mem_en_store 	= 	1'b0 		;
is_non_atomic_inst 	= 	1'b0		;
is_lui_inst		= 	1'b0		;
is_addi_inst		= 	1'b0 		;
is_auipc_inst		= 	1'b0		;

end

endcase

end


endmodule


