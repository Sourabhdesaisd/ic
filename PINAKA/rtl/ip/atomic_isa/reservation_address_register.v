//		32 BIT RESERVATION ADDRESS REGISTER MODULE


module 		reservation_address_register 		(

								input 			ld 		,
								input 			clk 		,
								input 			rst 		,
								
								input 		[31:0] 	mem_reservation_address_in 	,
	
								output 	reg 	[31:0] 	mem_reservation_address_out 

							) 						;


always@(posedge clk or posedge rst) 
begin

if(rst) begin
mem_reservation_address_out 	<= 	32'd0 				;
end


else if (ld) begin
mem_reservation_address_out 	<= 	mem_reservation_address_in 	;
end


end


endmodule


