//			DATA_MEMORY MODULE TO READ AND WRITE FOR LAST BYTE OF WORD


module 		data_memory_B0 		(

						input 		clk 			,	// 	CLOCK
						input 		rst 			,	//	RESET
						input 		write_en_B0 		,	//	WRITE ENABLE
						input 	[9:0] 	read_address_B0 	,	//	READ ADDRESS
						input 	[9:0] 	write_address_B0 	,	//	WRITE ADDRESS
						input 	[7:0] 	data_in_B0 		,	//	DATA IN OF DATA MEMORY

						output 	[7:0] 	data_out_B0 			//	DATA OUT OF DATA MEMORY

					) 						;

//			USED .HEX FILE TO HAVE INITIAL VALUE IN MEMORY SO HELP IN VERIFICATION

initial begin
$readmemh("mem_B0.hex", mem_B0) 	;
end

integer 	i 			;


// 		ACTUAL MEMORY OF 1KB

reg 	[7:0] 	mem_B0 	[0:1023] 	;



// 		MEMORY WRITE OPEARTION

always@(posedge clk or posedge rst)
begin

// 		RESET CONDITION

if(rst)
begin

for(i=0; i<1024; i=i+1)
mem_B0[i] 			<= 	8'd0 				;

end
	
//		WRITE ENABLE WHEN LOGIC 1

else if(write_en_B0)
mem_B0[write_address_B0] 	<= 	data_in_B0 			;

end




// 		READIND DATA FROM MEMORY ADDRESS SPECIFIED BY READ_ADDRESS SIGNAL

assign 		data_out_B0 	= 	mem_B0[read_address_B0] 	;


endmodule


