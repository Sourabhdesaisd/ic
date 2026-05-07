module top;

  import uvm_pkg::*;
  import zic_pkg::*;

  logic clk;

  zic_intf vif(clk);

  zilla_interrupt_control DUT(.zic_clk(vif.clk),				
		                      .zic_rst(vif.zic_rst),
		                      .zic_mmr_write_en_i(vif.zic_mmr_write_en_i),
	                          .zic_mmr_write_addr_i(vif.zic_mmr_write_addr_i),
	                          .zic_mmr_write_data_i(vif.zic_mmr_write_data_i),
		                      .zic_mmr_read_en_i(vif.zic_mmr_read_en_i),
		                      .zic_mmr_read_addr_i(vif.zic_mmr_read_addr_i),
 	                          .zic_mmr_read_data_o(vif.zic_mmr_read_data_o),
		                      .zic_ack_read_valid_en(vif.zic_ack_read_valid_en),
 	                          .zic_ack_int_id_o(vif.zic_ack_int_id_o),
		                      .zic_eoi_valid_i(vif.zic_eoi_valid_i),
                              .zic_eoi_id_i(vif.zic_eoi_id_i),
	                          .active_lvl_pr_i(vif.active_lvl_pr_i),
 		                      .interrupt_request_o(vif.interrupt_request_o),
	                          .global_int_enable_bit_i(vif.global_int_enable_bit_i),
 	  	                      .global_int_enable_valid_i(vif.global_int_enable_valid_i),
                              .highest_pending_lvl_pr_o(vif.highest_pending_lvl_pr_o),
		                      .ext_int0_i(vif.ext_int0_i),	 
		                      .ext_int1_i(vif.ext_int1_i),	 
		                      .ext_int2_i(vif.ext_int2_i),	 
		                      .ext_int3_i(vif.ext_int3_i),	 
		                      .ext_int4_i(vif.ext_int4_i),	 
		                      .ext_int5_i(vif.ext_int5_i),	 
		                      .ext_int6_i(vif.ext_int6_i),	 
		                      .ext_int7_i(vif.ext_int7_i),	 
		                      .ext_int8_i(vif.ext_int8_i),	 
		                      .ext_int9_i(vif.ext_int9_i),	 
		                      .ext_int10_i(vif.ext_int10_i),	 
		                      .ext_int11_i(vif.ext_int11_i),	 
		                      .ext_int12_i(vif.ext_int12_i),	 
		                      .ext_int13_i(vif.ext_int13_i),	 
		                      .ext_int14_i(vif.ext_int14_i),	 
		                      .ext_int15_i(vif.ext_int15_i),	 
		                      .ext_int16_i(vif.ext_int16_i),	 
		                      .ext_int17_i(vif.ext_int17_i),	 
		                      .ext_int18_i(vif.ext_int18_i),	 
		                      .ext_int19_i(vif.ext_int19_i),	 
		                      .ext_int20_i(vif.ext_int20_i),	 
		                      .ext_int21_i(vif.ext_int21_i),	 
		                      .ext_int22_i(vif.ext_int22_i),	 
		                      .ext_int23_i(vif.ext_int23_i),	 
		                      .ext_int24_i(vif.ext_int24_i),	 
		                      .ext_int25_i(vif.ext_int25_i),	 
		                      .ext_int26_i(vif.ext_int26_i),	 
		                      .ext_int27_i(vif.ext_int27_i),	 
		                      .ext_int28_i(vif.ext_int28_i),	 
		                      .ext_int29_i(vif.ext_int29_i),	 
		                      .ext_int30_i(vif.ext_int30_i),	 
		                      .ext_int31_i(vif.ext_int31_i),	 
		                      .ext_int32_i(vif.ext_int32_i),	 
		                      .ext_int33_i(vif.ext_int33_i),	 
		                      .ext_int34_i(vif.ext_int34_i),	 
		                      .ext_int35_i(vif.ext_int35_i),	 
		                      .ext_int36_i(vif.ext_int36_i),	 
		                      .ext_int37_i(vif.ext_int37_i),	 
		                      .ext_int38_i(vif.ext_int38_i),	 
		                      .ext_int39_i(vif.ext_int39_i),	 
		                      .ext_int40_i(vif.ext_int40_i),	 
		                      .ext_int41_i(vif.ext_int41_i),	 
		                      .ext_int42_i(vif.ext_int42_i),	 
		                      .ext_int43_i(vif.ext_int43_i),	 
		                      .ext_int44_i(vif.ext_int44_i),	 
		                      .ext_int45_i(vif.ext_int45_i),	 
		                      .ext_int46_i(vif.ext_int46_i),	 
		                      .ext_int47_i(vif.ext_int47_i));

   ////  DUT INTERNAL SIGNALS  ////
   assign vif.eoi_mem_id       = DUT.zic_mmr_top_inst.zic_mmr_reg_file_inst.zic_eoi_o;
   assign vif.int_pending_bits = DUT.zic_top_inst.interrupt_pending_o;



  always #5 clk = ~clk;

  initial
  begin
    clk = 0;
  end



 initial
 begin

    $shm_open("wave.shm");
    $shm_probe("ACTMF");
    uvm_config_db#(virtual zic_intf)::set(null,"","vif",vif);
    run_test("zic_test");
    run_test("zic_config_test");
    run_test("zic_rand_test");
    run_test("zic_rand2_test");
    run_test("zic_rand3_test");
    run_test("zic_test2");
    run_test("zic_mem_test");



  end 

endmodule
