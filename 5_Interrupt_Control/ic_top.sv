`timescale 1ns/1ps

//Default files to include
`include "uvm_macros.svh"
import uvm_pkg::*;

//User defined files to include
`include "/home/sgeuser111/DrRSK//5_Interrupt_Control/ic_intf.sv"
import ic_pkg::*;

module ic_top;
	logic ic_clk;

	//clock generation
	always #5 ic_clk = ~ic_clk;

	initial begin
		ic_clk =0;
	end

	//Interface instantiation
	ic_intf intf (.ic_clk(ic_clk));
	
	//DUT instantiation
	zilla_interrupt_control dut(
		.zic_mmr_read_data_o		(intf.ic_mmr_read_data_o	 ),
		.zic_ack_int_id_o		(intf.ic_ack_int_id_o		 ),
		.interrupt_request_o		(intf.interrupt_request_o	 ),
		.highest_pending_lvl_pr_o 	(intf.highest_pending_lvl_pr_o	 ),		
		.zic_clk			(intf.ic_clk                  	 ),
		.zic_rst			(intf.ic_rst			 ),
		.zic_mmr_write_en_i		(intf.ic_mmr_write_en_i		 ),
		.zic_mmr_write_addr_i	   	(intf.ic_mmr_write_addr_i	 ),
		.zic_mmr_write_data_i	    	(intf.ic_mmr_write_data_i	 ),
		.zic_mmr_read_en_i	    	(intf.ic_mmr_read_en_i	 	 ),
		.zic_mmr_read_addr_i	       	(intf.ic_mmr_read_addr_i	 ),
		.zic_ack_read_valid_en	    	(intf.ic_ack_read_valid_en	 ),
		.zic_eoi_valid_i	   	(intf.ic_eoi_valid_i		 ),
		.zic_eoi_id_i		    	(intf.ic_eoi_id_i		 ),
		.active_lvl_pr_i	    	(intf.active_lvl_pr_i	 	 ),
		.global_int_enable_bit_i	(intf.global_int_enable_bit_i  	 ),
		.global_int_enable_valid_i  	(intf.global_int_enable_valid_i	 ),
		.ext_int0_i		        (intf.ext_int0_i		 ),	  
		.ext_int1_i		        (intf.ext_int1_i		 ),	  
		.ext_int2_i		        (intf.ext_int2_i		 ),	  
		.ext_int3_i		        (intf.ext_int3_i		 ),	  
		.ext_int4_i		        (intf.ext_int4_i		 ),	  
		.ext_int5_i		        (intf.ext_int5_i		 ),	  
		.ext_int6_i		        (intf.ext_int6_i		 ),	  
		.ext_int7_i			(intf.ext_int7_i		 ),	  
		.ext_int8_i		        (intf.ext_int8_i		 ),	  
		.ext_int9_i		        (intf.ext_int9_i		 ),	  
		.ext_int10_i		        (intf.ext_int10_i		 ),	  
		.ext_int11_i		        (intf.ext_int11_i		 ),	  
		.ext_int12_i		        (intf.ext_int12_i		 ),	  
		.ext_int13_i		        (intf.ext_int13_i		 ),	  
		.ext_int14_i		        (intf.ext_int14_i		 ),	  
		.ext_int15_i		        (intf.ext_int15_i		 ),	  
		.ext_int16_i		        (intf.ext_int16_i		 ),	  
		.ext_int17_i		        (intf.ext_int17_i		 ),	  
		.ext_int18_i		        (intf.ext_int18_i		 ),	  
		.ext_int19_i		        (intf.ext_int19_i		 ),	  
		.ext_int20_i		        (intf.ext_int20_i		 ),	  
		.ext_int21_i		        (intf.ext_int21_i		 ),	  
		.ext_int22_i		        (intf.ext_int22_i		 ),	  
		.ext_int23_i		        (intf.ext_int23_i		 ),	  
		.ext_int24_i		        (intf.ext_int24_i		 ),	  
		.ext_int25_i		        (intf.ext_int25_i		 ),	  
		.ext_int26_i		        (intf.ext_int26_i		 ),	  
		.ext_int27_i		        (intf.ext_int27_i		 ),	  
		.ext_int28_i		        (intf.ext_int28_i		 ),	  
		.ext_int29_i		        (intf.ext_int29_i		 ),	  
		.ext_int30_i		        (intf.ext_int30_i		 ),	  
		.ext_int31_i		        (intf.ext_int31_i		 ),	  
		.ext_int32_i		        (intf.ext_int32_i		 ),	  
		.ext_int33_i		        (intf.ext_int33_i		 ),	  
		.ext_int34_i		        (intf.ext_int34_i		 ),	  
		.ext_int35_i		        (intf.ext_int35_i		 ),	  
		.ext_int36_i		        (intf.ext_int36_i		 ),	  
		.ext_int37_i		        (intf.ext_int37_i		 ),	  
		.ext_int38_i		        (intf.ext_int38_i		 ),	  
		.ext_int39_i		        (intf.ext_int39_i		 ),	  
		.ext_int40_i		        (intf.ext_int40_i		 ),	  
		.ext_int41_i		        (intf.ext_int41_i		 ),	  
		.ext_int42_i		        (intf.ext_int42_i		 ),	  
		.ext_int43_i		        (intf.ext_int43_i		 ),	  
		.ext_int44_i		        (intf.ext_int44_i		 ),	  
		.ext_int45_i		        (intf.ext_int45_i		 ),	  
		.ext_int46_i		        (intf.ext_int46_i		 ),
		//.ext_int47_i		        (intf.ext_int47_i		 )
		.debug_mode_valid_i          	(intf.dbg_mode_valid_i		 )
		//.debug_mode_reset_i          	(),
		//.debug_ndm_reset_i           	(),
		//.wdt_reset_o                  ()
		);
	
	//config_db for Interface
	initial begin
		uvm_config_db#(virtual ic_intf)::set(null,"*","vif",intf);
	end

	//Initializig the Test
	initial begin
		run_test("");
	end
	
	//Waves
	initial begin
		$shm_open("waves.shm");
		$shm_probe("ACTMF");
	end

endmodule

