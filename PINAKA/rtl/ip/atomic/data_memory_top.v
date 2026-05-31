//					ALIGNED MEMORY ACCESS OF BYTE ADDRESSABLE DATA MEMORY TOP MODULE 


module 		data_memory_top 	(

						input clk 			,	//	CLOCK
						input rst 			,	//	RESET
						input write_en 			,	//	WRITE ENABLE
						input [9:0] read_address 	,	//	READ ADDRESSS
						input [9:0] write_address 	,	//	WRITE ADDRESS
						input [31:0] data_in 		,	//	DATA IN FOR MEMORY	

						output [31:0] data_out 			//	DATA OUT FOR MEMORY

					) 					;


wire 	[7:0] 	data_out_B0 ;
wire 	[7:0]	data_out_B1 ;
wire 	[7:0] 	data_out_B2 ;
wire 	[7:0]	data_out_B3 ;



// 				CONCATENATE ALL OUTPUT OF BYTE ADDRESSABLE MEMORY ACCORDING TO LITTE ENDIAN

assign 		data_out 	= { data_out_B3 , data_out_B2 , data_out_B1 , data_out_B0 } 	;



//				BYTE ADDRESSABLE MEMORY INSTANCE OF BYTE 0

data_memory_B0 		memory_B0 		(

							.clk(clk) 				,
							.rst(rst) 				,
							.write_en_B0(write_en) 			,
							.read_address_B0(read_address) 		,
							.write_address_B0(write_address) 	,
							.data_in_B0(data_in[7:0]) 		,// GIVING LAST BYTE OF INPUT
							.data_out_B0(data_out_B0)

						) 						;

//				BYTE ADDRESSABLE MEMORY INSTANCE OF BYTE 1

data_memory_B1 		memory_B1 		(

							.clk(clk) 				,
							.rst(rst) 				,
							.write_en_B1(write_en) 			,
							.read_address_B1(read_address)	 	,
							.write_address_B1(write_address) 	,
							.data_in_B1(data_in[15:8]) 		,// GIVING LAST SECOND BYTE OF INPUT
							.data_out_B1(data_out_B1)

						) 						;

//				BYTE ADDRESSABLE MEMORY INSTANCE OF BYTE 2

data_memory_B2 		memory_B2 		(

							.clk(clk) 				,
							.rst(rst) 				,
							.write_en_B2(write_en) 			,
							.read_address_B2(read_address) 		,
							.write_address_B2(write_address)	,
							.data_in_B2(data_in[23:16]) 		,// GIVING LAST THIRD BYTE OF INPUT
							.data_out_B2(data_out_B2)

						) 						;

//				BYTE ADDRESSABLE MEMORY INSTANCE OF BYTE 3

data_memory_B3 		memory_B3 		(

							.clk(clk) 				,
							.rst(rst) 				,
							.write_en_B3(write_en) 			,
							.read_address_B3(read_address) 		,
							.write_address_B3(write_address) 	,
							.data_in_B3(data_in[31:24]) 		,// GIVING FIRST BYTE OF INPUT
							.data_out_B3(data_out_B3)

						) 						;




endmodule
