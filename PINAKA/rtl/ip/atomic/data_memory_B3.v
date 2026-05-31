//			DATA_MEMORY MODULE TO READ AND WRITE FOR FIRST BYTE OF WORD


module 		data_memory_B3 		(

						input 		clk 			,	// 	CLOCK
						input 		rst 			,	//	RESET
						input 		write_en_B3 		,	//	WRITE ENABLE
						input 	[9:0] 	read_address_B3 	,	//	READ ADDRESS
						input 	[9:0] 	write_address_B3 	,	//	WRITE ADDRESS
						input 	[7:0] 	data_in_B3 		,	//	DATA IN OF DATA MEMORY

						output 	[7:0] 	data_out_B3 			//	DATA OUT OF DATA MEMORY

					) 						;

//			USED .HEX FILE TO HAVE INITIAL VALUE IN MEMORY SO HELP IN VERIFICATION

initial begin
$readmemh("mem_B3.hex", mem_B3) 	;
end

integer 	i 			;


// 		ACTUAL MEMORY OF 1KB

reg 	[7:0] 	mem_B3 	[0:1023] 	;



// 		MEMORY WRITE OPEARTION

always@(posedge clk or posedge rst)
begin

// 		RESET CONDITION

if(rst)
begin

for(i=0; i<1024; i=i+1)
mem_B3[i] 			<= 	8'd0 				;

end
	
//		WRITE ENABLE WHEN LOGIC 1

else if(write_en_B3)
mem_B3[write_address_B3] 	<= 	data_in_B3 			;

end



// 		READIND DATA FROM MEMORY ADDRESS SPECIFIED BY READ_ADDRESS SIGNAL

assign 		data_out_B3 	= 	mem_B3[read_address_B3] 	;


endmodule



